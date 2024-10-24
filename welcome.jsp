<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.HttpSession" %>
<!DOCTYPE html>
<html>
<head>
    <title>Welcome</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            text-align: center;
            margin-top: 50px;
        }
    </style>
</head>
<body>
    <h1>Welcome to Pollify!</h1>

    <%
        // Get the user email from the session
        HttpSession session = request.getSession(false);
        if (session != null) {
            String userEmail = (String) session.getAttribute("userEmail");
            if (userEmail != null) {
    %>
                <p>Hello, <%= userEmail %>!</p>
                <p>You are successfully logged in.</p>
                <a href="logout.jsp">Logout</a>
    <%
            } else {
    %>
                <p>You are not logged in. Please <a href="login.jsp">login</a>.</p>
    <%
            }
        } else {
    %>
            <p>You are not logged in. Please <a href="login.jsp">login</a>.</p>
    <%
        }
    %>
</body>
</html>
