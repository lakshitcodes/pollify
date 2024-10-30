<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.pollify.Candidate" %>
<%@ page import="java.util.List" %>
<html>
<head>
    <title>Cast Your Vote</title>
</head>
<body>
    <h2>Cast Your Vote</h2>

    <form action="SubmitVote" method="post">
        <%
            // Retrieve the active candidates from the request attribute
            List<Candidate> candidates = (List<Candidate>) request.getAttribute("candidates");
            
            if (candidates == null || candidates.isEmpty()) {
        %>
            <p>No candidates available to vote for.</p>
        <%
            } else {
                for (Candidate candidate : candidates) {
        %>
                    <input type="radio" name="candidateId" value="<%= candidate.getId() %>">
                    <%= candidate.getName() %><br>
        <%
                }
        %>
        <input type="submit" value="Vote">
        <%
            }
        %>
    </form>

</body>
</html>
