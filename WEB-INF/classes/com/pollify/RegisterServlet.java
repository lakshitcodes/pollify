package com.pollify;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class RegisterServlet extends HttpServlet {
    // No need for DB connection details for now
    // private static final String DB_URL = "jdbc:mysql://localhost:3306/pollify"; 
    // private static final String DB_USER = "root"; 
    // private static final String DB_PASS = "30062004";

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        // Print username and password to the console
        System.out.println("Username: " + username);
        System.out.println("Password: " + password);

        // Provide a response to the client
        response.setContentType("text/html");
        response.getWriter().println("<html><body>");
        response.getWriter().println("<h2>Registration Data Received!</h2>");
        response.getWriter().println("<p>Username: " + username + "</p>");
        response.getWriter().println("<p>Password: " + password + "</p>");
        response.getWriter().println("</body></html>");
    }
}
