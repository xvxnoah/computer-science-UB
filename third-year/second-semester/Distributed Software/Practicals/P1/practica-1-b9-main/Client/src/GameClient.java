import java.io.IOException;
import java.net.ProtocolException;
import java.util.Scanner;

/* Class that encapsulates the game's logic. Sequence of states following the
 *  established protocol. */
public class GameClient {

  private static String name = "";
  private static boolean exit = false;
  private static Scanner scanner;
  private Utils utils;

  /* Variables for the opcodes */
  public static final int OPCODE_HELLO = 1;
  public static final int OPCODE_READY = 2;
  public static final int OPCODE_PLAY = 3;
  public static final int OPCODE_ADMIT = 4;
  public static final int OPCODE_ACTION = 5;
  public static final int OPCODE_RESULT = 6;
  public static final int OPCODE_ERROR = 8;

  /*
   * State = OPCODE_HELLO so it starts the process by sending a HELLO to the
   * server
   */
  private int state = OPCODE_HELLO;

  /* Instance of ClientProtocol to handle the communication protocol */
  private ClientProtocol clientProtocol;

  public GameClient(Utils utils) {
    this.utils = utils;
    /* Start ClientProtocol */
    clientProtocol = new ClientProtocol(utils, utils.generateIDClient());
  }

  public void startData() throws IOException, ProtocolException {
    scanner = new Scanner(System.in);

    /* Ask for user's name */
    System.out.println("Enter your name: ");
    name = scanner.nextLine();

    play();
  }

  /* Read the opcode (1 byte) */
  public boolean readOpcode() throws IOException, ProtocolException {
    int opcode = 0;

    /* Convert the byte to an int with no sign (opcode has no sign) */
    opcode = utils.read1ByteAsInteger();

    if (opcode == state) {
      return true;
    } else {
      if (opcode < 1 || opcode > 8 || opcode == 7) {
        throw new ProtocolException("Unknown opcode received from Server!");
      }
      return false;
    }
  }

  /* Method to control the states of the game */
  public void play() throws IOException, ProtocolException {
    while (!exit) {
      switch (state) {
        case OPCODE_HELLO:
          state = clientProtocol.sendHello(name);
          break;

        case OPCODE_READY:
          if (readOpcode()) {
            state = clientProtocol.receiveReady();
          }
          break;

        case OPCODE_PLAY:
          state = clientProtocol.sendPlay();
          break;

        case OPCODE_ADMIT:
          if (readOpcode()) {
            state = clientProtocol.receiveAdmit();
          }
          break;

        case OPCODE_ACTION:
          state = clientProtocol.sendAction();
          break;

        case OPCODE_RESULT:
          if (readOpcode()) {
            state = clientProtocol.receiveResult();

            if (state == -1) {
              exit = true;
            }
          }
          break;

        case OPCODE_ERROR:
          clientProtocol.receiveError();

          /* As soon as we get an error we quit the game (fastest approach) */
          exit = true;
          break;
      }
    }
    scanner.close();
  }
}
