package com.pollify;

import com.pollify.DBCredentials;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;


public class DeleteManifestoServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private static final String jdbcURL = DBCredentials.getDbUrl();
    private static final String jdbcUsername = DBCredentials.getDbUser();
    private static final String jdbcPassword = DBCredentials.getDbPass();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String username = (String) session.getAttribute("username");

        String sql = "UPDATE Users SET manifesto = NULL WHERE username = ?";

        try (Connection connection = DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setString(1, username);
            statement.executeUpdate();

            session.setAttribute("manifestoLink", null); // Clear the session attribute
            response.sendRedirect("manifesto.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Error deleting manifesto.");
            response.sendRedirect("error.jsp"); // Redirect to error page
        }
    }
}
