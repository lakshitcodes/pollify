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
            <li><a href="#" onclick="loadContent('introduction')"><i class="fas fa-check-circle"></i> Vote</a></li>
            <li><a href="#" onclick="loadContent('output')" class="active"><i class="fas fa-list"></i> Candidate List</a></li>
            <li><a href="#" onclick="loadContent('syntax')"><i class="fas fa-chart-bar"></i> Result</a></li>
            <li><a href="#" onclick="loadContent('manifesto')"><i class="fas fa-book"></i> Manifesto</a></li>
            <li><a href="#" onclick="loadContent('applyCandidate')"><i class="fas fa-user-plus"></i> Apply for Candidate</a></li>
        </ul>
    </div>

    <!-- Content Area -->
    <div class="content">
        <div id="content-area">
            <h1>Welcome to Pollify</h1>
            <p>Select an option from the sidebar to learn more.</p>
        </div>
    </div>
</div>

<script>
function loadContent(page) {
    const contentArea = document.getElementById('content-area');
    const links = document.querySelectorAll('.sidebar ul li a');

    // Remove 'active' class from all sidebar links
    links.forEach(link => link.classList.remove('active'));

    // Add 'active' class to the clicked link
    const activeLink = Array.from(links).find(link => link.getAttribute('onclick').includes(page));
    if (activeLink) activeLink.classList.add('active');

    // Load corresponding content based on the page parameter
    switch (page) {
        case 'applyCandidate':
    contentArea.innerHTML = `
        <h1>Apply to be a Candidate</h1>
        <div class="disclaimer">
            <h2>Disclaimer</h2>
            <p>Please read the following rules before applying:</p>
            <ul>
                <li>You must be a registered voter in the current election.</li>
                <li>All applications will be reviewed by the admin.</li>
                <li>You must provide a manifesto outlining your vision and goals.</li>
                <li>Ensure that your manifesto does not contain any offensive or inappropriate content.</li>
                <li>Only one application per user is allowed.</li>
                <li>Applicants must be available for the duration of the voting period.</li>
            </ul>
            <p>By clicking "Apply," you agree to abide by these rules.</p>
        </div>
        <form action="applyCandidate" method="POST">
            <button type="submit" class="apply-button">Apply</button>
        </form>
        <div id="responseMessage"></div>
    `;
    break;
    case 'manifesto':
                contentArea.innerHTML = 
                    `<h1>Manifesto</h1>
                    <p>A manifesto is a published declaration of the intentions, motives, or views of the issuer, be it an individual, group, political party, or government.</p>
                    <p>It often contains statements of principles, goals, and policies.</p>
                    <p>Manifestos are usually designed to appeal to a wide audience, but they can also be tailored to specific groups, such as voters, party members, or stakeholders.</p>`
                ;
                break;
            // Handle other cases here...
            default:
                contentArea.innerHTML = `<h1>Welcome to Pollify</h1><p>Select an option from the sidebar to learn more.</p>`;
                break;
    }
}

function submitCandidateForm() {
    const manifesto = document.getElementById('manifesto').value;
    const xhr = new XMLHttpRequest();
    xhr.open('POST', 'applyCandidate', true);
    xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
    xhr.onreadystatechange = function () {
        if (xhr.readyState === XMLHttpRequest.DONE) {
            const responseMessage = document.getElementById('responseMessage');
            if (xhr.status === 200) {
                responseMessage.innerHTML = '<p>Application submitted successfully!</p>';
            } else {
                responseMessage.innerHTML = '<p>Error submitting application: ' + xhr.responseText + '</p>';
            }
        }
    };
    xhr.send('manifesto=' + encodeURIComponent(manifesto));
}
</script>

</body>
</html>
