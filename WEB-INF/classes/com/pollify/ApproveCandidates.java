package com.pollify;

import com.pollify.DBCredentials;
import com.pollify.CandidateApplication;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

// Create a JavaBean class to store candidate application data


public class ApproveCandidates extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final String jdbcURL = DBCredentials.getDbUrl();
    private static final String jdbcUsername = DBCredentials.getDbUser();
    private static final String jdbcPassword = DBCredentials.getDbPass();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<CandidateApplication> candidateApplications = new ArrayList<>();

        // SQL query to retrieve candidate applications
        String query = "SELECT id, username, email, application_date FROM candidate_applications";

        try (Connection connection = DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);
             PreparedStatement preparedStatement = connection.prepareStatement(query);
             ResultSet resultSet = preparedStatement.executeQuery()) {

            while (resultSet.next()) {
                CandidateApplication application = new CandidateApplication();
                application.setId(resultSet.getInt("id"));
                application.setUsername(resultSet.getString("username"));
                application.setEmail(resultSet.getString("email"));
                application.setApplicationDate(resultSet.getTimestamp("application_date"));

                candidateApplications.add(application);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw new ServletException("Database access error occurred", e);
        }

        // Set the list of candidate applications as a request attribute and forward to JSP
        request.setAttribute("candidateApplications", candidateApplications);
        request.getRequestDispatcher("approveCandidates.jsp").forward(request, response);
    }
}
