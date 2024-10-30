package com.pollify;

import com.pollify.DBCredentials;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/castVote") // Make sure to add this annotation for mapping
public class CastVote extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Database connection variables
    private static final String jdbcURL = DBCredentials.getDbUrl();
    private static final String jdbcUsername = DBCredentials.getDbUser();
    private static final String jdbcPassword = DBCredentials.getDbPass();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();

        // Check if the user is logged in and is a voter
        if (session == null || session.getAttribute("username") == null || !"voter".equals(session.getAttribute("role"))) {
            response.sendRedirect("accessDenied.jsp");
            return;
        }

        // Get the candidate ID from the request
        int candidateId = Integer.parseInt(request.getParameter("candidate_id"));
        int userId = (int) session.getAttribute("userId"); // Assuming userId is stored in the session

        // Check if voting is within the allowed time frame
        try (Connection connection = DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword)) {
            VotingPeriod votingPeriod = getActiveVotingPeriod(connection);

            if (votingPeriod == null) {
                session.setAttribute("errorMessage", "No active voting period available.");
                response.sendRedirect("error.jsp");
                return;
            }

            // Check if the current time is within the voting period
            long currentTime = System.currentTimeMillis();
            if (currentTime < votingPeriod.getStartTime().getTime() || currentTime > votingPeriod.getEndTime().getTime()) {
                session.setAttribute("errorMessage", "Voting is not allowed outside the designated time period.");
                response.sendRedirect("error.jsp");
                return;
            }

            // Insert the vote into the database
            String sql = "INSERT INTO Votes (user_id, candidate_id, voting_period_id, vote_time) VALUES (?, ?, ?, NOW())";
            try (PreparedStatement statement = connection.prepareStatement(sql)) {
                // Set the parameters
                statement.setInt(1, userId);
                statement.setInt(2, candidateId);
                statement.setInt(3, votingPeriod.getId());

                // Execute the insert
                statement.executeUpdate();
            }

            // Redirect to a success page
            session.setAttribute("successMessage", "Your vote has been cast successfully!");
            response.sendRedirect("viewResults.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        }
    }

    private VotingPeriod getActiveVotingPeriod(Connection connection) throws SQLException {
        // Logic to fetch the active voting period details from the database
        String sql = "SELECT id, start_time, end_time FROM votingperiod WHERE is_active = 1";
        try (PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet resultSet = statement.executeQuery()) {
            if (resultSet.next()) {
                return new VotingPeriod(
                    resultSet.getInt("id"),
                    resultSet.getTimestamp("start_time"),
                    resultSet.getTimestamp("end_time")
                );
            }
            return null; // No active voting period found
        }
    }

    // Inner class to hold voting period details
    private class VotingPeriod {
        private int id;
        private java.sql.Timestamp startTime;
        private java.sql.Timestamp endTime;

        public VotingPeriod(int id, java.sql.Timestamp startTime, java.sql.Timestamp endTime) {
            this.id = id;
            this.startTime = startTime;
            this.endTime = endTime;
        }

        public int getId() {
            return id;
        }

        public java.sql.Timestamp getStartTime() {
            return startTime;
        }

        public java.sql.Timestamp getEndTime() {
            return endTime;
        }
    }
}
