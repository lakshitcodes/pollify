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


public class UploadManifestoServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private static final String jdbcURL = DBCredentials.getDbUrl();
    private static final String jdbcUsername = DBCredentials.getDbUser();
    private static final String jdbcPassword = DBCredentials.getDbPass();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String username = (String) session.getAttribute("username");
        String manifestoLink = request.getParameter("gdriveLink");

        String sql = "UPDATE Users SET manifesto = ? WHERE username = ?";

        try (Connection connection = DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);
             PreparedStatement statement = connection.prepareStatement(sql)) {

            manifestoLink = convertToPreviewLink(manifestoLink); // Convert to preview link
            statement.setString(1, manifestoLink);
            statement.setString(2, username);
            statement.executeUpdate();
            session.setAttribute("manifestoLink", manifestoLink); // Update session
            response.sendRedirect("manifesto.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Error uploading manifesto.");
            response.sendRedirect("error.jsp"); // Redirect to error page
        }
    }
    private String convertToPreviewLink(String link) {
        if (link != null && link.contains("/d/") && link.contains("/view")) {
            String fileId = link.substring(link.indexOf("/d/") + 3, link.indexOf("/view"));
            return "https://drive.google.com/file/d/" + fileId + "/preview";
        }
        return link; // Return original if it doesn't match expected format
    }
}
