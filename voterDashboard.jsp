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
        if (!"voter".equals(session.getAttribute("role"))) { // Check if the user is a voter
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
        .disclaimer {
            background-color: #f9f9f9;
            border: 1px solid #ccc;
            border-radius: 5px;
            padding: 20px;
            margin: 20px 0;
        }

        .disclaimer h2 {
            color: #d9534f; /* Bootstrap danger color for emphasis */
        }

        .disclaimer ul {
            list-style-type: disc;
            margin-left: 20px;
        }

        .apply-button {
            background-color: #5cb85c; /* Bootstrap success color */
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
            transition: background-color 0.3s ease;
        }

        .apply-button:hover {
            background-color: #4cae4c; /* Darker shade for hover effect */
        }
    .welcome-message {
        padding: 20px;
        background-color: #f0f8ff;
        border-radius: 8px;
        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        margin: 20px 0;
        text-align: center;
    }

    .welcome-message h1 {
        font-size: 2em;
        color: #333;
    }

    .welcome-message p {
        font-size: 1.2em;
        color: #555;
        margin: 10px 0;
    }

    .divider {
        border: none;
        height: 1px;
        background-color: #ccc;
        margin: 20px 0;
    }

    .features h2 {
        color: #0056b3;
        margin-top: 20px;
    }

    .features ul {
        list-style-type: square;
        margin-left: 20px;
        text-align: left;
    }

    .features li {
        font-size: 1em;
        color: #333;
        margin-bottom: 8px;
    }

    .cta {
        font-weight: bold;
        font-size: 1.2em;
        color: #007bff;
        margin-top: 20px;
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
        <h2>Pollify Voter</h2>
        <ul>
            <li><a href="findActivePolls"><i class="fas fa-check-circle"></i> Vote</a></li>
            <li><a href="CandidateList.jsp"><i class="fas fa-list"></i> Candidate List</a></li>
            <li><a href="Results.jsp"><i class="fas fa-chart-bar"></i> Result</a></li>
            <li><a href="viewManifesto.jsp"><i class="fas fa-book"></i> Manifesto</a></li>
            <li><a href="applyCandidate.jsp"><i class="fas fa-user-plus"></i> Apply for Candidate</a></li>
        </ul>
    </div>

    <!-- Content Area -->
    <div class="content">
        <div id="content-area">
            <div class="welcome-message">
                <h1>Welcome to Pollify!</h1>
                <p>
                    Pollify is your trusted platform for participating in transparent and fair elections. 
                    As a valued voter, you can explore candidate manifestos, cast your vote, and view results 
                    with ease.
                </p>
                <hr class="divider">
                <div class="features">
                    <h2>What You Can Do:</h2>
                    <ul>
                        <li><strong>Vote</strong> in ongoing elections and make your voice heard.</li>
                        <li><strong>Review Candidates</strong> and understand their vision through detailed manifestos.</li>
                        <li><strong>Track Results</strong> as they are updated in real-time post-election.</li>
                    </ul>
                </div>
                <p class="cta">Explore Pollify and make a difference in your community today!</p>
            </div>
        </div>
    </div>
</div>

</body>
</html>