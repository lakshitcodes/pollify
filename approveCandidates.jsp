<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.pollify.CandidateApplication" %>
<%@ page import="javax.servlet.http.HttpSession" %>
<%
    if (session != null && session.getAttribute("username") != null) {
        if (!"admin".equals(session.getAttribute("role"))) { // Check if the user is not admin
            response.sendRedirect("accessDenied.jsp"); // Redirect if the role is not admin
            return; // Stop further processing
        }
    } else {
        response.sendRedirect("login.jsp"); // Redirect to login if session is null
        return; // Stop further processing
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Approve Candidates</title>
    <link rel="stylesheet" href="css/navbar.css">
    <link rel="stylesheet" href="css/user_page.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        /* Your CSS for card design here */
        :root {
            --card-background: rgba(255, 255, 255, 0.7);
            --primary-color: #4a90e2;
            --secondary-color: #ff5f7e;
            --text-color: #333;
            --shadow-color: rgba(0, 0, 0, 0.2);
            --border-color: rgba(255, 255, 255, 0.4);
            --transition-speed: 0.3s;
            --blur: 10px;
        }


        .container {
            width: 100%;
            backdrop-filter: blur(var(--blur));
            text-align: center;
            color: var(--text-color);
        }

        h2 {
            font-size: 26px;
            font-weight: 600;
            color: #333;
            margin-bottom: 20px;
            opacity: 0.9;
        }

        .candidate-card {
            background: var(--card-background);
            padding: 20px;
            margin: 15px 0;
            border-radius: 16px;
            box-shadow: 0 8px 16px var(--shadow-color);
            border: 1px solid var(--border-color);
            display: flex;
            justify-content: space-between;
            align-items: center;
            transition: transform var(--transition-speed), box-shadow var(--transition-speed);
            backdrop-filter: blur(10px);
        }

        .candidate-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 12px 20px rgba(0, 0, 0, 0.2);
        }

        .candidate-info {
            display: flex;
            align-items: center;
        }

        .candidate-photo {
            width: 70px;
            height: 70px;
            border-radius: 50%;
            background-color: #ddd;
            margin-right: 15px;
            flex-shrink: 0;
            background-image: linear-gradient(135deg, #6b73ff, #000dff);
        }

        .candidate-name {
            font-size: 20px;
            font-weight: 600;
            color: var(--text-color);
            margin: 0;
        }

        .candidate-description {
            font-size: 14px;
            color: #555;
            margin-top: 5px;
            opacity: 0.8;
        }

        .action-buttons {
            display: flex;
            gap: 10px;
        }

        .action-buttons button {
            padding: 10px 20px;
            font-size: 14px;
            font-weight: 500;
            border-radius: 8px;
            border: none;
            cursor: pointer;
            transition: background-color var(--transition-speed), transform var(--transition-speed);
            color: #fff;
        }

        .approve-btn {
            background: linear-gradient(135deg, var(--primary-color), #007aff);
            box-shadow: 0 4px 8px rgba(74, 144, 226, 0.4);
        }

        .reject-btn {
            background: linear-gradient(135deg, var(--secondary-color), #ff4081);
            box-shadow: 0 4px 8px rgba(255, 95, 126, 0.4);
        }

        .approve-btn:hover, .reject-btn:hover {
            transform: translateY(-3px);
            opacity: 0.9;
            box-shadow: 0 6px 12px rgba(0, 0, 0, 0.15);
        }
    </style>
</head>
<body>
    <%
    String username = (session != null) ? (String) session.getAttribute("username") : null; // Get the username if session exists
    String successMessage = (String) session.getAttribute("successMessage");
    String errorMessage = (String) session.getAttribute("errorMessage");

    // Clear the messages after displaying
    if (successMessage != null) {
        session.removeAttribute("successMessage");
    }
    if (errorMessage != null) {
        session.removeAttribute("errorMessage");
    }
%>

<nav>
    <div class="logo">Pollify</div>
    <div class="menu">
        <% if(username == null) { %>
            <a href="home.jsp">Home</a>
            <a href="register.jsp">Register</a>
            <a href="login.jsp">Login</a>
        <% } %>
        
        <% if (username != null) { %>
            <a>Welcome, <%= username %>!</a>
            <a href="logout.jsp">Logout</a> <!-- Link to logout servlet -->
        <% } %>
    </div>
</nav>
<div class="container">
    <div class="sidebar">
        <h2>Admin</h2>
        <ul>
            <li><a href="adminDashboard.jsp" >
                <i class="fas fa-calendar"></i> Set Voting Period
            </a></li>
            <li><a href="declareResult" onclick="loadContent('declareResult')">
                <i class="fas fa-trophy"></i> Declare Result
            </a></li>
            <li><a href="#" class="active"">
                <i class="fas fa-thumbs-up"></i> Approve Candidate
            </a></li>
            <li><a href="viewVotingPeriods">
                <i class="fas fa-history"></i> View Voting Periods
            </a></li>
            <li><a href="sendNotification.jsp">
                <i class="fas fa-bell"></i> Send Notification
            </a></li>
        </ul>
    </div>
    <div class="content">
        <div id="content-area">
            <!-- Display success or error messages -->
            <div>
                <%
                // Display success message
                if (successMessage != null) {
                    out.println("<div style='color: green; font-weight: bold;'>" + successMessage + "</div>");
                }
                // Display error message
                if (errorMessage != null) {
                    out.println("<div style='color: red; font-weight: bold;'>Error: " + errorMessage + "</div>");
                }
                %>
            </div>
        </div>

    <h2>Approve Candidates</h2>

    <%
    // Retrieve the list of candidate applications from the request
    List<CandidateApplication> applications = (List<CandidateApplication>) request.getAttribute("candidateApplications");
    if (applications != null && !applications.isEmpty()) {
        for (CandidateApplication app : applications) { // Changed 'application' to 'app'
%>
        <div class="candidate-card">
            <div class="candidate-info">
                <div>
                    <p class="candidate-name"><%= app.getUsername() %></p> <!-- Use getUsername() method -->
                    <p class="candidate-description"><%= app.getEmail() %></p> <!-- Use getEmail() method -->
                    <p class="candidate-description"><%= app.getApplicationDate() %></p> <!-- Use getApplicationDate() method -->
                </div>
            </div>
            <div class="action-buttons">
                <button class="approve-btn" onclick="approveCandidate('<%= app.getUsername() %>', '<%= app.getEmail() %>')">Approve</button>
                <button class="reject-btn" onclick="rejectCandidate('<%= app.getUsername() %>', '<%= app.getEmail() %>')">Reject</button>
            </div>
        </div>
<%
        }
    } else {
%>
    <div>
        <p>No Pending Requests Found.</p>
    </div>
<%
    }
%>

</div>
</div>
<script>
    function approveCandidate(username, email) {
        // Redirect to the approve servlet with the username and email as query parameters
        window.location.href = 'approved?username=' + encodeURIComponent(username) + '&email=' + encodeURIComponent(email);
    }

    function rejectCandidate(username, email) {
        // Redirect to the reject servlet with the username and email as query parameters
        window.location.href = 'rejected?username=' + encodeURIComponent(username) + '&email=' + encodeURIComponent(email);
    }
</script>

</body>
</html>
