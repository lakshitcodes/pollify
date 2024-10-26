<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="javax.servlet.http.HttpSession" %>
<%
    if (session != null && session.getAttribute("username") != null) {
        if(session.getAttribute("role").equals("admin")) {
            response.sendRedirect("adminDashboard.jsp"); // Redirect to admin dashboard if admin
        } else if(session.getAttribute("role").equals("candidate")) {
            response.sendRedirect("candidateDashboard.jsp"); // Redirect to candidate dashboard if candidate
        } else if(session.getAttribute("role").equals("voter")) {
            response.sendRedirect("voterDashboard.jsp"); // Redirect to voter dashboard if voter
        }
        return; // Stop further processing
    }
%>
<html>
<head>
    <title>Login - Pollify</title>
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
    <h2>Login to Pollify</h2>

    <% String errorMessage = (String) request.getAttribute("errorMessage"); %>
    <% if (errorMessage != null) { %>
        <div class="error-message"><%= errorMessage %></div>
    <% } %>
    

    <form action="login" method="post">
        Username: <input type="text" name="username" required /><br>
        Password: <input type="password" name="password" required /><br>
        <input type="submit" value="Login" />
    </form>

    <div class="link">
        <a href="register.jsp">Register</a>
    </div>
</div>

</body>
</html>
