package com.pollify;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.*;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Random;
import javax.servlet.http.HttpSession;
import javax.mail.*;
import javax.mail.internet.*;
import java.util.Properties;

public class VerifyOtpServlet extends HttpServlet {

    private static final String DB_URL = "jdbc:mysql://localhost:3306/pollify";
    private static final String DB_USER = "root";
    private static final String DB_PASS = "30062004";
    private Session newSession;
    private MimeMessage mimeMessage;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String otpEntered = request.getParameter("otp");  // Get OTP entered by user
        HttpSession session = request.getSession();
        String email = (String) session.getAttribute("email"); // Retrieve email from session

        // Fetch the user's stored OTP and its expiry from the database
        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
            PreparedStatement stmt = conn.prepareStatement("SELECT username, otp_code, otp_expiry FROM users WHERE email = ?")) {

            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                String username = rs.getString("username");
                String storedOtp = rs.getString("otp_code");
                String otpExpiryStr = rs.getString("otp_expiry");

                // Convert the expiry time from string to LocalDateTime
                LocalDateTime otpExpiry = LocalDateTime.parse(otpExpiryStr, DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));

                // Validate OTP and expiry
                if (otpEntered.equals(storedOtp) && LocalDateTime.now().isBefore(otpExpiry)) {
                    // OTP is valid and not expired, update user's status to "approved"

                    updateUserStatus(email);
                    sendVerificationSuccessEmail(email, username);  // Send verification success email
                    response.sendRedirect("home.jsp");  // Redirect to home page on success

                } else {
                    // OTP is either incorrect or expired
                    if (LocalDateTime.now().isAfter(otpExpiry)) {
                        // If OTP is expired, generate and send a new OTP
                        String newOtp = generateNewOTP();
                        updateOtpInDB(email, newOtp);
                        request.setAttribute("message", "OTP expired, a new OTP has been sent to your email.");
                    } else {
                        request.setAttribute("message", "Invalid OTP. Please try again.");
                    }
                    request.getRequestDispatcher("OtpVerification.jsp").forward(request, response);
                }
            } else {
                // Email not found in the database
                request.setAttribute("message", "Email not found. Please register.");
                request.getRequestDispatcher("register.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            e.printStackTrace(); // Handle SQL exceptions
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error.");
        }
    }

    // Update user's status to approved
    private void updateUserStatus(String email) {
        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
             PreparedStatement stmt = conn.prepareStatement("UPDATE users SET status = 'approved' WHERE email = ?")) {

            stmt.setString(1, email);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace(); // Handle SQL exceptions
        }
    }

    // Generate a new OTP (6-digit number)
    private String generateNewOTP() {
        Random random = new Random();
        int otp = 100000 + random.nextInt(900000);  // Generate 6-digit number
        return String.valueOf(otp);
    }

    // Update OTP and expiry in the database
    private void updateOtpInDB(String email, String newOtp) {
        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
             PreparedStatement stmt = conn.prepareStatement("UPDATE users SET otp_code = ?, otp_expiry = ? WHERE email = ?")) {

            String otpExpiry = LocalDateTime.now().plusMinutes(10).format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
            stmt.setString(1, newOtp);
            stmt.setString(2, otpExpiry);
            stmt.setString(3, email);
            stmt.executeUpdate();

            // Send the new OTP to the user's email
            sendOTPToEmail(email, newOtp);

        } catch (SQLException e) {
            e.printStackTrace(); // Handle SQL exceptions
        }
    }

    // Send OTP to the user's email
    private void sendOTPToEmail(String recipient, String otp) {
        try {
            setupServerProperties();  // Setup mail server properties
            String emailSubject = "Your Pollify OTP Verification Code";
            String emailBody = "<html><body style='font-family: Arial, sans-serif; background-color: #f4f4f4; margin: 0; padding: 0;'>"
                    + "<div style='max-width: 600px; margin: 20px auto; background: white; border-radius: 10px; padding: 30px; box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);'>"
                    + "<h2 style='color: #333; text-align: center;'>Welcome to Pollify!</h2>"
                    + "<p style='font-size: 16px; color: #555; line-height: 1.5;'>Your OTP verification code is:</p>"
                    + "<h1 style='color: #3498db; font-size: 40px; margin: 20px 0; text-align: center; border: 2px solid #3498db; border-radius: 5px; padding: 10px;'>"
                    + otp + "</h1>"
                    + "<p style='font-size: 16px; color: #555; line-height: 1.5;'>Please use this code to verify your email. The OTP is valid for <strong>10 minutes</strong>.</p>"
                    + "<hr style='border: 1px solid #e0e0e0; margin: 20px 0;'>"
                    + "<p style='font-size: 16px; color: #555; line-height: 1.5;'>If you did not request this, please ignore this email.</p>"
                    + "<p style='font-size: 16px; color: #555; line-height: 1.5;'>Best Regards,<br><strong style='color: #3498db;'>Pollify Team</strong></p>"
                    + "</div>"
                    + "</body></html>";

            draftEmail(recipient, emailSubject, emailBody);  // Draft the email
            sendMail();  // Send the email

        } catch (MessagingException e) {
            e.printStackTrace(); // Handle email exceptions
        }
    }
    // Verification Successful Email
    private void sendVerificationSuccessEmail(String recipient, String username) {
        try {
            setupServerProperties();  // Setup mail server properties
            String emailSubject = "Congratulations! Your Account is Verified";
            String emailBody = "<html><body style='font-family: Arial, sans-serif; background-color: #f4f4f4; margin: 0; padding: 0;'>"
                    + "<div style='max-width: 600px; margin: 20px auto; background: white; border-radius: 10px; padding: 30px; box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);'>"
                    + "<h2 style='color: #333; text-align: center;'>Welcome to Pollify, " + username + "!</h2>"
                    + "<p style='font-size: 16px; color: #555; line-height: 1.5;'>Congratulations! Your account has been successfully verified.</p>"
                    + "<p style='font-size: 16px; color: #555; line-height: 1.5;'>You can now start voting and participating in polls on our platform.</p>"
                    + "<p style='font-size: 16px; color: #555; line-height: 1.5;'>If you have any questions, feel free to reach out to our support team.</p>"
                    + "<hr style='border: 1px solid #e0e0e0; margin: 20px 0;'>"
                    + "<p style='font-size: 16px; color: #555; line-height: 1.5;'>Best Regards,<br><strong style='color: #3498db;'>Pollify Team</strong></p>"
                    + "</div>"
                    + "</body></html>";
    
            draftEmail(recipient, emailSubject, emailBody);  // Draft the email
            sendMail();  // Send the email
    
        } catch (MessagingException e) {
            e.printStackTrace(); // Handle email exceptions
        }
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
