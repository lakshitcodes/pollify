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
    <title>Register - Pollify</title>
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
    <h2>Register to Pollify</h2>
    <form action="register" method="post">
        <label for="email">Email:</label>
        <input type="email" id="email" name="email" required />
        
        <label for="username">Username:</label>
        <input type="text" id="username" name="username" required />

        <label for="password">Password:</label>
        <input type="password" id="password" name="password" required />

        <input type="submit" value="Register" />
    </form>

    <div class="link">
        <a href="login.jsp">Already have an account? Login here</a>
    </div>
</div>

</body>
</html>
