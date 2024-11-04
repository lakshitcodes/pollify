package com.pollify;

import java.util.Properties;
import javax.mail.*;
import javax.mail.internet.*;

public class SendMail {

    private Session newSession;
    private MimeMessage mimeMessage;

    public void sendMailToUser(String recipient, String emailSubject, String emailBody) throws MessagingException {
        setupServerProperties();  // Setup mail server properties
        
        // Drafting the email with dynamic content
        draftEmail(recipient, emailSubject, emailBody);  // Draft the email
        sendMail();  // Send the email
    }

    private void setupServerProperties() {
        Properties properties = System.getProperties();
        properties.put("mail.smtp.port", "587");
        properties.put("mail.smtp.auth", "true");
        properties.put("mail.smtp.starttls.enable", "true");
        newSession = Session.getInstance(properties, null);
    }

    private void draftEmail(String recipient, String subject, String body) throws MessagingException {
        mimeMessage = new MimeMessage(newSession);
        mimeMessage.addRecipient(Message.RecipientType.TO, new InternetAddress(recipient));
        mimeMessage.setSubject(subject, "UTF-8");
        MimeMultipart multipart = new MimeMultipart();

        MimeBodyPart bodyPart = new MimeBodyPart();
        bodyPart.setContent(body, "text/html; charset=UTF-8");
        multipart.addBodyPart(bodyPart);
        mimeMessage.setContent(multipart);
    }

    private void sendMail() throws MessagingException {
        String fromUser = "pollifyproject@gmail.com";
        String fromUserEmailPassword = "sbqc hktj ghbn jaza"; // Use a secure method to store passwords
        String emailHost = "smtp.gmail.com";

        Transport transport = newSession.getTransport("smtp");
        transport.connect(emailHost, fromUser, fromUserEmailPassword);
        transport.sendMessage(mimeMessage, mimeMessage.getAllRecipients());
        transport.close();
    }
}
