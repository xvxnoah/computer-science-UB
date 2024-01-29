import java.io.IOException;
import java.net.Socket;
import java.net.SocketTimeoutException;
import java.util.logging.Logger;

public class GameHandler extends Thread {

  /* Variables for the opcodes */
  public static final int OPCODE_HELLO = 1;
  public static final int OPCODE_READY = 2;
  public static final int OPCODE_PLAY = 3;
  public static final int OPCODE_ADMIT = 4;
  public static final int OPCODE_ACTION = 5;
  public static final int OPCODE_RESULT = 6;
  public static final int OPCODE_ERROR = 8;

  /* Variables for the errors codes */
  public static final int MSG_OUT_OF_PROTOCOL = 3;
  public static final int WRONG_LOG_IN = 4;
  public static final int UNKNOWN_WORD = 5;
  public static final int WRONG_MSG_FORMAT = 6;

  private static final int MAX_TIMEOUT = 180;

  private Utils utils;
  private Utils utils2;
  private Logger logger;

  private Socket socket;
  private Socket socket2;
  private int timeOuts;
  private int timeOuts2;
  private int state = OPCODE_HELLO;
  private GameProtocol protocol; // Instance of GameProtocol to handle the communication protocol

  /**
   * C O N S T R U C T O R (Single player)
   *
   * @param socket socket to communicate with the client
   * @throws SocketTimeoutException
   */
  public GameHandler(Socket socket, Logger logger) throws SocketTimeoutException {
    this.socket = socket;
    this.timeOuts = 0;
    this.utils2 = null;
    this.logger = logger;
    try {
      // Initialize the input and output streams for the socket
      utils = new Utils(socket);
    } catch (IOException e) {
      throw new RuntimeException(
          "I/O error when opening socket streams:\n"
              + e.getMessage()); // Throw an exception if there is an error initializing the streams
    }
    protocol =
        new GameProtocol(
            utils,
            logger); // Initialize the GameProtocol instance to handle the communication protocol
  }

  /**
   * C O N S T R U C T O R (Multiplayer)
   *
   * @param socket1 socket to communicate with the client
   * @param socket2 socket to communicate with the client
   * @throws SocketTimeoutException
   */
  public GameHandler(Socket socket1, Socket socket2, Logger logger) throws SocketTimeoutException {
    this.socket = socket1;
    this.socket2 = socket2;
    this.timeOuts = 0;
    this.logger = logger;
    try {
      // Initialize the input and output streams for the socket
      utils = new Utils(socket1);
      utils2 = new Utils(socket2);
    } catch (IOException e) {
      throw new RuntimeException(
          "I/O error when opening socket streams:\n"
              + e.getMessage()); // Throw an exception if there is an error initializing the streams
    }
    protocol =
        new GameProtocol(
            utils, utils2,
            logger); // Initialize the GameProtocol instance to handle the communication protocol
  }

  // ADAPT TO HANDLE TWO CLIENTS
  public void run() {
    try {
      play();
    } catch (SocketTimeoutException e) {
      if (utils2 == null) {
        if (timeOuts < MAX_TIMEOUT) {
          timeOuts++;
          run();
        } else {
          System.out.println("Client has been playing for a long time. Disconnecting him.");
          logger.info("Client has been playing for a long time. Disconnecting him.");
          try {
            socket.close();
          } catch (IOException e1) {
            e1.printStackTrace();
          }
        }
      } else {
        if (timeOuts < MAX_TIMEOUT && timeOuts2 < MAX_TIMEOUT) {
          timeOuts++;
          timeOuts2++;
          run();
        } else if (timeOuts >= MAX_TIMEOUT && timeOuts2 >= MAX_TIMEOUT) {
          System.out.println(
              "Clients have been waiting for a long time. Disconnecting from the game.");
          logger.info("Client 1 has been playing for a long time. Disconnecting from the game.");
          try {
            socket.close();
            socket2.close();
          } catch (IOException e1) {
            e1.printStackTrace();
          }
        }
      }
    } catch (IOException e) {
      try {
        if (utils2 == null) {
          if (utils.getInput().available() == 0) {
            System.out.println("\nClient has disconnected.");
            logger.info("Client has disconnected.");

            socket.close();
          }
        } else {
          if (utils.getInput().available() == 0) {
            System.out.println("\nClient 1 has disconnected. Disconnecting from the game.");
            logger.info("Client 1 has disconnected. Disconnecting from the game.");

            socket.close();
            socket2.close();
          } else if (utils2.getInput().available() == 0) {
            System.out.println("\nClient 2 has disconnected. Disconnecting from the game.");
            logger.info("Client 2 has disconnected. Disconnecting from the game.");

            socket.close();
            socket2.close();
          }
        }
      } catch (IOException e1) {
        System.out.println("\nError when closing the socket: " + e1.getMessage());
      }
    }
  }

  /** P L A Y */
  public void play() throws IOException {
    boolean exit = false;
    while (!exit) {
      switch (state) {
        case OPCODE_HELLO:
          if (readOpcode()) {
            state = protocol.receiveHello(); // Wait for a "hello" message from the client
          }
          break;

        case OPCODE_READY:
          state = protocol.sendReady(); // Send a "ready" message to the client with the server ID
          break;

        case OPCODE_PLAY:
          if (readOpcode()) {
            state = protocol.receivePlay(); // Wait for a "play" message from the client
          }
          break;

        case OPCODE_ADMIT:
          state = protocol.sendAdmit(); // Send an "admit" message to the client with the server ID
          break;

        case OPCODE_ACTION:
          if (readOpcode()) {
            state = protocol.receiveAction(); // Wait for a "action" message from the client
          }
          break;
        case OPCODE_RESULT:
          state = protocol.sendResult();
          break;
      }
    }
  }

  /*
  A U X I L I A R S
   */
  public boolean readOpcode() throws IOException {
    int opcode = 0;
    opcode = utils.read1ByteAsInteger();

    if (utils2 != null) {
      int opcode2 = 0;
      opcode2 = utils2.read1ByteAsInteger();

      if (opcode == state && opcode2 == state) {
        return true;
      } else {
        /* Opcode received is not correct */
        if (opcode < 1 || opcode > 8 || opcode == 7) {
          protocol.setErrorFrom(0);
          protocol.sendError(3, "INVALID OPCODE RECEIVED", protocol.getGameMode());
        } else if (opcode2 < 1 || opcode2 > 8 || opcode2 == 7) {
          protocol.setErrorFrom(1);
          protocol.sendError(3, "INVALID OPCODE RECEIVED", protocol.getGameMode());
        }
        return false;
      }
    } else {
      if (opcode == state) {
        return true;
      } else {
        /* Opcode received is not correct */
        if (opcode < 1 || opcode > 8 || opcode == 7) {
          protocol.sendError(3, "INVALID OPCODE RECEIVED", protocol.getGameMode());
        }
        return false;
      }
    }
  }
}
