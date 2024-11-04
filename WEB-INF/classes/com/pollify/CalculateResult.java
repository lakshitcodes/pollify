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
import java.util.ArrayList;
import java.util.List;

public class CalculateResult extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Database connection variables
    private static final String jdbcURL = DBCredentials.getDbUrl();
    private static final String jdbcUsername = DBCredentials.getDbUser();
    private static final String jdbcPassword = DBCredentials.getDbPass();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();

        // Check if the user is logged in and is a voter
        if (session == null || session.getAttribute("username") == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect("accessDenied.jsp");
            return;
        }
        int PollId = Integer.parseInt(request.getParameter("pollId"));

        String ResultQuery = "SELECT candidate_id, COUNT(*) AS vote_count FROM Votes WHERE voting_period_id = ? GROUP BY candidate_id";

        String totalVoterQuery = "SELECT COUNT(*) AS user_count FROM Users WHERE role IN ('voter', 'candidate')";

        String totalVoteQuery = "SELECT COUNT(*) AS vote_count FROM Votes WHERE voting_period_id = ?";

        try(Connection connection = DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);
            PreparedStatement resultStatement = connection.prepareStatement(ResultQuery);
            PreparedStatement totalVoterStatement = connection.prepareStatement(totalVoterQuery);
            PreparedStatement totalVoteStatement = connection.prepareStatement(totalVoteQuery)) {

            resultStatement.setInt(1, PollId);
            ResultSet result = resultStatement.executeQuery();

            totalVoterStatement.executeQuery();
            ResultSet totalVoter = totalVoterStatement.getResultSet();

            totalVoteStatement.setInt(1, PollId);
            ResultSet totalVote = totalVoteStatement.executeQuery();

            // Pending From Here
        } catch (SQLException e) {
            e.printStackTrace();
            throw new ServletException(e);
        }
    }
}
