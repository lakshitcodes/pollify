<%@ page import="java.util.List" %>
<%@ page import="com.pollify.Result" %>
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
        body {
    margin: 0;
    padding: 0;
    background-color: #ffffff; /* Change background to white */
    display: flex;
    justify-content: center;
    /* align-items: center; */
    height: 100vh;
    font-family: 'Poppins', sans-serif;
    color: #333; /* Darker text color for contrast */
    overflow: hidden;
}

.voting-results-container {
    background: linear-gradient(135deg, #1e3a8a, #3b82f6); /* Blue gradient for card */
    padding: 30px;
    border-radius: 25px;
    box-shadow: 0 10px 40px rgba(30, 58, 138, 0.3);
    backdrop-filter: blur(10px);
    animation: slideIn 1s ease-out;
    position: relative;
    color: #fff; /* White text inside the card for contrast */
    overflow: hidden;
}


.header h2, .winner-card h3, .voting-details p {
    margin-bottom: 10px;
}

.winner-card {
    background: rgba(255, 255, 255, 0.25);
    padding: 20px;
    border-radius: 15px;
    margin: 25px 0;
    animation: pulse 1.5s infinite alternate; /* Pulsing effect */
}

.winner-name .animated-text {
    color: #ffdd00;
    animation: textGlow 1.5s infinite alternate;
}

.highlight {
    font-size: 1.8em;
    font-weight: bold;
}

.progress-bar {
    width: 100%;
    background: rgba(255, 255, 255, 0.3);
    border-radius: 15px;
    overflow: hidden;
    margin: 15px 0;
    height: 20px;
}

.fill {
    height: 100%;
    width: 0;
    background: linear-gradient(90deg, #60a5fa, #2563eb);
    animation: fillBar 2s forwards;
}

.confetti {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    pointer-events: none;
    animation: confettiFall 5s linear infinite;
    background-image: url('data:image/svg+xml;base64,...'); /* Replace with actual SVG or image */
}

@keyframes fadeIn {
    from { opacity: 0; }
    to { opacity: 1; }
}

@keyframes textGlow {
    from { text-shadow: 0 0 5px #ffdd00; }
    to { text-shadow: 0 0 20px #ffdd00; }
}

@keyframes pulse {
    from { transform: scale(1); }
    to { transform: scale(1.05); }
}

@keyframes fillBar {
    from { width: 0%; }
    to { width: 75%; }
}

@keyframes confettiFall {
    0% { background-position: 0 0; }
    100% { background-position: 0 100vh; }
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
            <li><a href="#"  class="active"><i class="fas fa-chart-bar"></i> Result</a></li>
            <li><a href="candidateManifesto"><i class="fas fa-book"></i> Manifesto</a></li>
        </ul>
        <% } %>
    </div>

    <!-- Content Area -->
    <div class="content">
        <%
        Result pollResult = (Result) session.getAttribute("pollResult");
    %>
    
    <div class="voting-results-container">
        <div class="confetti"></div>
        <div class="header">
            <h2>Voting Period ID: <span><%= pollResult.getVotingPeriodId() %></5></span></h2>
            <p class="status">Status: <span>Results Declared</span></p>
        </div>
        <div class="winner-card">
            <h3 class="winner-name">🎉 Winner: <span class="animated-text"><%=pollResult.getWinnerUsername() %></span> 🎉</h3>
            <p>Total Votes: <span class="highlight"><%=pollResult.getTotalVotes()%></span></p>
            <div class="progress-bar">
                <div class="fill"></div>
            </div>
            <p>Winner Percentage: <span class="percentage"><%=pollResult.getWinnerPercentage() %></span></p>
        </div>
        <div class="voting-details">
            <p>Turnout Ratio: <span class="turnout"><%= pollResult.getTurnoutRatio() %></span></p>
            <p>Start Time: <span><%= pollResult.getStartTime() %></span></p>
            <p>End Time: <span><%= pollResult.getEndTime() %></span></p>
        </div>
    </div>
    </div>
    
</div>


<script>
    document.addEventListener("DOMContentLoaded", function () {
    const confettiContainer = document.querySelector('.confetti');
    let confettiCount = 150;


    for (let i = 0; i < confettiCount; i++) {
        let confetti = document.createElement('div');
        confetti.classList.add('confetti-piece');
        confetti.style.left = Math.random() * 100 + 'vw';
        confetti.style.animationDelay = Math.random() * 2 + 's';
        confettiContainer.appendChild(confetti);
    }
});
</script>
</body>
</html>