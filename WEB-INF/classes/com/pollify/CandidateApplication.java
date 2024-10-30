package com.pollify;
import java.sql.*;

public class CandidateApplication {
    private int id;
    private String username;
    private String email;
    private Timestamp applicationDate;

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public Timestamp getApplicationDate() { return applicationDate; }
    public void setApplicationDate(Timestamp applicationDate) { this.applicationDate = applicationDate; }
}
