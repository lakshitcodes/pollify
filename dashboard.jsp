<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="javax.servlet.http.HttpSession" %>
<html>
<head>
    <title>Main Page - Pollify</title>
    <link rel="stylesheet" href="css/style.css">
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
        <h2>Welcome to Pollify</h2>

        <% 
            // Check if session exists and retrieve username and role
            String username = (session != null) ? (String) session.getAttribute("username") : null;
            String role = (session != null) ? (String) session.getAttribute("role") : null;

            if (username != null && role != null) {
        %>
            <p>Hello, <%= username %>! Your role is: <%= role %>.</p>
        <% 
            } else {
        %>
            <p>Please <a href="login.jsp">log in</a> to access this page.</p>
        <% 
            }
        %>
    </div>
</body>
</html>
