import org.json.JSONArray;
import org.json.JSONObject;

public class TestPortal {

   // enable this to make pretty printing a bit more compact
   private static final boolean COMPACT_OBJECTS = false;

   /*
   * Check if JSONArray contains specified course
   * */

    public static boolean containsCourse(JSONArray courses, String courseCode){
        for(var i = 0; i < courses.length(); i++){
            if(courses.getJSONObject(i).getString("code").equals(courseCode)){
                return true;
            }
        }
        return false;
    }

   // This class creates a portal connection and runs a few operation

   public static void main(String[] args) {
      try{
         PortalConnection c = new PortalConnection();

         /* List info for a student */
          System.out.println("----TEST1----");
          System.out.println("Should follow provided json schema.");
          prettyPrint(c.getInfo("2222222222"));
          pause();

          /* Register the student for an unrestricted course, and check that they end up registered (print info again). */
          System.out.println("----TEST2----");
          System.out.println(
                  (new JSONObject(c.register("6666666666", "CCC111")).getBoolean("success")));
          pause();

          /* Register the same student for the same course again, and check that you get an error response. */
          System.out.println("----TEST3----");
          System.out.println(
                  !(new JSONObject(c.register("6666666666", "CCC111")).getBoolean("success")));
          pause();

          /* Unregister the student from the course, and then unregister again from the same course.
          Check that the student is no longer registered and the second unregistration gives an error response.
           */
          System.out.println("----TEST4----");

          var json = new JSONObject(c.getInfo("6666666666"));
          System.out.println(containsCourse(json.getJSONArray("registered"), "CCC111"));

          System.out.println(
                  (new JSONObject(c.unregister("6666666666", "CCC111")).getBoolean("success")));

          json = new JSONObject(c.getInfo("6666666666"));
          System.out.println(!containsCourse(json.getJSONArray("registered"), "CCC111"));

          System.out.println(
                  !(new JSONObject(c.unregister("6666666666", "CCC111")).getBoolean("success")));

          json = new JSONObject(c.getInfo("6666666666"));
          System.out.println(!containsCourse(json.getJSONArray("registered"), "CCC111"));

          pause();

          /* Register the student for a course that they don't have the prerequisites for, and check that an error is generated. */
          System.out.println("----TEST5----");

          System.out.println(!new JSONObject(c.register("1111111111", "CCC555")).getBoolean("success"));
          pause();

          /* Unregister a student from a restricted course that they are registered to,
          and which has at least two students in the queue. Register again to the same course and check
          that the student gets the correct (last) position in the waiting list.
          */
          System.out.println("----TEST6----");

          System.out.println("Check that student is registered to CCC666");
          prettyPrint(new JSONObject(c.getInfo("3333333333")).getJSONArray("registered").toString());
          System.out.println(
                  new JSONObject(c.unregister("3333333333", "CCC666")).getBoolean("success"));
          System.out.println(
                  new JSONObject(c.register("3333333333", "CCC666")).getBoolean("success"));
          System.out.println("\nCheck that student is last in queue to CCC666");
          prettyPrint(new JSONObject(c.getInfo("3333333333")).getJSONArray("registered").toString());

          pause();

          /* Unregister and re-register the same student for the same restricted course,
           and check that the student is first removed and then ends up in the same position as before (last).
          */
          System.out.println("----TEST7----");
          String position1 = c.getInfo("3333333333");
          System.out.println(new JSONObject(c.unregister("3333333333", "CCC666")).getBoolean("success"));

          System.out.println(new JSONObject(c.register("3333333333", "CCC666")).getBoolean("success"));
          String position2 = c.getInfo("3333333333");
          System.out.println(position1.equals(position2));

          pause();

          /* Unregister a student from an overfull course, i.e. one with more students registered than there
           are places on the course (you need to set this situation up in the database directly).
           Check that no student was moved from the queue to being registered as a result.
          */
          System.out.println("----TEST8----");
          int numWaitingStudents = c.getNWaitingStudents("CCC222");
          System.out.println(new JSONObject(c.unregister("5555555555", "CCC222")).getBoolean("success"));
          System.out.println(numWaitingStudents == c.getNWaitingStudents("CCC222"));
          pause();

          /* SQL Injection! */
          System.out.println("----TEST9----");
          System.out.println(!new JSONObject(c.unregister("1111111111", "CCC222' OR 'a'='a")).getBoolean("success"));

          /* Check that it worked */
          System.out.println(new JSONObject(c.getInfo("1111111111")).getJSONArray("registered").length() == 0);
          pause();

      } catch (ClassNotFoundException e) {
         System.err.println("ERROR!\nYou do not have the Postgres JDBC driver (e.g. postgresql-42.2.18.jar) in your runtime classpath!");
      } catch (Exception e) {
         e.printStackTrace();
      }
   }
   
   
   
   public static void pause() throws Exception{
     System.out.println("PRESS ENTER");
     while(System.in.read() != '\n');
   }
   
   // This is a truly horrible and bug-riddled hack for printing JSON. 
   // It is used only to avoid relying on additional libraries.
   // If you are a student, please avert your eyes.
   public static void prettyPrint(String json){
      System.out.print("Raw JSON:");
      System.out.println(json);
      System.out.println("Pretty-printed (possibly broken):");
      
      int indent = 0;
      json = json.replaceAll("\\r?\\n", " ");
      json = json.replaceAll(" +", " "); // This might change JSON string values :(
      json = json.replaceAll(" *, *", ","); // So can this
      
      for(char c : json.toCharArray()){
        if (c == '}' || c == ']') {
          indent -= 2;
          breakline(indent); // This will break string values with } and ]
        }
        
        System.out.print(c);
        
        if (c == '[' || c == '{') {
          indent += 2;
          breakline(indent);
        } else if (c == ',' && !COMPACT_OBJECTS) 
           breakline(indent);
      }
      
      System.out.println();
   }
   
   public static void breakline(int indent){
     System.out.println();
     for(int i = 0; i < indent; i++)
       System.out.print(" ");
   }   
}