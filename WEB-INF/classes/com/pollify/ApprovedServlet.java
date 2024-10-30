package com.pollify;
import com.pollify.SendMail;
import com.pollify.DBCredentials;

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

public class ApprovedServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private static final String jdbcURL = DBCredentials.getDbUrl();
    private static final String jdbcUsername = DBCredentials.getDbUser();
    private static final String jdbcPassword = DBCredentials.getDbPass();
    SendMail mailer = new SendMail();


    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String email = request.getParameter("email");

        // Check if the parameters are not null
        if (username == null || email == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Username or Email is missing.");
            return;
        }

        // Database connection and operations
        try (Connection conn = DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword)) { // Ensure you have a method to get DB connection
            // Delete the candidate application
            String deleteApplicationSQL = "DELETE FROM candidate_applications WHERE username = ? AND email = ?";
            try (PreparedStatement pstmt = conn.prepareStatement(deleteApplicationSQL)) {
                pstmt.setString(1, username);
                pstmt.setString(2, email);
                pstmt.executeUpdate();
            }

            // Update the user role
            String updateUserSQL = "UPDATE Users SET role = ? WHERE username = ?";
            try (PreparedStatement pstmt = conn.prepareStatement(updateUserSQL)) {
                pstmt.setString(1, "Candidate");
                pstmt.setString(2, username);
                pstmt.executeUpdate();
            }
            String emailBody = "<html>" +
            "<head>" +
            "<style>" +
            "body { font-family: Arial, sans-serif; line-height: 1.6; }" +
            "h3 { color: #2c3e50; }" +
            "strong { color: #2980b9; }" +
            "ol { margin-left: 20px; }" +
            "p { margin: 10px 0; }" +
            "</style>" +
            "</head>" +
            "<body>" +
            "<p>Dear " + username + ",</p>" +
            "<p><strong>Congratulations!</strong></p>" +
            "<p>We are thrilled to inform you that your application to become a candidate on <strong>Pollify</strong> has been approved. You are now eligible to participate in various elections and contribute to the democratic process.</p>" +
            "<p>As a candidate, you will have the opportunity to present your manifesto and engage with voters. Your contributions can help shape the future of our community.</p>" +
            "<h3>Important Information:</h3>" +
            "<ol>" +
            "<li><strong>Candidate Responsibilities:</strong> As a candidate, you are expected to conduct yourself with integrity and respect for all voters and fellow candidates.</li>" +
            "<li><strong>Manifesto Submission:</strong> You must submit your manifesto by the deadline provided on the platform. Late submissions may disqualify you from participating in the elections.</li>" +
            "<li><strong>Election Regulations:</strong> Please ensure that you familiarize yourself with the election regulations outlined on the Pollify platform. Adherence to these rules is crucial for a fair electoral process.</li>" +
            "</ol>" +
            "<h3>Terms and Conditions:</h3>" +
            "<p>By participating in the elections as a candidate, you agree to abide by all the rules and regulations set forth by Pollify. Failure to comply may result in disqualification from the election process.</p>" +
            "<p>If you have any questions or need assistance, please do not hesitate to reach out to our support team.</p>" +
            "<p>Thank you for your commitment to enhancing democracy in our community!</p>" +
            "<p>Best regards,<br>" +
            "<strong>Pollify Team</strong></p>" +
            "</body>" +
            "</html>";
    
            String emailSubject = "Congratulations! Your Application has been Approved";

            try {
                mailer.sendMailToUser(email, emailSubject,emailBody);  // Send dynamic OTP via email
            } catch (MessagingException e) {
                e.printStackTrace(); // Handle error appropriately
            }
            // Optionally, set a success message in session and redirect to a success page
            request.getSession().setAttribute("successMessage", "Candidate approved successfully.");
            response.sendRedirect("approveCandidates.jsp");

        } catch (SQLException e) {
            // Handle SQL exceptions
            e.printStackTrace();
            request.getSession().setAttribute("errorMessage", "Database error: " + e.getMessage());
            response.sendRedirect("approveCandidates.jsp");
        }
    }
}
