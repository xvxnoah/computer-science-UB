import static org.junit.Assert.*;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.IOException;
import java.net.Socket;
import org.junit.Before;
import org.junit.Test;

public class UtilsTest {
  private ByteArrayOutputStream outputStream;
  private DataOutputStream dataOutputStream;
  private DataInputStream dataInputStream;
  private Utils utils;

  @Before
  public void setup() {
    outputStream = new ByteArrayOutputStream();
    dataOutputStream = new DataOutputStream(outputStream);
    dataInputStream = new DataInputStream(new ByteArrayInputStream(outputStream.toByteArray()));
    try {
      utils =
          new Utils(
              new Socket() {
                @Override
                public DataOutputStream getOutputStream() throws IOException {
                  return dataOutputStream;
                }

                @Override
                public DataInputStream getInputStream() throws IOException {
                  return dataInputStream;
                }
              });
    } catch (IOException e) {
      fail("Failed to create Utils object: " + e.getMessage());
    }
  }

  @Test
  public void testBulletsLeft() {
    String test1 = utils.bulletsLeft(3);
    String test2 = utils.bulletsLeft(0);

    String expTest1 = "* * * ";
    assertEquals(test1, expTest1);
    assertEquals(test2, "0");
  }

  @Test
  public void testFlushOutput() {}

  @Test
  public void testGenerateIDClient() {
    int id = utils.generateIDClient();

    assertTrue(id >= 10000 && id <= 99999);
  }

  @Test
  public void testGetInput() {
    assertTrue(utils.getInput() != null);
  }

  @Test
  public void testGetOutput() {
    assertTrue(utils.getOutput() != null);
  }

  @Test
  public void testRead1ByteAsInteger() throws IOException {
    byte input = 0x06;

    /* We send the byte through the DataOutputStream */
    dataOutputStream.writeByte(input);

    dataInputStream = new DataInputStream(new ByteArrayInputStream(outputStream.toByteArray()));
    utils.setInput(dataInputStream);

    int result = utils.read1ByteAsInteger();

    assertEquals(input, result);
  }

  @Test
  public void testReadByte() throws IOException {
    byte input = 0x45;

    /* We send the byte through the DataOutputStream */
    dataOutputStream.writeByte(input);

    dataInputStream = new DataInputStream(new ByteArrayInputStream(outputStream.toByteArray()));
    utils.setInput(dataInputStream);

    byte result = utils.readByte();

    assertEquals(input, result);
  }

  @Test
  public void testReadInt() throws IOException {
    int input = 48594;

    /* We send the integer (4 bytes) through the DataOutputStream */
    dataOutputStream.writeInt(input);

    dataInputStream = new DataInputStream(new ByteArrayInputStream(outputStream.toByteArray()));
    utils.setInput(dataInputStream);

    int result = utils.readInt();

    assertEquals(input, result);
  }

  @Test
  public void testReadResultString() throws IOException {
    String input = "ENDS";

    /* We send the result string through the DataOutputStream */
    dataOutputStream.writeChars(input);

    dataInputStream = new DataInputStream(new ByteArrayInputStream(outputStream.toByteArray()));
    utils.setInput(dataInputStream);

    String result = utils.readResultString();

    assertEquals(input, result);
  }

  @Test
  public void testReadActionString() throws IOException {
    String input = "SHOOT";

    /* We send the result string through the DataOutputStream */
    dataOutputStream.writeChars(input);

    dataInputStream = new DataInputStream(new ByteArrayInputStream(outputStream.toByteArray()));
    utils.setInput(dataInputStream);

    String result = utils.readActionString();

    assertEquals(input, result);
  }

  @Test
  public void testReadVariableString() throws IOException {
    String input = "SoftwareDistribuit";

    /* We send the variable size string through the DataOutputStream */
    dataOutputStream.writeBytes(input);
    dataOutputStream.write((byte) 0x0);
    dataOutputStream.write((byte) 0x0);

    dataInputStream = new DataInputStream(new ByteArrayInputStream(outputStream.toByteArray()));
    utils.setInput(dataInputStream);

    String actualInput = utils.readVariableString();

    assertEquals(input, actualInput);
  }

  @Test
  public void testWriteByte() throws IOException {
    int input = 5;
    utils.writeByte(input);

    byte[] expected = {5};
    byte[] result = outputStream.toByteArray();

    assertArrayEquals(expected, result);
  }

  @Test
  public void testWriteInt() throws IOException {
    int input = 10;
    utils.writeInt(input);

    /* writeInt() method takes an int value as a parameter and writes it to the output stream in a
     * 4-byte format, where the most significant byte is written first */
    byte[] expected = {0, 0, 0, 10};
    byte[] result = outputStream.toByteArray();

    assertArrayEquals(expected, result);
  }

  @Test
  public void testWriteOpcodeInt() throws IOException {
    int opcode = 2;
    int id = 95485;
    utils.writeOpcodeInt(opcode, id);

    dataInputStream = new DataInputStream(new ByteArrayInputStream(outputStream.toByteArray()));

    int readOpcode = dataInputStream.readByte();
    int readId = dataInputStream.readInt();

    assertEquals(opcode, readOpcode);
    assertEquals(id, readId);
  }

  @Test
  public void testWriteString() throws IOException {
    String input = "software";
    utils.writeString(input);

    /* Byte values of the string "software" (we have zeros before each value
     * because we use writeChars() method in Utils class) */
    byte[] expected = {0, 115, 0, 111, 0, 102, 0, 116, 0, 119, 0, 97, 0, 114, 0, 101};
    byte[] result = outputStream.toByteArray();

    assertArrayEquals(result, expected);
  }

  @Test
  public void testWriteVariableString() throws IOException {
    String input = "hello";
    utils.writeVariableString(input);

    /* Byte values of the string "hello" with the two ending 00 (we have zeros before each value
     * because we use writeChars() method in Utils class) */
    byte[] expected = {0, 104, 0, 101, 0, 108, 0, 108, 0, 111, 0, 0};

    byte[] result = outputStream.toByteArray();

    assertArrayEquals(result, expected);
  }
}
