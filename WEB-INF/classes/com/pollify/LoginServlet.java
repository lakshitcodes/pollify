package com.pollify;
import com.pollify.SendMail;
import com.pollify.DBCredentials;


import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.*;


public class LoginServlet extends HttpServlet {
    // Database connection details
    private static final String dbUrl = DBCredentials.getDbUrl();
    private static final String dbUser = DBCredentials.getDbUser();
    private static final String dbPassword = DBCredentials.getDbPass();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            // Step 1: Establish a connection to the database
            conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);

            // Step 2: Check if the user is registered and fetch their status
            String query = "SELECT password, role, status, otp_expiry FROM users WHERE username = ?";
            ps = conn.prepareStatement(query);
            ps.setString(1, username);
            rs = ps.executeQuery();

            if (rs.next()) {
                // User exists, check if approved
                String isApproved = rs.getString("status");
                String storedPassword = rs.getString("password");
                String role = rs.getString("role");
                Timestamp otpExpiry = rs.getTimestamp("otp_expiry");

                if (isApproved.equals("pending")) {
                    // Step 3: If not approved, resend OTP and redirect to OTP page
                    // Generate new OTP and update it in the database
                    int newOtp = (int) (Math.random() * 900000) + 100000;
                    String updateOtpQuery = "UPDATE users SET otp = ?, otp_expiry = ? WHERE username = ?";
                    ps = conn.prepareStatement(updateOtpQuery);
                    ps.setInt(1, newOtp);
                    ps.setTimestamp(2, new Timestamp(System.currentTimeMillis() + 10 * 60 * 1000)); // 10-minute expiry
                    ps.setString(3, username);
                    ps.executeUpdate();

                    // Send the new OTP via email (assuming you have a method for that)
                    // EmailUtility.sendOTP(email, newOtp);

                    request.setAttribute("errorMessage", "Your account is not verified. A new OTP has been sent.");
                    request.getRequestDispatcher("OtpVerification.jsp").forward(request, response);
                    return;
                }

                // Step 4: Check if the password is correct
                if (storedPassword.equals(password)) {
                    // Password is correct, proceed with login

                    // Step 5: Create session and store user data
                    HttpSession session = request.getSession();
                    session.setAttribute("username", username);
                    session.setAttribute("role", role);

                    // Redirect to the home page or user dashboard
                    response.sendRedirect("dashboard.jsp");
                } else {
                    // Password is incorrect, show error message
                    request.setAttribute("errorMessage", "Incorrect password. Please try again.");
                    request.getRequestDispatcher("login.jsp").forward(request, response);
                }
            } else {
                // User does not exist, show error
                request.setAttribute("errorMessage", "User not found. Please register.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            e.printStackTrace(); // Log the exception
            request.setAttribute("errorMessage", "Database error: " + e.getMessage()); // Set a user-friendly message
            request.getRequestDispatcher("login.jsp").forward(request, response); // Forward to login page
            return;
        } finally {
            // Clean up database resources
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.sendRedirect("login.jsp");
    }
}
