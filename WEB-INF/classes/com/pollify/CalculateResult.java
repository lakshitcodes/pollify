package com.pollify;

import com.pollify.DBCredentials;
import com.pollify.SendMail;

import java.sql.Statement;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import javax.mail.internet.*;
import javax.mail.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.sql.Timestamp;
public class CalculateResult extends HttpServlet {
    private static final long serialVersionUID = 1L;

    SendMail mailer = new SendMail();

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
        String votingPeriodQuery = "SELECT start_time, end_time FROM VotingPeriod WHERE id = ?";
        String allEmails = "SELECT email FROM Users";

        try (Connection connection = DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);
             PreparedStatement resultStatement = connection.prepareStatement(resultQuery);
             PreparedStatement totalVoterStatement = connection.prepareStatement(totalVoterQuery);
             PreparedStatement totalVoteStatement = connection.prepareStatement(totalVoteQuery);
             PreparedStatement winnerUsernameStatement = connection.prepareStatement(winnerUsernameQuery);
             PreparedStatement insertResultStatement = connection.prepareStatement(insertResultQuery, Statement.RETURN_GENERATED_KEYS);
             PreparedStatement votingPeriodStatement = connection.prepareStatement(votingPeriodQuery);
             PreparedStatement allEmailsStatement = connection.prepareStatement(allEmails)
             ) {

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
            
            // Retrieve start and end times of the voting period
            votingPeriodStatement.setInt(1, pollId);
            ResultSet votingPeriodResult = votingPeriodStatement.executeQuery();
            String startTime = "";
            String endTime = "";
            if (votingPeriodResult.next()) {
                startTime = votingPeriodResult.getString("start_time");
                endTime = votingPeriodResult.getString("end_time");
            }

            // Insert the result into the Results table
            insertResultStatement.setInt(1, pollId);
            insertResultStatement.setInt(2, winnerCandidateId);
            insertResultStatement.setInt(3, totalVotes);
            insertResultStatement.setDouble(4, winnerPercentage);
            insertResultStatement.setDouble(5, turnoutRatio);
            insertResultStatement.setString(6, startTime); // Replace with actual start time
            insertResultStatement.setString(7, endTime);   // Replace with actual end time
            insertResultStatement.executeUpdate();

            // Prepare the result data for forwarding to FinalResult.jsp
            Result pollResult = new Result(0, pollId, winnerCandidateId, totalVotes, winnerPercentage, turnoutRatio, startTime, endTime, winnerUsername);

            session.setAttribute("pollResult", pollResult);

            String emailBody = "<html><body style='font-family: Arial, sans-serif; background-color: #f4f4f4; margin: 0; padding: 0;'>"
            + "<div style='max-width: 600px; margin: 20px auto; background: white; border-radius: 10px; box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);'>"
            + "<div style='background-color: #3b82f6; color: #ffffff; text-align: center; padding: 20px; font-size: 1.5em;'>Results Declared</div>"
            + "<div style='padding: 20px; text-align: center; line-height: 1.6;'>"
            + "<p style='font-size: 2em; font-weight: bold; color: #3b82f6; margin: 10px 0;'> 🎉 #{winnerName} 🎉 </p>"
            + "<p style='font-size: 1.2em; color: #333;'>Voting Period ID: <span style='color: #3b82f6;'>#{votingId}</span></p>"
            + "<p>Total Votes: <span style='color: #3b82f6; font-weight: bold;'>#{totalVotes}</span></p>"
            + "<p>Winner Percentage: <span style='color: #3b82f6; font-weight: bold;'>#{winnerPercentage}%</span></p>"
            + "<p>Turnout Ratio: <span style='color: #3b82f6; font-weight: bold;'>#{turnoutRatio}%</span></p>"
            + "<p>Start Time: <span style='color: #3b82f6; font-weight: bold;'>#{startTime}</span></p>"
            + "<p>End Time: <span style='color: #3b82f6; font-weight: bold;'>#{endTime}</span></p>"
            + "</div>"
            + "<div style='background-color: #f9fafb; padding: 15px; text-align: center; font-size: 0.9em; color: #6b7280;'>"
            + "&copy; 2024 Voting System. All rights reserved."
            + "</div>"
            + "</div>"
            + "</body></html>";

        // Replace placeholders with actual values
        String resultEmail = emailBody.replace("#{votingId}",String.valueOf(pollId))
            .replace("#{winnerName}", winnerUsername)
            .replace("#{totalVotes}", String.valueOf(totalVotes))
            .replace("#{winnerPercentage}", String.valueOf(winnerPercentage))
            .replace("#{turnoutRatio}", String.valueOf(turnoutRatio))
            .replace("#{startTime}", startTime)
            .replace("#{endTime}", endTime);

        // Send the result email to all users
        ResultSet emails = allEmailsStatement.executeQuery();
        while (emails.next()) {
            String email = emails.getString("email");
            try {
                mailer.sendMailToUser(email, "Voting Result Declared",resultEmail);  // Send dynamic OTP via email
            } catch (MessagingException e) {
                e.printStackTrace(); // Handle error appropriately
            }
        }

        response.sendRedirect("FinalResult.jsp");


        } catch (SQLException e) {
            e.printStackTrace();
            throw new ServletException(e);
        }
    }
}
