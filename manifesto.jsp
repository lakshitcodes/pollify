<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.HttpSession" %>
<%
    // Check if the session exists and if the user is a candidate
    if (session != null && session.getAttribute("username") != null) {
        if (!"candidate".equals(session.getAttribute("role"))) { // Use .equals() for string comparison
            response.sendRedirect("accessDenied.jsp"); // Redirect if the role is not candidate
            return; // Stop further processing
        }
    } else {
        response.sendRedirect("login.jsp"); // Optional: Redirect to login if session is null
        return; // Stop further processing
    }

    String username = (String) session.getAttribute("username"); // Get the username
    String manifestoLink = (String) session.getAttribute("manifestoLink"); // Get the manifesto link from the session
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Pollify - Manifesto</title>
    <link rel="stylesheet" href="css/user_page.css">
    <link rel="stylesheet" href="css/navbar.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet"/>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f4f4f4;
        }
        .content {
            padding: 20px;
            background: white;
            border-radius: 5px;
            margin: 20px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
        h1 {
            color: #333;
        }
        .manifesto-area {
            margin: 20px 0;
            padding: 15px;
            background-color: #f9f9f9;
            border: 1px solid #ddd;
            border-radius: 5px;
        }
        .button-container {
            margin-top: 10px;
        }
        .button {
            background-color: #5cb85c;
            color: white;
            padding: 10px 15px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
            transition: background-color 0.3s ease;
        }
        .button:hover {
            background-color: #4cae4c;
        }
        .error-message {
            color: #d9534f; /* Bootstrap danger color */
        }
        iframe {
            width: 100%;
            height: 600px; /* Set height as per your requirement */
            border: none; /* Remove border */
            margin-top: 15px; /* Add some space above the iframe */
        }
    </style>
</head>
<body>
<nav>
    <div class="logo">Pollify</div>
    <div class="menu">
        <% if (username == null) { %>
            <a href="home.jsp">Home</a>
            <a href="register.jsp">Register</a>
            <a href="login.jsp">Login</a>
        <% } else { %>
            <a>Welcome, <%= username %>!</a>
            <a href="logout.jsp">Logout</a>
        <% } %>
    </div>
</nav>

<div class="container">
    <div class="sidebar">
        <h2>Candidate</h2>
        <ul>
            <li><a href="findActivePolls" ><i class="fas fa-check-circle"></i>Vote</a></li>
            <li><a href="" ><i class="fa-solid fa-person-booth"></i>Register for Voting Period</a></li>
            <li><a href="viewCandidate"><i class="fas fa-list"></i> Candidate List</a></li>
            <li><a href="viewResults"><i class="fas fa-chart-bar"></i> Result</a></li>
            <li><a href="#" class="active"><i class="fas fa-book"></i> Manifesto</a></li>
        </ul>
    </div>
    <div class="content">
        <h1>Manifesto Management</h1>
        <div class="manifesto-area">
            <% if (manifestoLink != null && !manifestoLink.isEmpty()) { %>
                <p>Your current manifesto is available below:</p>
                <iframe src="<%= manifestoLink %>" allowfullscreen></iframe>
                <div class="button-container">
                    <form action="updateManifesto" method="post">
                        <input type="hidden" name="username" value="<%= username %>">
                        <button class="button" type="submit">Upload New Link</button>
                    </form>
                    <form action="deleteManifesto" method="post">
                        <input type="hidden" name="username" value="<%= username %>">
                        <button class="button" type="submit">Delete Manifesto</button>
                    </form>
                </div>
            <% } else { %>
                <p class="error-message">No manifesto has been uploaded yet.</p>
                <form action="uploadManifesto" method="post">
                    <input type="hidden" name="username" value="<%= username %>">
                    <label for="gdriveLink">Please upload your Google Drive link:</label><br>
                    <input type="text" id="gdriveLink" name="gdriveLink" required style="width: 100%; padding: 8px; border: 1px solid #ccc; border-radius: 4px;">
                    <button class="button" type="submit">Upload Link</button>
                </form>
            <% } %>
        </div>
    </div>
</div>

</body>
</html>
