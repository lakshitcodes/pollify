<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Error</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f2f2f2;
            text-align: center;
            padding: 50px;
        }
        h1 {
            color: red;
        }
    </style>
</head>
<body>
    <h1>An Error Occurred</h1>
    <p><%= session.getAttribute("errorMessage") != null ? session.getAttribute("errorMessage") : "Something went wrong!" %></p>
    <% if ("voter".equals(session.getAttribute("role"))) { %>
        <a href="voterDashboard.jsp" class="btn">Go to Dashboard</a> 
    <% } %>
    <% if ("candidate".equals(session.getAttribute("role"))) { %>
        <a href="candidateDashboard.jsp" class="btn">Go to Dashboard</a> 
    <% } %>
    <% if ("admin".equals(session.getAttribute("role"))) { %>
        <a href="adminDashboard.jsp" class="btn">Go to Dashboard</a>    
    <% } %>
</body>
</html>
