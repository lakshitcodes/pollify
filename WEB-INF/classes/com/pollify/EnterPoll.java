package com.pollify;

import com.pollify.DBCredentials;
import com.pollify.Candidate;
import com.pollify.VotingPeriod;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class EnterPoll extends HttpServlet {
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

        // Get pollId from the request
        String pollId = request.getParameter("pollId");
        if (pollId == null || pollId.isEmpty()) {
            session.setAttribute("errorMessage", "Poll ID is missing.");
            response.sendRedirect("error.jsp");
            return;
        }

        VotingPeriod votingPeriod = null;
        List<Candidate> candidates = new ArrayList<>();
        String username = (String) session.getAttribute("username");
        String email = (String) session.getAttribute("email");
        try (Connection connection = DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword)) {
            int userId=-1;
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

            String checkVotedQuery = "SELECT * FROM Votes WHERE user_id = ? AND voting_period_id = ?";
            try (PreparedStatement statement = connection.prepareStatement(checkVotedQuery)) {
                statement.setInt(1, userId);
                statement.setInt(2, Integer.parseInt(pollId));
                try (ResultSet resultSet = statement.executeQuery()) {
                    if (resultSet.next()) {
                        session.setAttribute("errorMessage", "You have already voted in this poll.");
                        response.sendRedirect("error.jsp");
                        return;
                    }
                }
            }


            // Fetch the voting period
            String votingPeriodQuery = "SELECT * FROM VotingPeriod WHERE id = ?";
            try (PreparedStatement statement = connection.prepareStatement(votingPeriodQuery)) {
                statement.setInt(1, Integer.parseInt(pollId));
                try (ResultSet resultSet = statement.executeQuery()) {
                    if (resultSet.next()) {
                        int id = resultSet.getInt("id");
                        String startTime = resultSet.getString("start_time");
                        String endTime = resultSet.getString("end_time");
                        boolean isActive = resultSet.getInt("is_active") == 1;
                        votingPeriod = new VotingPeriod(id, startTime, endTime, isActive);
                    } else {
                        session.setAttribute("errorMessage", "No active voting period found.");
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

            // Retrieve candidates specific to this poll
            String candidateQuery = "SELECT * FROM users WHERE role = 'candidate'";
            try (PreparedStatement statement = connection.prepareStatement(candidateQuery)) {
                try (ResultSet resultSet = statement.executeQuery()) {
                    while (resultSet.next()) {
                        int id = resultSet.getInt("id");
                        String name = resultSet.getString("username");
                        candidates.add(new Candidate(id, name));
                    }
                }
            }

            // Set attributes for the request and forward to JSP
            request.setAttribute("votingPeriod", votingPeriod);
            session.setAttribute("votingPeriod", votingPeriod);
            request.setAttribute("candidates", candidates);
            request.getRequestDispatcher("EnterPoll.jsp").forward(request, response);

            } catch (SQLException e) {
                e.printStackTrace();
                session.setAttribute("errorMessage", e.getMessage());
                response.sendRedirect("error.jsp");
        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "Invalid poll ID format.");
            response.sendRedirect("error.jsp");
        }
    }
}
