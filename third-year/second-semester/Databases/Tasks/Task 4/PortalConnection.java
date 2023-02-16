import java.sql.*; // JDBC stuff.
import java.util.Properties;
import org.json.*;

public class PortalConnection {

    // Set this to e.g. "portal" if you have created a database named portal
    // Leave it blank to use the default database of your database user
    static final String DBNAME = "";
    // For connecting to the portal database on your local machine
    static final String DATABASE = "jdbc:postgresql://localhost/"+DBNAME;
    static final String USERNAME = "postgres";
    static final String PASSWORD = "postgres";

    // For connecting to the chalmers database server (from inside chalmers)
    // static final String DATABASE = "jdbc:postgresql://brage.ita.chalmers.se/";
    // static final String USERNAME = "tda357_nnn";
    // static final String PASSWORD = "yourPasswordGoesHere";


    // This is the JDBC connection object you will be using in your methods.
    private Connection conn;

    public PortalConnection() throws SQLException, ClassNotFoundException {
        this(DATABASE, USERNAME, PASSWORD);  
    }

    // Initializes the connection, no need to change anything here
    public PortalConnection(String db, String user, String pwd) throws SQLException, ClassNotFoundException {
        Class.forName("org.postgresql.Driver");
        Properties props = new Properties();
        props.setProperty("user", user);
        props.setProperty("password", pwd);
        conn = DriverManager.getConnection(db, props);
    }


    // Register a student on a course, returns a tiny JSON document (as a String)
    public String register(String student, String courseCode){
        try(PreparedStatement st = conn.prepareStatement(
                "INSERT INTO Registrations (student, course) VALUES(?, ?)"
        );) {
            st.setString(1, student);
            st.setString(2, courseCode);
            st.execute();

            if(st.getUpdateCount() == 1){
                return "{'success': true}";
            } else {
                return "{'success': false, 'error'}";
            }
        } catch (SQLException throwables){
            return "{\"success\":false, \"error\":\"" + throwables.getMessage().replaceAll("\n", " ")
                    + "\"}";
        }
    }

    // Unregister a student from a course, returns a tiny JSON document (as a String)
    public String unregister(String student, String courseCode){
        String query = "DELETE FROM Registrations WHERE student='"+student+"' AND course='"+courseCode+"'";

        try(PreparedStatement st = conn.prepareStatement(query);) {

            st.execute();

            if (st.getUpdateCount() == 1) {
                return "{'success': true}";
            } else {
                return "{'success': false, 'error': 'we messed up'}";
            }
        } catch (SQLException throwables){
            return "{\"success\":false, \"error\":\"" + throwables.getMessage().replaceAll("\n", " ")
                    + "\"}";
        }
    }

    // Return a JSON document containing lots of information about a student, it should validate against the schema found in information_schema.json
    public String getInfo(String student) throws SQLException{

        /* Use Java string manipulation to build the JSON document */
        try{PreparedStatement stInfo = conn.prepareStatement(
                "SELECT jsonb_build_object('student', student, 'name', name, 'login', login, 'program', program,"
                        + "                          'branch', branch, 'seminarCourses', seminarCourses, 'mathCredits', mathCredits,"
                        + "                          'researchCredits', researchCredits, 'totalCredits', totalCredits,"
                        + "                          'canGraduate',canGraduate) AS jsondata FROM"
                        + "    (SELECT idnr as student, name, login, program, branch FROM BasicInformation) AS basicInfo NATURAL JOIN"
                        + "    (SELECT student, seminarCourses, mathCredits, researchCredits, totalCredits, qualified AS canGraduate FROM PathToGraduation) AS gradInfo"
                        + "    WHERE student=?;"
            );
            stInfo.setString(1, student);
            
            PreparedStatement stFinished = conn.prepareStatement(
                    "SELECT jsonb_build_object('course', name, 'code', course, 'credits', credits, 'grade', grade) AS jsondata"
                            + "    FROM FinishedCourses WHERE student=?;"
            );

            stFinished.setString(1, student);

            PreparedStatement stRegistered = conn.prepareStatement(
                    "SELECT jsonb_build_object('course', name, 'code', course, 'status', status, 'position', position) AS jsondata "
                            + "FROM Registrations AS r LEFT JOIN Courses AS c ON r.course = c.code "
                            + "WHERE student = ?;"
            );
            stRegistered.setString(1, student);

            ResultSet rsInfo = stInfo.executeQuery();
            ResultSet rsFinished = stFinished.executeQuery();
            ResultSet rsRegistered = stRegistered.executeQuery();

            if (rsInfo.next()) {
                JSONObject json = new JSONObject(rsInfo.getString("jsondata"));
                json.put("finished", new JSONArray());
                while (rsFinished.next()) {
                    json.append("finished", new JSONObject(rsFinished.getString("jsondata")));
                }

                json.put("registered", new JSONArray());
                while (rsRegistered.next()) {
                    json.append("registered", new JSONObject(rsRegistered.getString("jsondata")));
                }

                return json.toString();
            } else {
                return "{\"student\":\"does not exist :(\"}";
            }
        } catch (SQLException throwables) {
            throwables.printStackTrace();
        }
        return "{'success':false, error: 'View logs to see error'}";
            
    }

    public int getNWaitingStudents(String course) {
        try {
            var ps = conn.prepareStatement(
                    "SELECT COUNT(*) AS waits FROM Registrations WHERE status='waiting' AND course=?");
            ps.setString(1, course);

            var rs = ps.executeQuery();
            if(rs.next()) {
                return rs.getInt("waits");
            } else {
                return 0;
            }
        } catch (SQLException e) {
            return 0;
        }
    }

    // This is a hack to turn an SQLException into a JSON string error message. No need to change.
    public static String getError(SQLException e){
       String message = e.getMessage();
       int ix = message.indexOf('\n');
       if (ix > 0) message = message.substring(0, ix);
       message = message.replace("\"","\\\"");
       return message;
    }
}