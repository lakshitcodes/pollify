<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.HttpSession" %>
<%@ page import="java.util.List" %>
<%@ page import="com.pollify.VotingPeriod" %>
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
        if (!"voter".equals(session.getAttribute("role"))) { // Check if the user is a voter
            response.sendRedirect("accessDenied.jsp"); // Redirect if the role is not voter
            return; // Stop further processing
        }
    } else {
        response.sendRedirect("login.jsp"); // Optional: Redirect to login if session is null
        return; // Stop further processing
    }
%>

<% 
    String statusMessage = request.getParameter("status");
    if (statusMessage != null) { 
%>
    <p><%= statusMessage %></p>
<% 
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

header input[type="text"] {
    padding: 12px 15px;
    width: 220px;
    border: none;
    border-radius: 30px;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
    transition: box-shadow 0.3s;
    outline: none;
    font-size: 14px;
}

header input[type="text"]:focus {
    box-shadow: 0 4px 18px rgba(0, 0, 0, 0.15);
}

.poll-list {
    display: grid;
    gap: 20px;
}

.poll-card {
    background: linear-gradient(135deg, #fff, #f7faff);
    border-radius: 15px;
    padding: 25px;
    box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
    transition: transform 0.3s, box-shadow 0.3s;
    position: relative;
    overflow: hidden;
}

.poll-card:hover {
    transform: translateY(-5px);
    box-shadow: 0 8px 18px rgba(0, 0, 0, 0.15);
}

.poll-card h2 {
    font-size: 20px;
    font-weight: 600;
    color: #34495e;
    margin-bottom: 10px;
}

.poll-card p {
    font-size: 14px;
    color: #7f8c8d;
    margin-bottom: 15px;
}

.poll-info {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 15px;
}

.time-remaining {
    font-size: 12px;
    color: #95a5a6;
}

.status {
    font-size: 12px;
    padding: 5px 12px;
    border-radius: 20px;
    color: #fff;
    font-weight: 500;
}

.status.open {
    background-color: #27ae60;
}

.status.closing-soon {
    background-color: #e74c3c;
}

.vote-btn {
    padding: 12px 25px;
    background: linear-gradient(135deg, #3498db, #2980b9);
    color: #fff;
    font-size: 14px;
    font-weight: 500;
    border: none;
    border-radius: 30px;
    cursor: pointer;
    transition: background 0.3s;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
}

.vote-btn:hover {
    background: linear-gradient(135deg, #2980b9, #3498db);
    box-shadow: 0 6px 15px rgba(0, 0, 0, 0.15);
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
        <h2>Pollify Voter</h2>
        <ul>
            <li><a href="#" class="active"><i class="fas fa-check-circle"></i> Vote</a></li>
            <li><a href="CandidateList.jsp"><i class="fas fa-list"></i> Candidate List</a></li>
            <li><a href="Results.jsp"><i class="fas fa-chart-bar"></i> Result</a></li>
            <li><a href="viewManifesto.jsp"><i class="fas fa-book"></i> Manifesto</a></li>
            <li><a href="applyCandidate.jsp"><i class="fas fa-user-plus"></i> Apply for Candidate</a></li>
        </ul>
    </div>

    <!-- Content Area -->
    
    <div class="content">
        <% List<VotingPeriod> votingPeriods = (List<VotingPeriod>) request.getAttribute("activeVotingPeriods"); %>

                <div id="content-area">
                    <header>
                        <h1>Active Polls (Total: <%= (votingPeriods != null ? votingPeriods.size() : 0) %>)</h1>
                        <input type="text" placeholder="🔍 Search polls...">
                    </header>
                    <section class="poll-list">
                        <%
                            if (votingPeriods != null && !votingPeriods.isEmpty()) {
                                for (VotingPeriod vp : votingPeriods) {
                        %>
                        <div class="poll-card">
                            <h2>Poll ID: <%= vp.getId() %></h2>
                            <p>Voting Period from <%= vp.getStartTime() %> to <%= vp.getEndTime() %></p>
                            <div class="poll-info">
                                <span class="time-remaining">Ends at: <%= vp.getEndTime() %></span>
                                <span class="status <%= vp.isActive() ? "open" : "closed" %>">
                                    <%= vp.isActive() ? "Open" : "Closed" %>
                                </span>
                            </div>
                            <form action="SubmitVoteServlet" method="POST" style="display: inline;">
                                <input type="hidden" name="pollId" value="<%= vp.getId() %>">
                                <button type="submit" class="vote-btn">Vote Now</button>
                            </form>
                        </div>
                        <% 
                                } // end for loop
                            } else { 
                        %>
                        <p>No active polls available at the moment.</p>
                        <% } %>
                    </section>
                </div>
                
    </div>
    
</div>

</body>
</html>