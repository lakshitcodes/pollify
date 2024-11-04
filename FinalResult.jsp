<%@ page contentType="text/html; charset=UTF-8" language="java" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.pollify.Result" %>
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
            <li><a href="#" class="active">
                <i class="fas fa-trophy"></i> Declare Result
            </a></li>
            <li><a href="approveCandidate">
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