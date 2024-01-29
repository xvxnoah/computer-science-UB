import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.IOException;
import java.net.Socket;
import java.util.Random;

public class Utils {
  private DataInputStream input;
  private DataOutputStream output;

  public Utils(Socket socket) throws IOException {
    input = new DataInputStream(socket.getInputStream());
    output = new DataOutputStream(socket.getOutputStream());
  }

  /* Generate a random ID for the client */
  public int generateIDClient() {
    int id;
    Random random = new Random();

    /* Generate a random number between 10000 and 99999 */
    id = random.nextInt(90000) + 10000;

    return id;
  }

  /* Read a string in UTF-8 format (2 bytes) with and ending '00' */
  public String readVariableString() throws IOException {
    String result = "";
    byte first;
    byte second;

    while (input.available() > 0) {
      first = input.readByte();

      if (first == 0x0) {
        second = input.readByte();

        if (second == 0x0) {
          break;
        } else {
          result += (char) first;
          result += (char) second;
        }
      }
      result += (char) first;
    }

    return result;
  }

  /* Write a variable string to the output stream. */
  public void writeVariableString(String text) throws IOException {
    output.writeChars(text);
    output.writeByte((byte) 0x0);
    output.writeByte((byte) 0x0);
  }

  /* Read the result string until the end of the stream is reached. */
  public String readResultString() throws IOException {
    String result = "";
    char aux;

    /* We read the 4 characters of the result */
    for (int i = 0; i < 4; i++) {
      aux = input.readChar();
      result += aux;
    }

    return result;
  }

  /* Read the action string until the end of the stream is reached. */
  public String readActionString() throws IOException {
    String result = "";
    char aux;

    /* We read the 4 characters of the result */
    for (int i = 0; i < 5; i++) {
      aux = input.readChar();
      result += aux;
    }

    return result;
  }

  public char readResultFlag() throws IOException {
    return input.readChar();
  }

  /* Read a single byte as an integer. */
  public int read1ByteAsInteger() throws IOException {
    return input.readByte() & 0xFF;
  }

  /* Read an integer from the stream and return it afterwards. */
  public int readInt() throws IOException {
    return input.readInt();
  }

  /* Write a 32-bit (4 byes) integer to the output stream. */
  public void writeInt(int integer) throws IOException {
    output.writeInt(integer);
  }

  /* Read a byte from the stream and return it. */
  public byte readByte() throws IOException {
    return input.readByte();
  }

  /* Write a byte to the output stream. */
  public void writeByte(int opcode) throws IOException {
    output.writeByte(opcode);
  }

  /* Write a string to the output stream. */
  public void writeString(String name) throws IOException {
    output.writeChars(name);
  }

  /* Method for printing the remaining bullets as '*'. */
  public String bulletsLeft(int bullets) {
    if (bullets == 0) {
      return "0";
    } else {
      StringBuilder sb = new StringBuilder();
      for (int i = 0; i < bullets; i++) {
        sb.append("* ");
      }
      return sb.toString();
    }
  }

  /* Write the opcode and an integer (4 bytes) to the output stream. */
  public void writeOpcodeInt(int opcode, int integer) throws IOException {
    /* Write the opcode in 1 byte (network format - Big Endian) */
    output.writeByte(opcode);

    /* Write the id in network format (4 bytes) */
    output.writeInt(integer);
  }

  /* Flush to the output stream. */
  public void flushOutput() throws IOException {
    output.flush();
  }

  /* Setters & Getters */
  public DataInputStream getInput() {
    return input;
  }

  public DataOutputStream getOutput() {
    return output;
  }

  public void setInput(DataInputStream in) {
    this.input = in;
  }

  public void setOutput(DataOutputStream out) {
    this.output = out;
  }
}