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

public class RejectedServlet extends HttpServlet {
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
        try (Connection conn = DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword)) {
            // Delete the candidate application
            String deleteApplicationSQL = "DELETE FROM candidate_applications WHERE username = ? AND email = ?";
            try (PreparedStatement pstmt = conn.prepareStatement(deleteApplicationSQL)) {
                pstmt.setString(1, username);
                pstmt.setString(2, email);
                pstmt.executeUpdate();
            }

            // Email body for rejection notification
            String emailBody = "<html>" +
        "<head>" +
        "<style>" +
        "body { font-family: Arial, sans-serif; line-height: 1.6; }" +
        "p { margin: 10px 0; }" +
        "strong { color: #2980b9; }" +
        "</style>" +
        "</head>" +
        "<body>" +
        "<p>Dear " + username + ",</p>" +
        "<p>We regret to inform you that your application to become a candidate on <strong>Pollify</strong> has been rejected.</p>" +
        "<p>We appreciate your interest in participating in our elections. However, after careful consideration, we are unable to approve your application at this time.</p>" +
        "<p>If you would like to discuss your application or seek feedback, please feel free to reach out to our support team.</p>" +
        "<p>Thank you for your understanding, and we encourage you to apply again in the future.</p>" +
        "<p>Best regards,<br>" +
        "<strong>Pollify Team</strong></p>" +
        "</body>" +
        "</html>";

            String emailSubject = "Application Rejection Notification";

            // Send rejection email
            try {
                mailer.sendMailToUser(email, emailSubject, emailBody); // Send rejection email
            } catch (MessagingException e) {
                e.printStackTrace(); // Handle error appropriately
            }

            // Optionally, set a success message in session and redirect to a success page
            request.getSession().setAttribute("successMessage", "Candidate rejected successfully.");
            response.sendRedirect("approveCandidates.jsp");

        } catch (SQLException e) {
            // Handle SQL exceptions
            e.printStackTrace();
            request.getSession().setAttribute("errorMessage", "Database error: " + e.getMessage());
            response.sendRedirect("approveCandidates.jsp");
        }
    }
}
