<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.HttpSession" %>

<!DOCTYPE html>
<html>
<head>
    <title>Logout</title>
</head>
<body>
    <%
        // Invalidate the session
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
            out.println("<h2>You have been logged out successfully.</h2>");
        } else {
            out.println("<h2>No active session found.</h2>");
        }
    %>
    <p><a href="login.jsp">Login again</a></p>
</body>
</html>
