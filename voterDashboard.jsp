<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.HttpSession" %>
<%
    if (session != null && session.getAttribute("username") != null) {
        if (!"voter".equals(session.getAttribute("role"))) { // Use .equals() for string comparison
            response.sendRedirect("accessDenied.jsp"); // Redirect if the role is not candidate
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
    <link
    href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css"
    rel="stylesheet"
/>
</head>
<body>
    <!-- Navbar will be loaded from the template -->
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
            <a >Welcome, <%= username %>!</a>
            <a href="logout.jsp">Logout</a> <!-- Link to logout servlet -->
        <% } %>
    </div>
</nav>

    <div class="container">

        <!-- Sidebar -->
        <div class="sidebar">
            <h2>Pollify Voter</h2>
            <ul>
                <li><a href="#" onclick="loadContent('introduction')">
                    <i class="fas fa-check-circle"></i> Vote
                </a></li>
                <li><a href="#" onclick="loadContent('output')" class="active">
                    <i class="fas fa-list"></i> Candidate List
                </a></li>
                <li><a href="#" onclick="loadContent('syntax')">
                    <i class="fas fa-chart-bar"></i> Result
                </a></li>
                <li><a href="#" onclick="loadContent('manifesto')">
                    <i class="fas fa-book"></i> Manifesto
                </a></li>
                <li><a href="#" onclick="loadContent('functions')">
                    <i class="fas fa-user-plus"></i> Apply for Candidate
                </a></li>
            </ul>
        </div>
       
        <!-- Content Area -->
        <div class="content">
            <div id="content-area">
                <h1>Welcome to Pollify</h1>
                <p>Select an option from the sidebar to learn more.</p>
            </div>
        </div>
    </div>

    <script src="js/user_page.js"></script>
</body>
</html>
