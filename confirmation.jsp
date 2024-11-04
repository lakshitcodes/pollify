<% 
    String status = request.getParameter("status");
    String message = "";
    if ("success".equals(status)) {
        message = "Your vote has been successfully submitted!";
    } else if ("failed".equals(status)) {
        message = "There was an issue submitting your vote. Please try again.";
    } else if ("error".equals(status)) {
        message = "An error occurred. Please contact support.";
    }
%>
<html>
<body>
    <h2><%= message %></h2>
    <a href="vote.jsp">Back to Voting Page</a>
</body>
</html>
