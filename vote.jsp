<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.pollify.Candidate" %>
<%@ page import="com.pollify.DBCredentials" %>
<%@ page import="java.sql.*" %>
import com.pollify.DBCredentials;

<!DOCTYPE html>
<html>
<head>
    <title>Vote</title>
</head>
<body>
    <h1>Cast Your Vote</h1>
    <form action="CastVote" method="post">
        <label for="candidate_id">Select a Candidate:</label>
        <select name="candidate_id" id="candidate_id" required>
            <option value="">--Select a Candidate--</option>
            <%
                // Fetch candidates from the database
                String jdbcURL = DBCredentials.getDbUrl();
                String jdbcUsername = DBCredentials.getDbUser();
                String jdbcPassword = DBCredentials.getDbPass();

                try (Connection connection = DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);
                     Statement statement = connection.createStatement();
                     ResultSet resultSet = statement.executeQuery("SELECT id, username FROM Users WHERE role = 'candidate'")) {

                    while (resultSet.next()) {
                        int id = resultSet.getInt("id");
                        String username = resultSet.getString("username");
            %>
                        <option value="<%= id %>"><%= username %></option>
            <%
                    }
                } catch (SQLException e) {
                    e.printStackTrace();
                    out.println("<option value=\"\">Error fetching candidates</option>");
                }
            %>
        </select>
        <br><br>
        <input type="submit" value="Vote">
    </form>
    <br>
    <a href="viewResults.jsp">View Results</a>
</body>
</html>

