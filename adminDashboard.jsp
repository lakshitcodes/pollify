<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.HttpSession" %>
<%
    if (session != null && session.getAttribute("username") != null) {
        if (!"admin".equals(session.getAttribute("role"))) { // Check if the user is not admin
            response.sendRedirect("accessDenied.jsp"); // Redirect if the role is not admin
            return; // Stop further processing
        }
    } else {
        response.sendRedirect("login.jsp"); // Redirect to login if session is null
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
    <link
    href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css"
    rel="stylesheet"
    />
</head>
<body>
    <%
        String username = (session != null) ? (String) session.getAttribute("username") : null; // Get the username if session exists
        String successMessage = (String) session.getAttribute("successMessage");
        String errorMessage = (String) session.getAttribute("errorMessage");

        // Clear the messages after displaying
        if (successMessage != null) {
            session.removeAttribute("successMessage");
        }
        if (errorMessage != null) {
            session.removeAttribute("errorMessage");
        }
    %>

    <nav>
        <div class="logo">Pollify</div>
        <div class="menu">
            <% if(username == null) { %>
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
            <h2>Admin</h2>
            <ul>
                <li><a href="#" onclick="loadContent('setVotingPeriod')" class="active">
                    <i class="fas fa-calendar"></i> Set Voting Period
                </a></li>
                <li><a href="#" onclick="loadContent('declareResult')">
                    <i class="fas fa-trophy"></i> Declare Result
                </a></li>
                <li><a href="#" onclick="loadContent('approveCandidate')">
                    <i class="fas fa-thumbs-up"></i> Approve Candidate
                </a></li>
                <li><a href="#" onclick="loadContent('viewVotingPeriods')">
                    <i class="fas fa-history"></i> View Voting Periods
                </a></li>
                <li><a href="#" onclick="loadContent('sendNotification')">
                    <i class="fas fa-bell"></i> Send Notification
                </a></li>
            </ul>
        </div>
       
        <!-- Content Area -->
        <div class="content">
            <div id="content-area">
                <h1>Welcome to Pollify</h1>
                <p>Select an option from the sidebar to learn more.</p>

                <!-- Display success or error messages -->
                <div>
                    <%
                    // Display success message
                    if (successMessage != null) {
                        out.println("<div style='color: green; font-weight: bold;'>" + successMessage + "</div>");
                    }
                    // Display error message
                    if (errorMessage != null) {
                        out.println("<div style='color: red; font-weight: bold;'>Error: " + errorMessage + "</div>");
                    }
                    %>
                </div>
            </div>

            <div id="voting-period-form" style="display:none;">
                <h2>Set Voting Period</h2>
                <form action="SetVotingPeriod" method="post">
                    <label for="start_time">Voting Start Time:</label>
                    <input type="datetime-local" id="start_time" name="start_time" required>

                    <label for="end_time">Voting End Time:</label>
                    <input type="datetime-local" id="end_time" name="end_time" required>

                    <input type="submit" value="Set Voting Period">
                </form>
            </div>
        </div>
    </div>

    <script>
        function loadContent(page) {
            const contentArea = document.getElementById('content-area');
            const votingPeriodForm = document.getElementById('voting-period-form');
            const links = document.querySelectorAll('.sidebar ul li a');
    
            // Remove 'active' class from all sidebar links
            links.forEach(link => link.classList.remove('active'));
    
            // Add 'active' class to the clicked link
            const activeLink = Array.from(links).find(link =>
                link.getAttribute('onclick').includes(page)
            );
            if (activeLink) activeLink.classList.add('active');
    
            console.log(`Loading content for: ${page}`); // Debugging line
    
            // Load corresponding content based on the page parameter
            switch (page) {
                case 'declareResult':
                    contentArea.innerHTML = `
                        <h1>Declare Result</h1>
                        <p>Declare the results of the voting here.</p>
                    `;
                    votingPeriodForm.style.display = 'none'; // Hide the form
                    break;
                case 'approveCandidate':
                    contentArea.innerHTML = `
                        <h1>Approve Candidate</h1>
                        <p>Approve candidates for the election here.</p>
                    `;
                    votingPeriodForm.style.display = 'none'; // Hide the form
                    break;
                case 'ViewVotingPeriods':
                    contentArea.innerHTML = `
                        <h1>View Voting Periods</h1>
                        <p>Review previous voting periods.</p>
                        <iframe src="viewVotingPeriods" style="width: 100%; height: 400px; border: none;"></iframe>
                    `;
                    votingPeriodForm.style.display = 'none'; // Hide the form
                    break;
                case 'sendNotification':
                    contentArea.innerHTML = `
                        <h1>Send Notification</h1>
                        <p>Send notifications to users about voting updates.</p>
                    `;
                    votingPeriodForm.style.display = 'none'; // Hide the form
                    break;
                case 'setVotingPeriod':
                    contentArea.innerHTML = ''; // Clear the content area
                    votingPeriodForm.style.display = 'block'; // Show the voting period form
                    break;
                default:
                    contentArea.innerHTML = `
                        <h1>404 Not Found</h1>
                        <p>The page you are looking for does not exist.</p>
                    `;
                    votingPeriodForm.style.display = 'none'; // Hide the form
                    break;
            }
        }
    </script>
    
</body>
</html>
