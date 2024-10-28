package com.pollify;

public class VotingPeriod {
    private int id;
    private String startTime;
    private String endTime;
    private boolean isActive;

    public VotingPeriod(int id, String startTime, String endTime, boolean isActive) {
        this.id = id;
        this.startTime = startTime;
        this.endTime = endTime;
        this.isActive = isActive;
    }

    // Getters for the properties
    public int getId() { return id; }
    public String getStartTime() { return startTime; }
    public String getEndTime() { return endTime; }
    public boolean isActive() { return isActive; }
}
