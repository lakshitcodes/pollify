<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="javax.servlet.http.HttpSession" %>
<%
    String role = (String) session.getAttribute("role");
    String redirectPage = "login.jsp"; // Default redirect

    // Determine redirect based on role
    if ("admin".equals(role)) {
        redirectPage = "adminDashboard.jsp";
    } else if ("candidate".equals(role)) {
        redirectPage = "candidateDashboard.jsp";
    } else if ("voter".equals(role)) {
        redirectPage = "voterDashboard.jsp";
    }
%>
<html>
<head>
    <title>Access Denied</title>
    <link rel="stylesheet" href="css/style.css">
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
            <a >Welcome, <%= username %>!</a>
            <a href="logout.jsp">Logout</a> <!-- Link to logout servlet -->
        <% } %>
    </div>
</nav>
    <div class="container">
        <h2>Access Denied</h2>
        <p>You do not have permission to access this page.</p>
        <a href="<%= redirectPage %>">Go to Dashboard</a>
    </div>
</body>
</html>
