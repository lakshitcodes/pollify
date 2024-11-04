package com.pollify;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class RegisterVote extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Database connection variables
    private static final String jdbcURL = DBCredentials.getDbUrl();
    private static final String jdbcUsername = DBCredentials.getDbUser();
    private static final String jdbcPassword = DBCredentials.getDbPass();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();

        // Check if the user is logged in and is a voter
        if (session == null || session.getAttribute("username") == null || "admin".equals(session.getAttribute("role"))) {
            response.sendRedirect("accessDenied.jsp");
            return;
        }

        // Getting the candidate ID from the request
        String candidateIdParam = request.getParameter("candidateId");
        int candidateId;
        try {
            candidateId = Integer.parseInt(candidateIdParam); // Parse candidateId
        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "Invalid candidate ID format.");
            response.sendRedirect("error.jsp");
            return;
        }

        // Get VotingPeriod from session
        VotingPeriod votingPeriod = (VotingPeriod) session.getAttribute("votingPeriod");
        if (votingPeriod == null) {
            session.setAttribute("errorMessage", "No voting period found.");
            response.sendRedirect("error.jsp");
            return;
        }

        // Finding the userId
        String username = (String) session.getAttribute("username");
        String email = (String) session.getAttribute("email");

        int userId = -1;
        try (Connection connection = DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword)) {
            // Check user existence
            String userIdQuery = "SELECT id FROM users WHERE username = ? AND email = ?";
            try (PreparedStatement statement = connection.prepareStatement(userIdQuery)) {
                statement.setString(1, username);
                statement.setString(2, email);
                try (ResultSet resultSet = statement.executeQuery()) {
                    if (resultSet.next()) {
                        userId = resultSet.getInt("id");
                    } else {
                        session.setAttribute("errorMessage", "No such user found.");
                        response.sendRedirect("error.jsp");
                        return;
                    }
                }
            }

            // Check if voting period is active
            if (!votingPeriod.isActive()) {
                session.setAttribute("errorMessage", "The voting period is not currently active.");
                response.sendRedirect("error.jsp");
                return;
            }

            // Register the vote
            String registerVoteQuery = "INSERT INTO votes (user_id, candidate_id, voting_period_id) VALUES (?, ?, ?)";
            try (PreparedStatement statement = connection.prepareStatement(registerVoteQuery)) {
                statement.setInt(1, userId);
                statement.setInt(2, candidateId);
                statement.setInt(3, votingPeriod.getId());
                statement.executeUpdate();

                // Redirect to success page or voting confirmation
                response.sendRedirect("voteSuccess.jsp"); // Make sure this page exists
            }

        } catch (SQLException e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Database error: " + e.getMessage());
            response.sendRedirect("error.jsp");
        }
    }
}
