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

public class PendingResult extends HttpServlet {
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
        List<VotingPeriod> votingPeriods = new ArrayList<>();
        // Getting the candidate ID from the request
       String findResultQuery = "SELECT vp.* FROM VotingPeriod vp LEFT JOIN Results r ON vp.id = r.voting_period_id WHERE vp.end_time < NOW() AND r.voting_period_id IS NULL";
        try (Connection connection = DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword)) {
            try (PreparedStatement statement = connection.prepareStatement(findResultQuery)) {
                try (ResultSet resultSet = statement.executeQuery()) {
                    while(resultSet.next()) {
                        VotingPeriod votingPeriod = new VotingPeriod(resultSet.getInt("id"), resultSet.getString("start_time"), resultSet.getString("end_time"),false);
                        votingPeriods.add(votingPeriod);
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Database error: " + e.getMessage());
            response.sendRedirect("error.jsp");
        }
        request.setAttribute("votingPeriods", votingPeriods);
        request.getRequestDispatcher("PendingResult.jsp").forward(request, response);
    }
}
