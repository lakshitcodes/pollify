package com.pollify;

import com.pollify.DBCredentials;
import com.pollify.VotingPeriod;

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

public class FindActivePolls extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Database connection variables
    private static final String jdbcURL = DBCredentials.getDbUrl();
    private static final String jdbcUsername = DBCredentials.getDbUser();
    private static final String jdbcPassword = DBCredentials.getDbPass();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();

        // Check if the user is logged in and is a voter
        if (session == null || session.getAttribute("username") == null || !"voter".equals(session.getAttribute("role"))) {
            response.sendRedirect("accessDenied.jsp");
            return;
        }

        List<VotingPeriod> activeVotingPeriods = new ArrayList<>();
        String sql = "SELECT * FROM votingperiod WHERE is_active = 1";  // Make sure the table name is correct

        try (Connection connection = DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet resultSet = statement.executeQuery()) {

            while (resultSet.next()) {
                int id = resultSet.getInt("id");
                String startTime = resultSet.getString("start_time");
                String endTime = resultSet.getString("end_time");
                boolean isActive = resultSet.getInt("is_active") == 1;

                VotingPeriod votingPeriod = new VotingPeriod(id, startTime, endTime, isActive);
                activeVotingPeriods.add(votingPeriod);
            }
            request.setAttribute("activeVotingPeriods", activeVotingPeriods);
            request.getRequestDispatcher("vote.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        }
    }
}
