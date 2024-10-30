package com.pollify;

import com.pollify.DBCredentials;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
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

        // Check if the user is logged in and is admin
        if (session == null || session.getAttribute("username") == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect("accessDenied.jsp");
            return;
        }

        String sql = "SELECT candidate_id, COUNT(*) AS vote_count FROM Votes GROUP BY candidate_id ORDER BY vote_count DESC";
        
        try (Connection connection = DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet resultSet = statement.executeQuery()) {

            // Prepare data to send to JSP
            StringBuilder resultTable = new StringBuilder("<table border='1'><tr><th>Candidate ID</th><th>Vote Count</th></tr>");
            while (resultSet.next()) {
                int candidateId = resultSet.getInt("candidate_id");
                int voteCount = resultSet.getInt("vote_count");
                resultTable.append("<tr><td>").append(candidateId).append("</td><td>").append(voteCount).append("</td></tr>");
            }
            resultTable.append("</table>");
            
            request.setAttribute("resultTable", resultTable.toString());
            request.getRequestDispatcher("viewResults.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        }
    }
}

