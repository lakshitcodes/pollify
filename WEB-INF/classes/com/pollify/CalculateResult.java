package com.pollify;

import com.pollify.DBCredentials;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.sql.Timestamp;
public class CalculateResult extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Database connection variables
    private static final String jdbcURL = DBCredentials.getDbUrl();
    private static final String jdbcUsername = DBCredentials.getDbUser();
    private static final String jdbcPassword = DBCredentials.getDbPass();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();

        // Check if the user is logged in and is an admin
        if (session == null || session.getAttribute("username") == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect("accessDenied.jsp");
            return;
        }
        int pollId = Integer.parseInt(request.getParameter("pollId"));

        // Queries
        String resultQuery = "SELECT candidate_id, COUNT(*) AS vote_count FROM Votes WHERE voting_period_id = ? GROUP BY candidate_id";
        String totalVoterQuery = "SELECT COUNT(*) AS user_count FROM Users WHERE role IN ('voter', 'candidate')";
        String totalVoteQuery = "SELECT COUNT(*) AS vote_count FROM Votes WHERE voting_period_id = ?";
        String winnerUsernameQuery = "SELECT username FROM Users WHERE id = ?";
        String insertResultQuery = "INSERT INTO Results (voting_period_id, winner_candidate_id, total_votes, winner_percentage, turnout_ratio, start_time, end_time) VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (Connection connection = DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);
             PreparedStatement resultStatement = connection.prepareStatement(resultQuery);
             PreparedStatement totalVoterStatement = connection.prepareStatement(totalVoterQuery);
             PreparedStatement totalVoteStatement = connection.prepareStatement(totalVoteQuery);
             PreparedStatement winnerUsernameStatement = connection.prepareStatement(winnerUsernameQuery);
             PreparedStatement insertResultStatement = connection.prepareStatement(insertResultQuery, Statement.RETURN_GENERATED_KEYS)) {

            // Set the poll ID
            resultStatement.setInt(1, pollId);
            ResultSet result = resultStatement.executeQuery();

            // Calculate the total number of voters
            ResultSet totalVoterResult = totalVoterStatement.executeQuery();
            int totalVoters = 0;
            if (totalVoterResult.next()) {
                totalVoters = totalVoterResult.getInt("user_count");
            }

            // Calculate the total votes cast in this poll
            totalVoteStatement.setInt(1, pollId);
            ResultSet totalVoteResult = totalVoteStatement.executeQuery();
            int totalVotes = 0;
            if (totalVoteResult.next()) {
                totalVotes = totalVoteResult.getInt("vote_count");
            }

            // Calculate turnout ratio
            double turnoutRatio = (double) totalVotes / totalVoters * 100;

            // Determine the winner
            int winnerCandidateId = -1;
            int maxVotes = 0;
            while (result.next()) {
                int candidateId = result.getInt("candidate_id");
                int voteCount = result.getInt("vote_count");

                if (voteCount > maxVotes) {
                    maxVotes = voteCount;
                    winnerCandidateId = candidateId;
                }
            }

            // Calculate winner's percentage of the votes
            double winnerPercentage = (double) maxVotes / totalVotes * 100;

            // Retrieve winner's username
            String winnerUsername = "";
            if (winnerCandidateId != -1) {
                winnerUsernameStatement.setInt(1, winnerCandidateId);
                ResultSet winnerResult = winnerUsernameStatement.executeQuery();
                if (winnerResult.next()) {
                    winnerUsername = winnerResult.getString("username");
                }
            }

            // Insert the result into the Results table
            insertResultStatement.setInt(1, pollId);
            insertResultStatement.setInt(2, winnerCandidateId);
            insertResultStatement.setInt(3, totalVotes);
            insertResultStatement.setDouble(4, winnerPercentage);
            insertResultStatement.setDouble(5, turnoutRatio);
            insertResultStatement.setString(6, "start_time_placeholder"); // Replace with actual start time
            insertResultStatement.setString(7, "end_time_placeholder");   // Replace with actual end time
            insertResultStatement.executeUpdate();

            // Retrieve declared_at timestamp from the generated keys
            Timestamp declaredAt = null;
            ResultSet generatedKeys = insertResultStatement.getGeneratedKeys();
            if (generatedKeys.next()) {
                declaredAt = generatedKeys.getTimestamp(1);
            }

            // Prepare the result data for forwarding to FinalResult.jsp
            Result pollResult = new Result(0, pollId, winnerCandidateId, totalVotes, winnerPercentage, turnoutRatio, "start_time_placeholder", "end_time_placeholder", declaredAt.toString(), winnerUsername);

            request.setAttribute("pollResult", pollResult);
            request.getRequestDispatcher("FinalResult.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            throw new ServletException(e);
        }
    }
}
