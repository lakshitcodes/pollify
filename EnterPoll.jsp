<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.HttpSession" %>
<%@ page import="java.util.List" %>
<%@ page import="com.pollify.VotingPeriod" %>
<%@ page import="com.pollify.Candidate" %>
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

        /* Your CSS for card design here */
        :root {
            --card-background: rgba(255, 255, 255, 0.7);
            --primary-color: #4a90e2;
            --secondary-color: #ff5f7e;
            --text-color: #333;
            --shadow-color: rgba(0, 0, 0, 0.2);
            --border-color: rgba(255, 255, 255, 0.4);
            --transition-speed: 0.3s;
            --blur: 10px;
        }


        .container {
            width: 100%;
            backdrop-filter: blur(var(--blur));
            text-align: center;
            color: var(--text-color);
        }

        h2 {
            font-size: 26px;
            font-weight: 600;
            color: #333;
            margin-bottom: 20px;
            opacity: 0.9;
        }

        .candidate-card {
            background: var(--card-background);
            padding: 20px;
            margin: 15px 0;
            border-radius: 16px;
            box-shadow: 0 8px 16px var(--shadow-color);
            border: 1px solid var(--border-color);
            display: flex;
            justify-content: space-between;
            align-items: center;
            transition: transform var(--transition-speed), box-shadow var(--transition-speed);
            backdrop-filter: blur(10px);
        }

        .candidate-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 12px 20px rgba(0, 0, 0, 0.2);
        }

        .candidate-info {
            display: flex;
            align-items: center;
        }

        .candidate-name {
            font-size: 20px;
            font-weight: 600;
            color: var(--text-color);
            margin: 0;
        }

        .candidate-description {
            font-size: 16px;
            color: #555;
            margin-top: 5px;
            /* margin-left: -30px; */
            opacity: 0.8;
        }

        .action-buttons {
            display: flex;
            gap: 10px;
        }

        .action-buttons button ,.final-btn{
            padding: 10px 20px;
            font-size: 14px;
            font-weight: 500;
            border-radius: 8px;
            border: none;
            cursor: pointer;
            transition: background-color var(--transition-speed), transform var(--transition-speed);
            color: #fff;
        }

        .approve-btn.selected {
            background: linear-gradient(135deg, #5cb85c, #4cae4c); /* Highlight color */
        }

        .approve-btn:not(.selected) {
            background: rgba(0, 122, 255, 0.5); /* Dull color */
            opacity: 0.6; /* Optional: make it more transparent */
            cursor: not-allowed; /* Optional: change cursor to indicate it's not clickable */
        }
        .approve-btn.selected:hover,.approve-btn:hover, .final-btn:hover {
            transform: translateY(-3px);
            opacity: 0.9;
            box-shadow: 0 6px 12px rgba(0, 0, 0, 0.15);
        }
        .vote-button-container {
    text-align: right; /* Aligns the button to the right */
    margin-top: 20px; /* Adds space above the button */
}
    .final-btn {
        padding: 10px 20px;
        background: linear-gradient(135deg, #4a90e2, #007aff);
        box-shadow: 0 4px 8px rgba(74, 144, 226, 0.4); 
        color: white; border: none; 
        border-radius: 5px; 
        cursor: pointer;
        width: 200px;
    }
    </style>
</head>
<body>
    <% 
        String username = (session != null) ? (String) session.getAttribute("username") : null; 
        VotingPeriod vp = (VotingPeriod) request.getAttribute("votingPeriod");
        List<Candidate> candidates = (List<Candidate>) request.getAttribute("candidates");    
    %>
    
    <nav>
        <div class="logo">Pollify</div>
        <div class="menu">
            <% if(username == null) { %>
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
    
        <div class="content">
            <div id="content-area">
                <header>
                    <h1>Poll ID: <%= vp.getId() %></h1>
                    <p>Voting Period from <%= vp.getStartTime() %> to <%= vp.getEndTime() %></p>
                </header>
                <section class="candidate-list">
                    <%
                        if (candidates != null && !candidates.isEmpty()) {
                            for (Candidate candidate : candidates) {
                    %>
                        <div class="candidate-card">
                            <div class="candidate-info">
                                <div>
                                    <p class="candidate-name" id="<%= candidate.getId() %>">Candidate ID: <%= candidate.getId() %></p>
                                    <p class="candidate-description"><strong>Username:</strong> <%= candidate.getName() %></p> 
                                </div>
                            </div>
                            <div class="action-buttons">
                                <button class="approve-btn">Select</button>
                            </div>
                        </div>
                    <%
                            }
                        } else {
                    %>
                        <p>No candidates available.</p>
                    <%
                        }
                    %>
                    <hr style="border-top: 1px solid rgb(162, 158, 158); margin: 20px 0;">
                    <div class="vote-button-container">
                        <button id="vote-button" class="final-btn">Vote</button>
                    </div>
                </section>
            </div>
        </div>
    </div>
    <script>
    document.addEventListener("DOMContentLoaded", function () {
    const voteButtons = document.querySelectorAll(".approve-btn");

    voteButtons.forEach(button => {
        button.addEventListener("click", function () {
            // Check if the button is already selected
            if (button.classList.contains("selected")) {
                // Deselect the button
                button.classList.remove("selected");
                button.textContent = "Select"; // Reset text to default
                button.style.backgroundColor = ""; // Reset background color
            } else {
                // Deselect other buttons
                voteButtons.forEach(btn => {
                    btn.classList.remove("selected");
                    btn.textContent = "Select"; // Reset to default
                    btn.style.backgroundColor = ""; // Reset to default
                });

                // Select the current button
                button.classList.add("selected");
                button.textContent = "Selected"; // Change text to indicate selection
                button.style.backgroundColor = "#4cae4c"; // Highlight color for the selected button
            }
        });
    });

    // Vote button click event
    document.getElementById("vote-button").addEventListener("click", function () {
        let selectedCandidateId = null;

        // Find the selected candidate
        voteButtons.forEach(button => {
            if (button.classList.contains("selected")) {
                // Get the candidate ID from the candidate-name paragraph in the same candidate-card
                const candidateCard = button.closest('.candidate-card');
                console.log("Candidate card found:", candidateCard); // Debug log

                const candidateNameElement = candidateCard.querySelector('.candidate-name');
                console.log("Candidate name element found:", candidateNameElement); // Debug log

                // Extract the ID directly from the text content since it's displayed as "Candidate ID: X"
                const candidateIdText = candidateNameElement.textContent;
                console.log("Candidate ID text:", candidateIdText); // Debug log

                // Extract just the number from "Candidate ID: X"
                selectedCandidateId = candidateIdText.split(":")[1].trim();
                console.log("Selected candidate ID:", selectedCandidateId);
            }
        });

        if (selectedCandidateId) {
            const url = "registerVote?candidateId="+selectedCandidateId;
            window.location.href = url;
        } else {
            alert('Please select a candidate to vote for.');
        }
    });
});

</script>
    
</body>
</html>