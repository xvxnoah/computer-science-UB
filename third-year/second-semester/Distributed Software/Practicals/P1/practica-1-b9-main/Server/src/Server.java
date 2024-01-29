import java.io.IOException;
import java.net.ServerSocket;
import java.net.Socket;
import java.nio.channels.IllegalBlockingModeException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Date;
import java.util.logging.FileHandler;
import java.util.logging.LogRecord;
import java.util.logging.Logger;
import java.util.logging.SimpleFormatter;

public class Server {
  public static final String INIT_ERROR = "Server should be initialized with -p <port> -m <0|1>";
  private static Logger logger;
  private static int numGame = 0;
  private static FileHandler fileHandler;
  private static Socket socket;
  private static Socket socket2;

  public static void main(String[] args) {
    startServer(args);
  }

  public static void startServer(String[] args) {

    if (args.length != 4) {
      throw new IllegalArgumentException("Wrong amount of arguments.\n" + INIT_ERROR);
    }

    if (!args[0].equals("-p")) {
      throw new IllegalArgumentException("Wrong argument keyword.\n" + INIT_ERROR);
    }

    if (!args[2].equals("-m")) {
      throw new IllegalArgumentException("Wrong argument keyword.\n" + INIT_ERROR);
    }

    int port;
    int game_mode;

    try {
      port = Integer.parseInt(args[1]);
    } catch (NumberFormatException e) {
      throw new NumberFormatException(
          "<port> should be an Integer. Use 0 for automatic allocation.");
    }

    try {
      game_mode = Integer.parseInt(args[3]);

      if (game_mode != 0 && game_mode != 1) {
        throw new IllegalArgumentException(
            "Invalid game mode. Use 0 for single player or 1 for multiplayer.");
      }
    } catch (NumberFormatException e) {
      throw new NumberFormatException("<game_mode> should be an Integer (0 or 1).");
    } catch (IllegalArgumentException e) {
      throw new IllegalArgumentException(e.getMessage());
    }

    ServerSocket ss = null;

    try {
      ss = new ServerSocket(port);
      System.out.println("Server up & listening on port " + port + "...\nPress Cntrl + C to stop.");
    } catch (IOException e) {
      throw new RuntimeException("I/O error when opening the Server Socket:\n" + e.getMessage());
    }

    socket = null;

    SimpleFormatter format =
        new SimpleFormatter() {
          private static final String format = "[%1$tF %1$tT] [%2$-7s] %n";

          @Override
          public synchronized String format(LogRecord lr) {
            return String.format(format, new Date(lr.getMillis()), lr.getMessage());
          }
        };

    /* Create folder Logs in case it doesn't exist */
    try {
      Path logsDir = Paths.get("Logs");
      if (!Files.exists(logsDir)) {
        Files.createDirectory(logsDir);
      }
    } catch (IOException e) {
      throw new RuntimeException("Error creating Logs directory:\n" + e.getMessage());
    }

    while (true) {
      try {
        if (game_mode == 0) {
          socket = ss.accept();
          System.out.println("\nClient accepted\n");
          socket.setSoTimeout(5000);

          fileHandler = new FileHandler("Logs/ServerGame-" + numGame + ".log");
          fileHandler.setFormatter(format);

          logger = Logger.getLogger("ServerGame-" + numGame);
          logger.setUseParentHandlers(false);
          logger.addHandler(fileHandler);
          logger.info("Client accepted");

          new GameHandler(socket, logger).start();

          numGame++;
        } else if (game_mode == 1) {
          socket = ss.accept();
          System.out.println("\nClient 1 accepted\n");
          socket.setSoTimeout(5000);

          socket2 = ss.accept();
          System.out.println("\nClient 2 accepted\n");
          socket2.setSoTimeout(5000);

          fileHandler = new FileHandler("Logs/ServerGameMultiplayer-" + numGame + ".log");
          fileHandler.setFormatter(format);

          logger = Logger.getLogger("ServerGameMultiplayer-" + numGame);
          logger.setUseParentHandlers(false);
          logger.addHandler(fileHandler);
          logger.info("Client 1 & 2 accepted");

          new GameHandler(socket, socket2, logger).start();

          numGame++;
        }
      } catch (IOException e) {
        throw new RuntimeException("I/O error when accepting a client:\n" + e.getMessage());
      } catch (SecurityException e) {
        throw new RuntimeException("Operation not accepted:\n" + e.getMessage());
      } catch (IllegalBlockingModeException e) {
        throw new RuntimeException(
            "There is no connection ready to be accepted:\n" + e.getMessage());
      }
    }
  }
}
