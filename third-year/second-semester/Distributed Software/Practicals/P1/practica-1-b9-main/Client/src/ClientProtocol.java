import java.io.IOException;
import java.net.ProtocolException;
import java.util.Scanner;

public class ClientProtocol {

  private Utils utils;
  private int client_id;
  private int client_bullets;
  private int server_bullets;

  /* Final variables for the different types of actions */
  private static final int BLOCK = 1;
  private static final int CHARG = 2;
  private static final int SHOOT = 3;

  /* Final variables for the different types of result */
  private static final String ENDS_STRING = "ENDS";
  private static final String PLUS_STRING = "PLUS";
  private static final String DRAW_STRING = "DRAW";
  private static final String SAFE_STRING = "SAFE";

  public ClientProtocol(Utils utils, int client_id) {
    this.utils = utils;
    this.client_id = client_id;
    this.client_bullets = 0;
    this.server_bullets = 0;
  }

  /* Senders */
  public int sendHello(String name) throws IOException {
    /* Write the opcode in 1 byte (network format - Big Endian) */
    utils.writeByte(GameClient.OPCODE_HELLO);

    /* Write the id in network format (4 bytes in Big Endian order) */
    utils.writeInt(client_id);

    /* Write the name in UTF-8 (2 bytes) and the ending bytes in network format (Big Endian) */
    utils.writeVariableString(name);

    utils.flushOutput();

    return GameClient.OPCODE_READY;
  }

  public int sendPlay() throws IOException {
    /* Write the opcode in 1 byte (network format - Big Endian) and the id (4 bytes) */
    utils.writeOpcodeInt(GameClient.OPCODE_PLAY, client_id);

    utils.flushOutput();

    return GameClient.OPCODE_ADMIT;
  }

  public int sendAction() throws IOException {
    String action_string = "";

    int action = showMenu();

    switch (action) {
      case BLOCK:
        action_string = "BLOCK";
        break;

      case CHARG:
        action_string = "CHARG";
        this.client_bullets++;
        break;

      case SHOOT:
        action_string = "SHOOT";
        this.client_bullets--;
        break;
    }

    /* Write the opcode in 1 byte (network format - Big Endian) */
    utils.writeByte(GameClient.OPCODE_ACTION);

    /* Write the action as a string of 5 characters in UTF format (2 bytes) */
    utils.writeString(action_string);
    utils.flushOutput();

    return GameClient.OPCODE_RESULT;
  }

  /* Receivers */
  public int receiveReady() throws IOException, ProtocolException {
    /* Read the id (4 bytes) in network format */
    int id = utils.readInt();

    /* Check if there is still data to be read (OUT OF PROTOCOL) */
    if (utils.getInput().available() > 0) {
      throw new ProtocolException("Message out of protocol received from Server!");
    }

    if (id == client_id) {
      return GameClient.OPCODE_PLAY;
    } else {
      throw new ProtocolException("ID received is not the same as the one sent!");
    }
  }

  public int receiveAdmit() throws IOException, ProtocolException {
    /* Read the boolean (first read the byte and then convert it to a boolean) */
    byte bool = utils.readByte();
    boolean admit = (bool == 1);

    /* Check if there is still data to be read (OUT OF PROTOCOL) */
    if (utils.getInput().available() > 0) {
      throw new ProtocolException("Message out of protocol received from Server!");
    }

    if (admit) {
      return GameClient.OPCODE_ACTION;
    } else {
      throw new ProtocolException("Client wasn't admitted to play!");
    }
  }

  public void receiveError() throws IOException, ProtocolException {
    /* We receive the error */
    int errorCode = utils.read1ByteAsInteger();

    /* We read the error message */
    String msg = utils.readVariableString();

    throw new ProtocolException("Error code: " + errorCode + ", message: " + msg);
  }

  public int showMenu() {
    /* Show bullets left both from Server and Client */
    System.out.println("\nClient's bullets: " + utils.bulletsLeft(client_bullets));
    System.out.println("Server's bullets: " + utils.bulletsLeft(server_bullets));

    Scanner scanner = new Scanner(System.in);
    int action = 0;

    while (true) {
      System.out.println("\nChoose an option for an action:");
      System.out.println("1. BLOCK");
      System.out.println("2. CHARG");
      System.out.println("3. SHOOT");
      System.out.println("4. HELP");

      action = scanner.nextInt();

      if (action < 1 || action > 4) {
        System.out.println("Invalid action, please enter a number between 1 and 4.");
        continue;
      }

      if (action == 4) {
        System.out.println("\nBLOCK: Defend yourself by blocking oponent's bullets.");
        System.out.println("CHARG: Charge a bullet to your count.");
        System.out.println("SHOOT: Fire a bullet to your opponent.\n");
      } else if (action == 3 && client_bullets == 0) {
        System.out.println("\nYOU DON'T HAVE ANY BULLET ON THE CHAMBER!");
      } else if (action == 1 || action == 2 || action == 3) {
        return action;
      }
    }
  }

  public int receiveResult() throws IOException, ProtocolException {
    /* Read the result sent by server */
    String result = utils.readResultString();

    /* And then we read the flag */
    char flag = utils.readResultFlag();

    /* Check if there is still data to be read (OUT OF PROTOCOL) */
    if (utils.getInput().available() > 0) {
      throw new ProtocolException("Message out of protocol received from Server!");
    }

    /* Switch with all the cases */
    switch (result) {
      case ENDS_STRING:
        if (flag == '0') {
          System.out.println("\nSERVER WON!");
          return exitMenu();
        } else if (flag == '1') {
          System.out.println("\nCLIENT WON!");
          return exitMenu();
        }
        break;

      case PLUS_STRING:
        if (flag == '0') {
          System.out.println("\nSERVER recharged a bullet");
          this.server_bullets++;
        } else if (flag == '1') {
          System.out.println("\nCLIENT recharged a bullet (and Server decided to block)");
        } else if (flag == '2') {
          System.out.println("\nCLIENT & SERVER recharged a bullet");
          this.server_bullets++;
        }
        break;

      case DRAW_STRING:
        if (flag == '0') {
          System.out.println("BOTH CLIENT & SERVER HAVE SHOOT");
          this.server_bullets--;
        }
        break;

      case SAFE_STRING:
        if (flag == '0') {
          System.out.println("\nSERVER blocked a bullet");
        } else if (flag == '1') {
          System.out.println("\nCLIENT blocked a bullet");
          this.server_bullets--;
        } else if (flag == '2') {
          System.out.println("\nCLIENT & SERVER blocked a bullet");
        }
        break;
    }

    return GameClient.OPCODE_ACTION;
  }

  public int exitMenu() {
    Scanner scanner = new Scanner(System.in);
    int action = 0;

    while (true) {
      System.out.println("\nWould you like to play another game or exit?");
      System.out.println("1. PLAY AGAIN");
      System.out.println("2. EXIT");

      action = scanner.nextInt();

      if (action < 1 || action > 2) {
        System.out.println("Invalid action, please enter a number between 1 and 2.");
        continue;
      }

      if (action == 1) {
        this.client_bullets = 0;
        this.server_bullets = 0;
        return GameClient.OPCODE_PLAY;
      } else {
        System.out.println("\nGOOD BYE!");
        return -1;
      }
    }
  }
}
