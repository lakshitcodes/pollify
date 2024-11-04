package com.pollify;

import com.pollify.DBCredentials;

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
public class CheckResult extends HttpServlet {
    private static final long serialVersionUID = 1L;


    // Database connection variables
    private static final String jdbcURL = DBCredentials.getDbUrl();
    private static final String jdbcUsername = DBCredentials.getDbUser();
    private static final String jdbcPassword = DBCredentials.getDbPass();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();

        // Check if the user is logged in and is an admin
        if (session == null || session.getAttribute("username") == null || "admin".equals(session.getAttribute("role"))) {
            response.sendRedirect("accessDenied.jsp");
            return;
        }
        int pollId = Integer.parseInt(request.getParameter("pollId"));

        // Queries
        String resultQuery = "SELECT * FROM Results WHERE voting_period_id = ?";
        Result pollResult = null;
        try (Connection connection = DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);
             PreparedStatement resultStatement = connection.prepareStatement(resultQuery)
             ) {

            // Set the poll ID
            resultStatement.setInt(1, pollId);
            ResultSet result = resultStatement.executeQuery();

            // Get the poll result
            if (result.next()) {
                int id = result.getInt("id");
                int votingPeriodId = result.getInt("voting_period_id");
                int winnerCandidateId = result.getInt("winner_candidate_id");
                int totalVotes = result.getInt("total_votes");
                double winnerPercentage = result.getDouble("winner_percentage");
                double turnoutRatio = result.getDouble("turnout_ratio");
                String startTime = result.getString("start_time");
                String endTime = result.getString("end_time");


                // Get the winner's username
                String winnerUsername = "No winner";
                String winnerQuery = "SELECT username FROM Users WHERE id = ?";
                try (PreparedStatement winnerStatement = connection.prepareStatement(winnerQuery)) {
                    winnerStatement.setInt(1, winnerCandidateId);
                    ResultSet winnerResult = winnerStatement.executeQuery();
                    if (winnerResult.next()) {
                        winnerUsername = winnerResult.getString("username");
                    }
                }

                pollResult = new Result(id, votingPeriodId, winnerCandidateId, totalVotes, winnerPercentage, turnoutRatio, startTime, endTime, winnerUsername);
            }
            
            // Set the poll result in the session
            session.setAttribute("pollResult", pollResult);
            response.sendRedirect("ElectionResult.jsp");


        } catch (SQLException e) {
            e.printStackTrace();
            throw new ServletException(e);
        }
    }
}
