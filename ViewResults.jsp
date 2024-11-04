<%@ page import="java.util.List" %>
<%@ page import="com.pollify.Result" %>
<%@ page import="com.pollify.VotingPeriod" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.HttpSession" %>
<%@ page import="java.net.URLDecoder" %>

<%
    String status = request.getParameter("status");
    if (status != null) {
        status = URLDecoder.decode(status, "UTF-8");
%>
<script>
    alert("<%= status %>");
    // Remove the status parameter from the URL
    const url = new URL(window.location);
    url.searchParams.delete('status'); // Remove the 'status' parameter
    window.history.replaceState({}, document.title, url);
</script>
<%
    }
%>
<%
   if (session != null && session.getAttribute("username") != null) {
        if ("admin".equals(session.getAttribute("role"))) { // Check if the user is a voter
             response.sendRedirect("accessDenied.jsp"); // Redirect if the role is not voter
            return; // Stop further processing
        }
    } else {
        response.sendRedirect("login.jsp"); // Optional: Redirect to login if session is null
        return; // Stop further processing
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Pollify - Interactive Sidebar</title>
    <link rel="stylesheet" href="css/user_page.css">
    <link rel="stylesheet" href="css/navbar.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet"/>
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
%>

<nav>
    <div class="logo">Pollify</div>
    <div class="menu">
        <% if(username==null){ %>
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
        <% if ("voter".equals(session.getAttribute("role"))) { %>
        <h2>Pollify Voter</h2>
        <ul>
            <li><a href="findActivePolls"><i class="fas fa-check-circle"></i> Vote</a></li>
            <li><a href="viewCandidate"><i class="fas fa-list"></i> Candidate List</a></li>
            <li><a href="#" class="active"><i class="fas fa-chart-bar"></i> Result</a></li>
            <li><a href="viewManifesto.jsp"><i class="fas fa-book"></i> Manifesto</a></li>
            <li><a href="applyCandidate.jsp"><i class="fas fa-user-plus"></i> Apply for Candidate</a></li>
        </ul>
        <% } %>
        <% if ("candidate".equals(session.getAttribute("role"))) { %>
            <h2>Candidate</h2>
        <ul>
            <li><a href="findActivePolls"><i class="fas fa-check-circle"></i>Vote</a></li>
            <li><a href="#"><i class="fa-solid fa-person-booth"></i>Register for Voting Period</a></li>
            <li><a href="viewCandidate"><i class="fas fa-list"></i> Candidate List</a></li>
            <li><a href="#" class="active"><i class="fas fa-chart-bar"></i> Result</a></li>
            <li><a href="candidateManifesto"><i class="fas fa-book"></i> Manifesto</a></li>
        </ul>
        <% } %>
    </div>

    <!-- Content Area -->
    <div class="content">
        <h2>Declare Pending Results</h2>

    <%
    // Retrieve the list of candidate applications from the request
    List<VotingPeriod> votingPeriods = (List<VotingPeriod>) session.getAttribute("votingPeriods");
    if (votingPeriods != null && !votingPeriods.isEmpty()) {
        for (VotingPeriod vp : votingPeriods) {
%>
        <div class="candidate-card">
            <div class="candidate-info">
                <div>
                    <p class="candidate-name"> 🗳️ Voting Period Id : <%= vp.getId() %></p> <!-- Use getUsername() method -->
                    <p class="candidate-description">Voting Period from <%= vp.getStartTime() %> to <%= vp.getEndTime() %></p> 
                </div>
            </div>
            <div class="action-buttons">
                <button class="approve-btn" onclick="approveCandidate('<%= vp.getId()%>')">Check Result</button>
            </div>
        </div>
<%
        }
    } else {
%>
    <div>
        <p>No Results Found.</p>
    </div>
<%
    }
%>


    </div>
    
</div>
<script>
    function approveCandidate(pollId) {
        // Redirect to the approve servlet with the username and email as query parameters
        window.location.href = 'checkResult?pollId=' + encodeURIComponent(pollId) ;
    }
</script>

</body>
</html>