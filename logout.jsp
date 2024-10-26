<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.HttpSession" %>

<html>
<head>
    <title>Pollify - Logged Out Successfully</title>
    <link rel="stylesheet" href="css/style.css">
    <style>

.logout{
    background-color: #4A90E2;
    color: white;
    padding: 10px;
    font-size: 16px;
    border: none;
    border-radius: 4px;
    cursor: pointer;
    transition: background-color 0.3s;
    text-decoration: none;
    display: flex;
    justify-content: center;
    width: 80%;
}

.logout:hover {
    background-color: #357ABD;
}
.container{
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
}
    </style>
</head>
<body>

<nav>
    <div class="logo">Pollify</div>
    <div class="menu">
        <a href="home.jsp">Home</a>
        <a href="register.jsp">Register</a>
        <a href="login.jsp">Login</a>
    </div>
</nav>

<div class="container">
    <%
        // Invalidate the session
        if (session != null) {
            session.invalidate();
            out.println("<h2>You have been logged out successfully.</h2>");
        } else {
            out.println("<h2>No active session found.</h2>");
        }
    %>
    <a class="logout" href="login.jsp">Login again</a>
</div>
</body>
</html>
