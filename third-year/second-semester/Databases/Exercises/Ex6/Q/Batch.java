import java.sql.*; // JDBC stuff.
import java.util.Properties;
import java.util.Scanner;
import java.io.*;  // Reading user input.

public class Batch {
    static final String DATABASE = "jdbc:postgresql://localhost/"; 
    static final String USERNAME = "postgres";
    static final String PASSWORD = "postgres";

    public static void main(String[] args) throws Exception {
        Class.forName("org.postgresql.Driver");
        Properties props = new Properties();
        props.setProperty("user",USERNAME);
        props.setProperty("password",PASSWORD);
        
        try (Connection conn = DriverManager.getConnection(DATABASE, props);
            Statement s = conn.createStatement()) { 
            int[] blockList = {11,42,55};
            PreparedStatement update = conn.prepareStatement(
              "UPDATE Users SET password='qiyh4XPJGsOZ2MEAyLkfWqeQ' WHERE id=?");
            PreparedStatement insert = conn.prepareStatement(
              "INSERT INTO Logbook VALUES (?,CURRENT_TIMESTAMP,'Account locked')");

            conn.setAutoCommit(false); // Enable transactions
            
            // For each user in blocklist, this should:
            //   modify their password (update)
            //   add an entry in their logbook (insert)
            // It should fail without any modifications if any user doesn't exist 
            for(int user : blockList){
                update.setInt(1,user);
                insert.setInt(1,user);
                int res = update.executeUpdate();
                if (res == 0){ // 0 rows
                  System.err.println("error, missing id: "+user);
                  conn.rollback();
                } else{
                  insert.executeUpdate();
                  conn.commit();
                }
            }

            
        } catch (SQLException e) {
            System.err.println(e);
            System.exit(2);
        }
        
    }
}