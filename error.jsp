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
    <p><%= request.getParameter("message") != null ? request.getParameter("message") : "Something went wrong!" %></p>
    <a href="adminDashboard.jsp">Go Back to Home</a>
</body>
</html>
