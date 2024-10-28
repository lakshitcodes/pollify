<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.pollify.VotingPeriod" %>
<html>
<head>
    <title>Voting Periods</title>
    <style>
        table {
            width: 100%;
            border-collapse: collapse;
        }
        th, td {
            padding: 10px;
            text-align: left;
            border: 1px solid #ddd;
        }
        th {
            background-color: #f2f2f2;
        }
    </style>
</head>
<body>
    <h1>Voting Periods</h1>
    <table>
        <tr>
            <th>ID</th>
            <th>Start Time</th>
            <th>End Time</th>
            <th>Active</th>
        </tr>
        <%
            // Retrieve the list of voting periods from the request
            List<VotingPeriod> votingPeriods = (List<VotingPeriod>) request.getAttribute("votingPeriods");
            if (votingPeriods != null && !votingPeriods.isEmpty()) {
                for (VotingPeriod period : votingPeriods) {
        %>
        <tr>
            <td><%= period.getId() %></td>
            <td><%= period.getStartTime() %></td>
            <td><%= period.getEndTime() %></td>
            <td><%= period.isActive() ? "Yes" : "No" %></td>
        </tr>
        <%
                }
            } else {
        %>
        <tr>
            <td colspan="4">No voting periods found.</td>
        </tr>
        <%
            }
        %>
    </table>
    <!-- <a href="adminDashboard.jsp">Back to Dashboard</a> -->
</body>
</html>

