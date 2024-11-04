package com.pollify;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class VoteDAO {
    public boolean recordVote(String username, int pollId) throws SQLException, ClassNotFoundException {
        Connection connection = DBCredentials.initializeDatabase(); // Use the method from DBCredentials
        String sql = "INSERT INTO Votes (username, poll_id) VALUES (?, ?)";
        
        try (PreparedStatement preparedStatement = connection.prepareStatement(sql)) {
            preparedStatement.setString(1, username);
            preparedStatement.setInt(2, pollId);
            int result = preparedStatement.executeUpdate();
            return result > 0; // Returns true if the vote was recorded
        } finally {
            if (connection != null) {
                connection.close(); // Close the connection
            }
        }
    }
}
