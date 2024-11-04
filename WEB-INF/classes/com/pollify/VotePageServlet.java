package com.pollify;
import com.pollify.DBCredentials;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;


public class VotePageServlet extends HttpServlet {
    private static final String jdbcURL = DBCredentials.getDbUrl();
    private static final String jdbcUsername = DBCredentials.getDbUser();
    private static final String jdbcPassword = DBCredentials.getDbPass();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        if (session == null || session.getAttribute("username") == null || !"voter".equals(session.getAttribute("role"))) {
            response.sendRedirect("accessDenied.jsp");
            return;
        }

        List<Candidate> candidates = new ArrayList<>();
        String sql = "SELECT * FROM users WHERE role = 'candidate'"; 

        try (Connection connection = DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet resultSet = statement.executeQuery()) {

            while (resultSet.next()) {
                int id = resultSet.getInt("id");
                String name = resultSet.getString("name");
                candidates.add(new Candidate(id, name));
            }

            request.setAttribute("candidates", candidates);
            request.getRequestDispatcher("castVote.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        }
    }
}
