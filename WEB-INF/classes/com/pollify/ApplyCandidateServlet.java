package com.pollify;

import com.pollify.DBCredentials;

import java.io.IOException;
import java.net.URLEncoder;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class ApplyCandidateServlet extends HttpServlet {

    private static final String dbURL = DBCredentials.getDbUrl();
    private static final String dbUser = DBCredentials.getDbUser();
    private static final String dbPass = DBCredentials.getDbPass();

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    HttpSession session = request.getSession(false);
    String username = (String) session.getAttribute("username");
    String email = (String) session.getAttribute("email"); // Assuming you store email in session

    if (username != null) {
        String statusMessage;
        String checkApplicationSQL = "SELECT * FROM candidate_applications WHERE username = ? AND email = ?";

        try (Connection connection = DriverManager.getConnection(dbURL, dbUser, dbPass);
             PreparedStatement checkStatement = connection.prepareStatement(checkApplicationSQL)) {

            checkStatement.setString(1, username);
            checkStatement.setString(2, email);
            ResultSet rs = checkStatement.executeQuery();

            if (rs.next()) {
                // User has already applied
                statusMessage = "Application Under Review";
            } else {
                // Insert new application
                String insertApplicationSQL = "INSERT INTO candidate_applications (username, email) VALUES (?, ?)";
                try (PreparedStatement insertStatement = connection.prepareStatement(insertApplicationSQL)) {
                    insertStatement.setString(1, username);
                    insertStatement.setString(2, email);
                    int rowsInserted = insertStatement.executeUpdate();

                    if (rowsInserted > 0) {
                        statusMessage = "Application submitted successfully. Your application is under review.";
                    } else {
                        statusMessage = "Failed to submit application. Please try again.";
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            statusMessage = "Error occurred: " + e.getMessage();
        }

        // Redirect back to voterDashboard.jsp with status message
        response.sendRedirect("voterDashboard.jsp?status=" + URLEncoder.encode(statusMessage, "UTF-8"));
    } else {
        response.sendRedirect("login.jsp");
    }
}

}
