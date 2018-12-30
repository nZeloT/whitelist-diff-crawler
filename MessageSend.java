
import java.util.Date;
import java.util.Properties;
import javax.mail.BodyPart;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Multipart;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;
import javax.mail.PasswordAuthentication;
import java.io.FileInputStream;

public class MessageSend {

  public static void main(String[] args) {
    String destAddress = "leontsteiner@gmail.com";
    String stmpHost = "smtp.google.com";
    int smtpHost = 465;

    Properties props = new Properties();
    try {
      props.load(new FileInputStream("config.properties"));
    } catch (java.lang.Exception exception) {
      exception.printStackTrace();
    }

    Session session = Session.getInstance(props, new javax.mail.Authenticator() {
      protected PasswordAuthentication getPasswordAuthentication(){
        return new PasswordAuthentication(props.getProperty("usn"), props.getProperty("pwd"));
      }
    });

    try {
      MimeMessage msg = new MimeMessage(session);
      msg.addHeader("Content-type", "text/HTML; charset=UTF-8");
      msg.addHeader("format", "flowed");
      msg.addHeader("Content-Transfer-Encoding", "8bit");
      msg.setFrom(props.getProperty("fromaddress"));
      msg.setSubject(args[0], "UTF-8");
      msg.setText(args[1], "UTF-8", "html");
      msg.setSentDate(new Date());
      msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(props.getProperty("destaddress"), false));
      Transport.send(msg);
    } catch (java.lang.Exception exception) {
      exception.printStackTrace();
    }
  }
}