package com.pollify;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Properties;
import java.util.Random;
import javax.mail.*;
import javax.mail.internet.*;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class RegisterServlet extends HttpServlet {

    private static final String DB_URL = "jdbc:mysql://localhost:3306/pollify"; 
    private static final String DB_USER = "root"; 
    private static final String DB_PASS = "30062004";
    
    private Session newSession;
    private MimeMessage mimeMessage;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String role = "voter";  // Default role
        
        // Generate a random 6-digit OTP
        String otp = generateOTP();
        
        // Set OTP expiry to 10 minutes from now
        LocalDateTime otpExpiry = LocalDateTime.now().plusMinutes(10);
        String otpExpiryStr = otpExpiry.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
        
        // Save user data with OTP to the database
        saveUserToDB(username, email, password, role, otp, otpExpiryStr);
        
        // Send OTP email to the user
        try {
            sendOTPToEmail(email, otp);  // Send dynamic OTP via email
        } catch (MessagingException e) {
            e.printStackTrace(); // Handle error appropriately
        }
        
        // Redirect to OTP verification page (assuming you have such a page)
        response.sendRedirect("OtpVerification.jsp");
    }

    private String generateOTP() {
        Random random = new Random();
        int otp = 100000 + random.nextInt(900000);  // Generate 6-digit number
        return String.valueOf(otp);
    }

    private void saveUserToDB(String username, String email, String password, String role, String otp, String otpExpiry) {
        String insertQuery = "INSERT INTO users (username, email, password, role, status, voted, otp_code, otp_expiry) "
                           + "VALUES (?, ?, ?, ?, 'pending', false, ?, ?)";
        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
             PreparedStatement stmt = conn.prepareStatement(insertQuery)) {

            stmt.setString(1, username);
            stmt.setString(2, email);
            stmt.setString(3, password);
            stmt.setString(4, role);
            stmt.setString(5, otp);
            stmt.setString(6, otpExpiry);

            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();  // Handle exception properly
        }
    }

    // Dynamically send OTP using the built-in email sending functionality
    private void sendOTPToEmail(String recipient, String otp) throws MessagingException {
        setupServerProperties();  // Setup mail server properties
        
        // Drafting the email with dynamic content
        String emailSubject = "Your Pollify OTP Verification Code";
        String emailBody = "<html><body>"
                + "<h2>Hello,</h2>"
                + "<p>Thank you for registering at Pollify. Your OTP verification code is:</p>"
                + "<h1 style='color:#3498db;'>" + otp + "</h1>"
                + "<p>Please use this code to verify your email. The OTP is valid for 10 minutes.</p>"
                + "<br>"
                + "<p>If you did not request this, please ignore this email.</p>"
                + "<p>Best Regards, <br>Pollify Team</p>"
                + "</body></html>";
        
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
        mimeMessage.setSubject(subject);
        MimeMultipart multipart = new MimeMultipart();

        MimeBodyPart bodyPart = new MimeBodyPart();
        bodyPart.setContent(body, "text/html");
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
