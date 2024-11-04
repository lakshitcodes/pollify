package com.pollify;


public class Result {
    private int id;
    private int votingPeriodId;
    private int winnerCandidateId;
    private int totalVotes;
    private double winnerPercentage;
    private double turnoutRatio;
    private String startTime;
    private String endTime;
    private String winnerUsername;

    public Result(int id, int votingPeriodId, int winnerCandidateId, int totalVotes, double winnerPercentage,
                   double turnoutRatio, String startTime, String endTime, String winnerUsername) {
        this.id = id;
        this.votingPeriodId = votingPeriodId;
        this.winnerCandidateId = winnerCandidateId;
        this.totalVotes = totalVotes;
        this.winnerPercentage = winnerPercentage;
        this.turnoutRatio = turnoutRatio;
        this.startTime = startTime;
        this.endTime = endTime;
        this.winnerUsername = winnerUsername;
    }

    // Getters for the properties
    public int getId() { return id; }
    public int getVotingPeriodId() { return votingPeriodId; }
    public int getWinnerCandidateId() { return winnerCandidateId; }
    public int getTotalVotes() { return totalVotes; }
    public double getWinnerPercentage() { return winnerPercentage; }
    public double getTurnoutRatio() { return turnoutRatio; }
    public String getStartTime() { return startTime; }
    public String getEndTime() { return endTime; }
    public String getWinnerUsername() { return winnerUsername; }
}