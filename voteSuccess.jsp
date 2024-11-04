<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Vote Success</title>
    <link rel="stylesheet" href="styles.css"> <!-- Add your CSS file if you have one -->
</head>
<body>
    <div class="container">
        <h1>Vote Successful!</h1>
        <p>Your vote has been recorded successfully.</p>

        <p>Thank you for participating in the election!</p>
        <% if ("voter".equals(session.getAttribute("role"))) { %>
            <a href="voterDashboard.jsp" class="btn">Go to Dashboard</a> 
        <% } %>
        <% if ("candidate".equals(session.getAttribute("role"))) { %>
            <a href="candidateDashboard.jsp" class="btn">Go to Dashboard</a> 
        <% } %>
        
    </div>
    
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            color: #333;
            text-align: center;
            padding: 50px;
        }
        .container {
            background-color: white;
            padding: 20px;
            border-radius: 5px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
            display: inline-block;
        }
        .btn {
            display: inline-block;
            padding: 10px 20px;
            margin: 10px;
            background-color: #007BFF;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            transition: background-color 0.3s;
        }
        .btn:hover {
            background-color: #0056b3;
        }
    </style>
</body>
</html>
