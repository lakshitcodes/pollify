<%@ page import="java.util.List" %>
<%@ page import="com.pollify.Candidate" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.HttpSession" %>
<%@ page import="java.net.URLDecoder" %>

<%
    String status = request.getParameter("status");
    if (status != null) {
        status = URLDecoder.decode(status, "UTF-8");
%>
<script>
    alert("<%= status %>");
    // Remove the status parameter from the URL
    const url = new URL(window.location);
    url.searchParams.delete('status'); // Remove the 'status' parameter
    window.history.replaceState({}, document.title, url);
</script>
<%
    }
%>
<%
   if (session != null && session.getAttribute("username") != null) {
        if ("admin".equals(session.getAttribute("role"))) { // Check if the user is a voter
             response.sendRedirect("accessDenied.jsp"); // Redirect if the role is not voter
            return; // Stop further processing
        }
    } else {
        response.sendRedirect("login.jsp"); // Optional: Redirect to login if session is null
        return; // Stop further processing
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Pollify - Interactive Sidebar</title>
    <link rel="stylesheet" href="css/user_page.css">
    <link rel="stylesheet" href="css/navbar.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet"/>
    <style>
        .disclaimer {
            background-color: #f9f9f9;
            border: 1px solid #ccc;
            border-radius: 5px;
            padding: 20px;
            margin: 20px 0;
        }

        .disclaimer h2 {
            color: #d9534f; /* Bootstrap danger color for emphasis */
        }

        .disclaimer ul {
            list-style-type: disc;
            margin-left: 20px;
        }

        .apply-button {
            background-color: #5cb85c; /* Bootstrap success color */
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
            transition: background-color 0.3s ease;
        }

        .apply-button:hover {
            background-color: #4cae4c; /* Darker shade for hover effect */
        }
        .candidate-list{
            display: grid;
            gap: 20px;
        }
        header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 20px;
    position: relative;
}

header h1 {
    font-size: 26px;
    font-weight: 600;
    color: #333;
}

.candidate-card {
    background: linear-gradient(135deg, #fff, #f7faff);
    border-radius: 15px;
    padding: 25px;
    box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
    transition: transform 0.3s, box-shadow 0.3s;
    position: relative;
    overflow: hidden;
}

.candidate-card:hover {
    transform: translateY(-5px);
    box-shadow: 0 8px 18px rgba(0, 0, 0, 0.15);
}

.candidate-card h2 {
    font-size: 20px;
    font-weight: 600;
    color: #34495e;
    margin-bottom: 10px;
}

.candidate-card p {
    font-size: 14px;
    color: #7f8c8d;
}

    </style>
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
            <a>Welcome, <%= username %>!</a>
            <a href="logout.jsp">Logout</a> <!-- Link to logout servlet -->
        <% } %>
    </div>
</nav>

<div class="container">
    <div class="sidebar">
        <% if ("voter".equals(session.getAttribute("role"))) { %>
        <h2>Pollify Voter</h2>
        <ul>
            <li><a href="findActivePolls"><i class="fas fa-check-circle"></i> Vote</a></li>
            <li><a href="#" class="active"><i class="fas fa-list"></i> Candidate List</a></li>
            <li><a href="viewResults"><i class="fas fa-chart-bar"></i> Result</a></li>
            <li><a href="viewManifesto.jsp"><i class="fas fa-book"></i> Manifesto</a></li>
            <li><a href="applyCandidate.jsp"><i class="fas fa-user-plus"></i> Apply for Candidate</a></li>
        </ul>
        <% } %>
        <% if ("candidate".equals(session.getAttribute("role"))) { %>
            <h2>Candidate</h2>
        <ul>
            <li><a href="findActivePolls"><i class="fas fa-check-circle"></i>Vote</a></li>
            <li><a href="#"><i class="fa-solid fa-person-booth"></i>Register for Voting Period</a></li>
            <li><a href="#" class="active"><i class="fas fa-list"></i> Candidate List</a></li>
            <li><a href="viewResults"><i class="fas fa-chart-bar"></i> Result</a></li>
            <li><a href="candidateManifesto"><i class="fas fa-book"></i> Manifesto</a></li>
        </ul>
        <% } %>
    </div>

    <!-- Content Area -->
    <div class="content">
        <header>    
            <h1>Candidate List</h1>
        </header>
        <%
            List<Candidate> candidates = (List<Candidate>) request.getAttribute("candidates"); 
        %>
    
        <section class="candidate-list">
            <%
                if (candidates != null && !candidates.isEmpty()) {
                    for (Candidate candidate : candidates) {
            %>
                <div class="candidate-card">
                    <h2>Candidate ID: <%= candidate.getId() %></h2>
                    <p><strong>Username:</strong> <%= candidate.getName() %></p>
                </div>
            <%
                    }
                } else {
            %>
                <p>No candidates available.</p>
            <%
                }
            %>
        </section>
    </div>
    
</div>


</body>
</html>