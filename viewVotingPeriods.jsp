<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.pollify.VotingPeriod" %>
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
    <title>View Voting Periods</title>
    <link rel="stylesheet" href="css/user_page.css">
    <link rel="stylesheet" href="css/navbar.css">
    <link
    href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css"
    rel="stylesheet"
    />
    <style>
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        th, td {
            padding: 10px;
            text-align: left;
            border: 1px solid #ddd;
        }
        th {
            background-color: #f2f2f2;
        }
    </style>
</head>
<body>

    <%
        String username = (session != null) ? (String) session.getAttribute("username") : null; // Get the username if session exists
    %>

    <nav>
        <div class="logo">Pollify</div>
        <div class="menu">
            <% if(username == null) { %>
                <a href="home.jsp">Home</a>
                <a href="register.jsp">Register</a>
                <a href="login.jsp">Login</a>
            <% } else { %>
                <a>Welcome, <%= username %>!</a>
                <a href="logout.jsp">Logout</a> <!-- Link to logout servlet -->
            <% } %>
        </div>
    </nav>

    <div class="container">
        <div class="sidebar">
            <h2>Admin</h2>
            <ul>
                <li><a href="adminDashboard.jsp">
                    <i class="fas fa-calendar"></i> Set Voting Period
                </a></li>
                <li><a href="pendingResult" onclick="loadContent('declareResult')">
                    <i class="fas fa-trophy"></i> Declare Result
                </a></li>
                <li><a href="approveCandidate" onclick="loadContent('approveCandidate')">
                    <i class="fas fa-thumbs-up"></i> Approve Candidate
                </a></li>
                <li><a href="#" class="active">
                    <i class="fas fa-history"></i> View Voting Periods
                </a></li>
                <li><a href="sendNotification.jsp">
                    <i class="fas fa-bell"></i> Send Notification
                </a></li>
            </ul>
        </div>

        <div class="content">
            <h1>Voting Periods</h1>
            <table>
                <tr>
                    <th>ID</th>
                    <th>Start Time</th>
                    <th>End Time</th>
                    <th>Active</th>
                </tr>
                <%
                    // Retrieve the list of voting periods from the request
                    List<VotingPeriod> votingPeriods = (List<VotingPeriod>) request.getAttribute("votingPeriods");
                    if (votingPeriods != null && !votingPeriods.isEmpty()) {
                        for (VotingPeriod period : votingPeriods) {
                %>
                <tr>
                    <td><%= period.getId() %></td>
                    <td><%= period.getStartTime() %></td>
                    <td><%= period.getEndTime() %></td>
                    <td><%= period.isActive() ? "Yes" : "No" %></td>
                </tr>
                <%
                        }
                    } else {
                %>
                <tr>
                    <td colspan="4">No voting periods found.</td>
                </tr>
                <%
                    }
                %>
            </table>
        </div>
    </div>

</body>
</html>
