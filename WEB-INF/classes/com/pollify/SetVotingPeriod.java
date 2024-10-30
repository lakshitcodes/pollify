package com.pollify;

import com.pollify.SendMail;
import com.pollify.DBCredentials;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;


public class SetVotingPeriod extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Database connection variables
    private static final String jdbcURL = DBCredentials.getDbUrl();
    private static final String jdbcUsername = DBCredentials.getDbUser();
    private static final String jdbcPassword = DBCredentials.getDbPass();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        
        // Check if the user is logged in and is admin
        if (session == null || session.getAttribute("username") == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect("accessDenied.jsp");
            return;
        }
    
        // Get form parameters and replace 'T' with a space
        String startTime = request.getParameter("start_time").replace("T", " ");
        String endTime = request.getParameter("end_time").replace("T", " ");
    
        // Validate input
        if (startTime == null || endTime == null) {
            response.sendRedirect("error.jsp?message=Start or End time cannot be null");
            return;
        }
    
        try {
            // Parse the times to check their format
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm");
            dateFormat.setLenient(false);
            Date startDate = dateFormat.parse(startTime);
            Date endDate = dateFormat.parse(endTime);
    
            if (startDate.after(endDate)) {
                response.sendRedirect("error.jsp?message=Start time must be before End time");
                return;
            }
    
            String sql = "INSERT INTO votingperiod (start_time, end_time, is_active) VALUES (?, ?, ?)";
    
            // Establishing a connection using try-with-resources to ensure proper closing
            try (Connection connection = DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);
                 PreparedStatement statement = connection.prepareStatement(sql)) {
                
                // Set the parameters
                statement.setString(1, new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(startDate));
                statement.setString(2, new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(endDate));
                statement.setInt(3, 0); // Set is_active to 1 (active)
    
                // Execute the insert
                statement.executeUpdate();
                
                // Redirect to the admin dashboard with success message
                session.setAttribute("successMessage", "Voting period set successfully.");
                response.sendRedirect("adminDashboard.jsp?success=true");
            }
        } catch (ParseException e) {
            response.sendRedirect("error.jsp?message=Invalid date format. Use yyyy-MM-dd HH:mm");
        } catch (Exception e) {
            e.printStackTrace(); // Consider logging this to a file in production
            // Handle other exceptions
            response.sendRedirect("error.jsp");
        }
    }
    
}
