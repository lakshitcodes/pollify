package com.pollify;

import com.pollify.SendMail;
import com.pollify.DBCredentials;


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
import javax.servlet.http.HttpSession;


public class RegisterServlet extends HttpServlet {

    private static final String DB_URL = DBCredentials.getDbUrl();
    private static final String DB_USER = DBCredentials.getDbUser();
    private static final String DB_PASS = DBCredentials.getDbPass();

    
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

        SendMail mailer = new SendMail();
        
        // Send OTP email to the user
        String emailSubject = "Your Pollify OTP Verification Code";
        String emailBody = "<html><body style='font-family: Arial, sans-serif; background-color: #f4f4f4; margin: 0; padding: 0;'>"
                + "<div style='max-width: 600px; margin: 20px auto; background: white; border-radius: 10px; padding: 30px; box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);'>"
                + "<h2 style='color: #333; text-align: center;'>Welcome to Pollify!</h2>"
                + "<p style='font-size: 16px; color: #555; line-height: 1.5;'>Thank you for registering. Your OTP verification code is:</p>"
                + "<h1 style='color: #3498db; font-size: 40px; margin: 20px 0; text-align: center; border: 2px solid #3498db; border-radius: 5px; padding: 10px;'>"
                + otp + "</h1>"
                + "<p style='font-size: 16px; color: #555; line-height: 1.5;'>Please use this code to verify your email. The OTP is valid for <strong>10 minutes</strong>.</p>"
                + "<hr style='border: 1px solid #e0e0e0; margin: 20px 0;'>"
                + "<p style='font-size: 16px; color: #555; line-height: 1.5;'>If you did not request this, please ignore this email.</p>"
                + "<p style='font-size: 16px; color: #555; line-height: 1.5;'>Best Regards,<br><strong style='color: #3498db;'>Pollify Team</strong></p>"
                + "</div>"
                + "</body></html>";
        try {
            mailer.sendMailToUser(email, emailSubject,emailBody);  // Send dynamic OTP via email
        } catch (MessagingException e) {
            e.printStackTrace(); // Handle error appropriately
        }
        
        // Redirect to OTP verification page (assuming you have such a page)
       // In your RegisterServlet.java
        HttpSession session = request.getSession();
        session.setAttribute("email", email); // Store email in session
        response.sendRedirect("OtpVerification.jsp"); // Redirect to OTP page

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
    
}
