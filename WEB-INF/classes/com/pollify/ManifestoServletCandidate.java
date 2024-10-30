package com.pollify;

import com.pollify.DBCredentials;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class ManifestoServletCandidate extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Database connection variables
    private static final String jdbcURL = DBCredentials.getDbUrl();
    private static final String jdbcUsername = DBCredentials.getDbUser();
    private static final String jdbcPassword = DBCredentials.getDbPass();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        
        // Check if the user is logged in and is a candidate
        if (session == null || session.getAttribute("username") == null || !"candidate".equals(session.getAttribute("role"))) {
            response.sendRedirect("accessDenied.jsp");
            return;
        }
        
        String username = (String) session.getAttribute("username");
        String sql = "SELECT manifesto FROM Users WHERE username = ?";
        
        try (Connection connection = DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setString(1, username);
            ResultSet resultSet = statement.executeQuery();

            // Check if a manifesto is found
            if (resultSet.next()) {
                String manifestoLink = resultSet.getString("manifesto");
                session.setAttribute("manifestoLink", manifestoLink); // Store manifesto link in session
            } else {
                session.setAttribute("manifestoLink", null); // No manifesto found, set to null
            }

            // Redirect to the manifesto.jsp page
            response.sendRedirect("manifesto.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            // Handle exceptions (e.g., log the error, set an error message in the session, etc.)
            session.setAttribute("errorMessage", "An error occurred while fetching the manifesto.");
            response.sendRedirect("error.jsp"); // Redirect to an error page
        }
    }
}
