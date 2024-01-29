import java.io.IOException;
import java.util.logging.Logger;

/**
 * This class implements the game protocol for the "Pistolas" game. It handles communication between
 * the client and the server.
 */
public class GameProtocol {
  private int server_id; /* ID received in HELLO packet */
  private int server_id2; /* ID received in HELLO packet from second client */
  private int play_id; /* ID received in PLAY packet */
  private int play_id2; /* ID received in PLAY packet from second client */
  private int client_bullets; /* Number of bullets of client */
  private int server_bullets; /* Number of bullets of server (or second player) */
  private String client_action;
  private String client_action2;
  private String server_action;
  private Utils utils;
  private Utils utils2;
  private Logger logger;
  private int game_mode = 0; /* 0 = Single player, 1 = Multiplayer */
  private int error_from = 0; /* 0 = Client1, 1 = Client2 */

  /* Game actions */
  public static final int BLOCK = 1;
  public static final int CHARG = 2;
  public static final int SHOOT = 3;

  /**
   * C O N S T R U C T O R (Single player)
   *
   * @param clientSocket socket to communicate with the client
   * @param utils instance of Utils class to handle the input and output streams
   * @param logger instance of Logger class to log the communication
   */
  public GameProtocol(Utils utils, Logger logger) {
    this.utils = utils;
    this.utils2 = null;
    this.client_bullets = 0;
    this.server_bullets = 0;
    this.logger = logger;
  }

  /**
   * C O N S T R U C T O R (Multiplayer)
   *
   * @param clientSocket1 socket to communicate with the client
   * @param clientSocket2 socket to communicate with the client
   * @param utils1 instance of Utils class to handle the input and output streams
   * @param utils2 instance of Utils class to handle the input and output streams
   * @param logger instance of Logger class to log the communication
   */
  public GameProtocol(Utils utils1, Utils utils2, Logger logger) {
    this.utils = utils1;
    this.utils2 = utils2;
    this.client_bullets = 0;
    this.server_bullets = 0;
    this.logger = logger;
    this.game_mode = 1;
  }

  /*
  R E C E I V E R
  */

  public int receiveHello() throws IOException {
    int opcode;

    /* Reads the client ID from the input stream and saves it. */
    this.server_id = utils.readInt();

    if (utils2 != null) {
      this.server_id2 = utils2.readInt();
    }

    /* Reads the client name from the input stream and saves it. */
    String client_name = utils.readVariableString();

    String client_name2 = "";
    if (utils2 != null) {
      client_name2 = utils2.readVariableString();
    }

    /* If we still have elements in the input stream (out of protocol) */
    if (utils.getInput().available() > 0) {
      opcode = GameHandler.OPCODE_HELLO;
      error_from = 0;
      sendError(GameHandler.MSG_OUT_OF_PROTOCOL, "MISSATGE FORA DE PROTOCOL", game_mode);
    } else if (utils2 != null && utils2.getInput().available() > 0) {
      opcode = GameHandler.OPCODE_HELLO;
      error_from = 1;
      sendError(GameHandler.MSG_OUT_OF_PROTOCOL, "MISSATGE FORA DE PROTOCOL", game_mode);
    }
    /* If the server id is less than 10000 or the client name is empty, the HELLO message
     * is bad formed as these conditions cannot be met.
     */
    else if (server_id < 10000 || client_name == "") {
      opcode = GameHandler.OPCODE_HELLO;
      error_from = 0;
      sendError(GameHandler.WRONG_MSG_FORMAT, "MISSATGE MAL FORMAT", game_mode);
    } else if (utils2 != null && (server_id2 < 10000 || client_name2 == "")) {
      opcode = GameHandler.OPCODE_HELLO;
      error_from = 1;
      sendError(GameHandler.WRONG_MSG_FORMAT, "MISSATGE MAL FORMAT", game_mode);
    } else {
      if (utils2 != null) {
        System.out.println(
            "HELLO   C1 -------1 " + this.server_id + " " + client_name + " ------> S");
        System.out.println(
            "HELLO   C2 -------1 " + this.server_id2 + " " + client_name2 + " ------> S");
        logger.info("HELLO   C1 -------1 " + this.server_id + " " + client_name + " ------> S");
        logger.info("HELLO   C2 -------1 " + this.server_id2 + " " + client_name2 + " ------> S");
      } else {
        System.out.println(
            "HELLO   C -------1 " + this.server_id + " " + client_name + " ------> S");
        logger.info("HELLO   C -------1 " + this.server_id + " " + client_name + " ------> S");
      }
      opcode = GameHandler.OPCODE_READY;
    }

    /* Returns the opcode decided (OPCODE_HELLO if an error was found
    (server should wait in the same state), or OPCODE_READY) */
    return opcode;
  }

  public int receivePlay() throws IOException {
    int opcode;

    /* Reads the player ID from the input stream and saves it. */
    play_id = utils.readInt();

    if (utils2 != null) {
      play_id2 = utils2.readInt();
    }

    /* If we still have elements in the input stream (out of protocol) */
    if (utils.getInput().available() > 0) {
      opcode = GameHandler.OPCODE_PLAY;
      error_from = 0;
      sendError(GameHandler.MSG_OUT_OF_PROTOCOL, "MISSATGE FORA DE PROTOCOL", game_mode);
    } else if (utils2 != null && utils2.getInput().available() > 0) {
      opcode = GameHandler.OPCODE_PLAY;
      error_from = 1;
      sendError(GameHandler.MSG_OUT_OF_PROTOCOL, "MISSATGE FORA DE PROTOCOL", game_mode);
    }
    /* If the ID received now doesn't match the one received in HELLO packet */
    else if (server_id != play_id) {
      opcode = GameHandler.OPCODE_PLAY;
      error_from = 0;
      sendError(GameHandler.WRONG_LOG_IN, "INICI DE SESSIO INCORRECTE", game_mode);
    } else if (utils2 != null && server_id2 != play_id2) {
      opcode = GameHandler.OPCODE_PLAY;
      error_from = 1;
      sendError(GameHandler.WRONG_LOG_IN, "INICI DE SESSIO INCORRECTE", game_mode);
    } else {
      if (utils2 != null) {
        System.out.println("PLAY    C1 -------3 " + this.play_id + " ------> S");
        System.out.println("PLAY    C2 -------3 " + this.play_id2 + " ------> S");
        logger.info("PLAY    C1 -------3 " + this.play_id + " ------> S");
        logger.info("PLAY    C2 -------3 " + this.play_id2 + " ------> S");
      } else {
        System.out.println("PLAY    C -------3 " + this.play_id + " ------> S");
        logger.info("PLAY    C -------3 " + this.play_id + " ------> S");
      }
      opcode = GameHandler.OPCODE_ADMIT;
    }

    /* Returns the opcode decided (OPCODE_PLAY if an error was found
    (server should wait in the same state), or OPCODE_ADMIT) */
    return opcode;
  }

  public int receiveAction() throws IOException {
    int opcode;

    /* Reads the client action from the input stream and saves it. */
    client_action = utils.readActionString();

    if (utils2 != null) {
      client_action2 = utils2.readActionString();
    }

    /* If we still have elements in the input stream (out of protocol) */
    if (utils.getInput().available() > 0) {
      opcode = GameHandler.OPCODE_ACTION;
      error_from = 0;
      sendError(GameHandler.MSG_OUT_OF_PROTOCOL, "MISSATGE FORA DE PROTOCOL", game_mode);
    } else if (utils2 != null && utils2.getInput().available() > 0) {
      opcode = GameHandler.OPCODE_ACTION;
      error_from = 1;
      sendError(GameHandler.MSG_OUT_OF_PROTOCOL, "MISSATGE FORA DE PROTOCOL", game_mode);
    }
    /* Client action should be one of the followings */
    else if (!client_action.equals("SHOOT")
        && !client_action.equals("CHARG")
        && !client_action.equals("BLOCK")) {
      opcode = GameHandler.OPCODE_ACTION;
      error_from = 0;
      sendError(GameHandler.UNKNOWN_WORD, "UNKNOWN WORD", game_mode);
    } else if (utils2 != null
        && !client_action2.equals("SHOOT")
        && !client_action2.equals("CHARG")
        && !client_action2.equals("BLOCK")) {
      opcode = GameHandler.OPCODE_ACTION;
      error_from = 1;
      sendError(GameHandler.UNKNOWN_WORD, "UNKNOWN WORD", game_mode);
    } else {
      /* Computes the server action based sets the opcode to OPCODE_RESULT flag
      indicating that the result is ready to be sent. */
      if (utils2 != null) {
        System.out.println("ACTION  C1 -------5 " + client_action + " ------> S");
        System.out.println("ACTION  C2 -------5 " + client_action2 + " ------> S");
        logger.info("ACTION  C1 -------5 " + client_action + " ------> S");
        logger.info("ACTION  C2 -------5 " + client_action2 + " ------> S");
      } else {
        server_action = computeAction();
        System.out.println("ACTION  C -------5 " + client_action + " ------> S");
        logger.info("ACTION  C -------5 " + client_action + " ------> S");
      }
      opcode = GameHandler.OPCODE_RESULT;
    }

    /* Returns the opcode decided (OPCODE_ACTION if an error was found
    (server should wait in the same state), or OPCODE_RESULT) */
    return opcode;
  }

  /*
  S E N D E R S
   */

  public int sendReady() throws IOException {
    utils.writeByte(GameHandler.OPCODE_READY);
    utils.writeInt(server_id);
    utils.flushOutput();

    if (utils2 != null) {
      utils2.writeByte(GameHandler.OPCODE_READY);
      utils2.writeInt(server_id2);
      utils2.flushOutput();

      System.out.println("READY   C1 <------2 " + this.server_id + " ------- S");
      System.out.println("READY   C2 <------2 " + this.server_id2 + " ------- S");
      logger.info("READY   C1 <------2 " + this.server_id + " ------- S");
      logger.info("READY   C2 <------2 " + this.server_id2 + " ------- S");
    } else {
      System.out.println("READY   C <------2 " + this.server_id + " ------- S");
      logger.info("READY   C <------2 " + this.server_id + " ------- S");
    }

    /* Returns the opcode for waiting the PLAY from the client */
    return GameHandler.OPCODE_PLAY;
  }

  public int sendAdmit() throws IOException {
    utils.writeByte(GameHandler.OPCODE_ADMIT);
    boolean b = (server_id == play_id);
    byte AsByte = (byte) (b ? 1 : 0);

    /* Sends a byte that indicates if the client is admitted to play or not */
    utils.writeByte(AsByte);
    utils.flushOutput();

    if (utils2 != null) {
      utils2.writeByte(GameHandler.OPCODE_ADMIT);
      boolean b2 = (server_id2 == play_id2);
      byte AsByte2 = (byte) (b2 ? 1 : 0);

      /* Sends a byte that indicates if the client is admitted to play or not */
      utils2.writeByte(AsByte2);
      utils2.flushOutput();

      System.out.println("ADMIT   C1 <------4 " + AsByte + "     ------- S");
      System.out.println("ADMIT   C2 <------4 " + AsByte2 + "     ------- S");
      logger.info("ADMIT   C1 <------4 " + AsByte + "     ------- S");
      logger.info("ADMIT   C2 <------4 " + AsByte2 + "     ------- S");
    } else {
      System.out.println("ADMIT   C <------4 " + AsByte + "     ------- S");
      logger.info("ADMIT   C <------4 " + AsByte + "     ------- S");
    }

    /* Returns the opcode for waiting the action from the client */
    return GameHandler.OPCODE_ACTION;
  }

  /*
  A U X I L I A R S
   *  Calculates the best action the server can take (using probability of each action).
   */

  private String computeAction() {
    /* If the server has bullets, it's more likely to shoot or block,
    as it could win if the client is charging. */
    if (this.server_bullets > 0) {
      double random = Math.random();
      if (random < 0.5) {
        return "SHOOT";
      } else if (random < 0.8) {
        return "BLOCK";
      } else {
        return "CHARG";
      }
    }

    /* If the client has bullets, the server might be at risk.
    It's more likely for the server to block or charge. */
    if (this.client_bullets > 0) {
      double random = Math.random();
      if (random < 0.6) {
        return "BLOCK";
      } else {
        return "CHARG";
      }
    }

    /* If neither the player nor the server have bullets, they're both likely to charge.
    However, the server can try to block or charge to surprise the client. */
    double random = Math.random();
    if (random < 0.6) {
      return "CHARG";
    } else {
      return "BLOCK";
    }
  }

  /* Computes the result of a round based on the actions taken by the client and server (or the second player). */
  private String computeResult(String client_action, String server_action) {
    String result = "";
    switch (client_action) {
      case "BLOCK":
        if (server_action.equals("CHARG")) {
          this.server_bullets += 1;
          result = "PLUS0";
        } else if (server_action.equals("SHOOT")) {
          this.server_bullets -= 1;
          result = "SAFE1";
        } else {
          result = "SAFE2";
        }
        break;
      case "CHARG":
        if (server_action.equals("CHARG")) {
          this.client_bullets += 1;
          this.server_bullets += 1;
          result = "PLUS2";
        } else if (server_action.equals("BLOCK")) {
          this.client_bullets += 1;
          result = "PLUS1";
        } else if (server_action.equals("SHOOT")) {
          this.client_bullets += 1;
          this.server_bullets -= 1;
          result = "ENDS0";
        }
        break;
      case "SHOOT":
        if (server_action.equals("CHARG")) {
          this.server_bullets += 1;
          this.client_bullets -= 1;
          result = "ENDS1";
        } else if (server_action.equals("BLOCK")) {
          this.client_bullets -= 1;
          result = "SAFE0";
        } else if (server_action.equals("SHOOT")) {
          this.client_bullets -= 1;
          this.server_bullets -= 1;
          result = "DRAW0";
        }
        break;
    }

    return result;
  }

  public int sendResult() throws IOException {
    utils.writeByte(GameHandler.OPCODE_RESULT);
    int opcode;

    if (utils2 != null) {
      utils2.writeByte(GameHandler.OPCODE_RESULT);
    }

    String result = "";

    if (utils2 != null) {
      result = computeResult(client_action, client_action2);
    } else {
      result = computeResult(this.client_action, this.server_action);
    }

    /* If the game has ended, the server waits in case the client wants to
     * play again. (ENDS0 in multiplayer means that the second player won)
     */
    if (result == "ENDS0" || result == "ENDS1") {
      this.server_bullets = 0;
      this.client_bullets = 0;

      if (utils2 != null) {
        if (result == "ENDS0") {
          utils2.writeString("ENDS1");

          System.out.println("RESULT  C2 <------6 " + "ENDS1" + " ------- S");
          logger.info("RESULT  C2 <------6 " + "ENDS1" + " ------- S");
        } else if (result == "ENDS1") {
          utils2.writeString("ENDS0");

          System.out.println("RESULT  C2 <------6 " + "ENDS0" + " ------- S");
          logger.info("RESULT  C2 <------6 " + "ENDS0" + " ------- S");
        }

        utils.writeString(result);
        utils.flushOutput();

        utils2.flushOutput();

        System.out.println("RESULT  C1 <------6 " + result + " ------- S");
        logger.info("RESULT  C1 <------6 " + result + " ------- S");
      } else {
        utils.writeString(result);
        utils.flushOutput();

        System.out.println("RESULT  C <------6 " + result + " ------- S");
        logger.info("RESULT  C <------6 " + result + " ------- S");
      }

      opcode = GameHandler.OPCODE_PLAY;

    } else {
      opcode = GameHandler.OPCODE_ACTION;

      utils.writeString(result);
      utils.flushOutput();

      if (utils2 != null) {
        if (result == "PLUS0") {
          utils2.writeString("PLUS1");

          System.out.println("RESULT  C2 <------6 " + "PLUS1" + " ------- S");
          logger.info("RESULT  C2 <------6 " + "PLUS1" + " ------- S");
        } else if (result == "PLUS1") {
          utils2.writeString("PLUS0");

          System.out.println("RESULT  C2 <------6 " + "PLUS0" + " ------- S");
          logger.info("RESULT  C2 <------6 " + "PLUS0" + " ------- S");
        } else if (result == "SAFE0") {
          utils2.writeString("SAFE1");

          System.out.println("RESULT  C2 <------6 " + "SAFE1" + " ------- S");
          logger.info("RESULT  C2 <------6 " + "SAFE1" + " ------- S");
        } else if (result == "SAFE1") {
          utils2.writeString("SAFE0");

          System.out.println("RESULT  C2 <------6 " + "SAFE0" + " ------- S");
          logger.info("RESULT  C2 <------6 " + "SAFE0" + " ------- S");
        } else {
          utils2.writeString(result);
          System.out.println("RESULT  C2 <------6 " + result + " ------- S");
          logger.info("RESULT  C2 <------6 " + result + " ------- S");
        }

        utils2.flushOutput();

        System.out.println("RESULT  C1 <------6 " + result + " ------- S");
        logger.info("RESULT  C1 <------6 " + result + " ------- S");
      } else {
        System.out.println("RESULT  C <------6 " + result + " ------- S");
        logger.info("RESULT  C <------6 " + result + " ------- S");
      }
    }

    return opcode;
  }

  public void sendError(int errCode, String msg, int game_mode) throws IOException {
    if (game_mode == 0) {
      /* Write the opcode in 1 byte (network format - Big Endian) */
      utils.writeByte(GameHandler.OPCODE_ERROR);

      /* Write the error code */
      utils.writeByte(errCode);

      /* Write the message in UTF-8 (2 bytes) and the ending bytes in network format (Big Endian) */
      utils.writeVariableString(msg);

      utils.flushOutput();

      System.out.println("ERROR   C <------" + errCode + " " + msg + " ------- S");
      logger.info("ERROR   C <------" + errCode + " " + msg + " ------- S");
    } else if (game_mode == 1) {
      if (error_from == 0) {
        utils.writeByte(GameHandler.OPCODE_ERROR);
        utils.writeByte(errCode);
        utils.writeVariableString(msg);
        utils.flushOutput();

        System.out.println("ERROR   C1 <------" + errCode + " " + msg + " ------- S");
        logger.info("ERROR   C1 <------" + errCode + " " + msg + " ------- S");
      } else if (error_from == 1) {
        utils2.writeByte(GameHandler.OPCODE_ERROR);
        utils2.writeByte(errCode);
        utils2.writeVariableString(msg);
        utils2.flushOutput();

        System.out.println("ERROR   C2 <------" + errCode + " " + msg + " ------- S");
        logger.info("ERROR   C2 <------" + errCode + " " + msg + " ------- S");
      }
    }
  }

  public void setErrorFrom(int error_from) {
    this.error_from = error_from;
  }

  public int getGameMode() {
    return game_mode;
  }
}
