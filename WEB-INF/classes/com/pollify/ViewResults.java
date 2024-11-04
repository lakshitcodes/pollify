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

public class ViewResults extends HttpServlet {
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

        String resultQuery = "SELECT voting_period_id,start_time,end_time FROM Results";

        List<VotingPeriod> votingPeriods = new ArrayList<>();
        try (Connection connection = DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);
             PreparedStatement resultStatement = connection.prepareStatement(resultQuery);
             ) {

            // Set the poll ID
            ResultSet result = resultStatement.executeQuery();

            // Calculate the total number of voters
            ResultSet allVotingPeriods = resultStatement.executeQuery();
            
            while (allVotingPeriods.next()) {
                int votingPeriodId = allVotingPeriods.getInt("voting_period_id");
                String startTime = allVotingPeriods.getString("start_time");
                String endTime = allVotingPeriods.getString("end_time");
                VotingPeriod votingPeriod = new VotingPeriod(votingPeriodId, startTime, endTime,false);
                votingPeriods.add(votingPeriod);
            }

            session.setAttribute("votingPeriods", votingPeriods);
            response.sendRedirect("ViewResults.jsp");
        } catch (SQLException e) {
            e.printStackTrace();
            throw new ServletException(e);
        }
    }
}
