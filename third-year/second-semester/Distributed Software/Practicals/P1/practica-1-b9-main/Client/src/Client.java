import java.io.EOFException;
import java.io.IOException;
import java.net.ProtocolException;
import java.net.Socket;
import java.net.SocketException;
import java.net.UnknownHostException;

public class Client {

  public static final String INIT_ERROR = "Client should be initialized with -h <host> -p <port>";
  private static boolean connected = false;

  public static void main(String[] args) {
    startClient(args);
  }

  public static void startClient(String[] args) {

    if (args.length != 4) {
      throw new IllegalArgumentException("Wrong amount of arguments.\n" + INIT_ERROR);
    }

    if (!args[0].equals("-h") || !args[2].equals("-p")) {
      throw new IllegalArgumentException("Wrong argument keywords.\n" + INIT_ERROR);
    }

    int port;

    try {
      port = Integer.parseInt(args[3]);
    } catch (NumberFormatException e) {
      throw new NumberFormatException("<port> should be an Integer. Invalid port: " + args[3]);
    }

    String host = args[1];
    Socket socket = null;

    /* Try to establish a TCP connection to the specified host and port. */
    try {
      socket = new Socket(host, port);
      System.out.println("C-[TCP Connect]");
      connected = true;

      /* Start the game */
      new GameClient(new Utils(socket)).startData();
    } catch (IllegalArgumentException e) {
      throw new IllegalArgumentException("Proxy has invalid type or null:\n" + e.getMessage());
    } catch (SecurityException e) {
      throw new SecurityException(
          "Connection to the host denied for security reasons:\n" + e.getMessage());
    } catch (UnknownHostException e) {
      throw new RuntimeException("Host is Unknown:\n" + e.getMessage());
    } catch (ProtocolException e) {
      System.out.println("Error in protocol:\n" + e.getMessage());
    } catch (SocketException e) {
      System.out.println("\nSocket error: " + e.getMessage());
    } catch (EOFException e) {
      System.out.println("\nEOFException: Server disconnected from the game.");
    } catch (IOException e) {
      if (!connected) {
        throw new RuntimeException(
            "I/O Error when creating the socket:\n" + e.getMessage() + ". Is the host listening?");
      } else {
        if (e.getMessage().equals("Broken pipe")) {
          System.out.println("\nServer disconnected from the game.");
        } else {
          System.out.println("\nI/O Error: " + e.getMessage());
        }
      }
    } catch (RuntimeException e) {
      System.out.println("Runtime Exception: " + e.getMessage());
    } finally {
      try {
        if (socket != null) {
          socket.close();
          connected = false;
          System.out.println("\n-----DISCONNECTED FROM SERVER-----");
        }
      } catch (IOException e) {
        System.out.println("IOException: " + e.getMessage());
      }
    }
  }
}
