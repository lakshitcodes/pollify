<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="javax.servlet.http.HttpSession" %>
<html>
<head>
    <title>Main - Pollify</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>

<% 
    // Get the session
    HttpSession session = request.getSession(false);

    // Check if session exists and retrieve username and role
    String username = (session != null) ? (String) session.getAttribute("username") : null;
    String role = (session != null) ? (String) session.getAttribute("role") : null;
%>

<nav>
    <div class="logo">Pollify</div>
    <div class="menu">
        <a href="home.jsp">Home</a>
        <a href="main.jsp">Main</a>
        <a href="logout.jsp">Logout</a>
    </div>
</nav>

<div class="container">
    <h2>Welcome to Pollify</h2>

    <% if (username != null && role != null) { %>
        <p>Welcome, <strong><%= username %></strong>!</p>
        <p>Your role: <strong><%= role %></strong></p>
    <% } else { %>
        <p>You are not logged in. Please <a href="login.jsp">Login</a>.</p>
    <% } %>

</div>

</body>
</html>
