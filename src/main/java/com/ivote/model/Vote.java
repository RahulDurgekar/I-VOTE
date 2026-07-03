package com.ivote.model;

import java.sql.Timestamp;

/**
 * Represents a single vote cast by a voter.
 * voter_phone is stored to enforce one-vote-per-phone-per-election.
 */
public class Vote {

    private int id;
    private int voterId;
    private int candidateId;
    private int electionId;
    private String voterPhone;
    private Timestamp votedAt;

    public Vote() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getVoterId() { return voterId; }
    public void setVoterId(int voterId) { this.voterId = voterId; }

    public int getCandidateId() { return candidateId; }
    public void setCandidateId(int candidateId) { this.candidateId = candidateId; }

    public int getElectionId() { return electionId; }
    public void setElectionId(int electionId) { this.electionId = electionId; }

    public String getVoterPhone() { return voterPhone; }
    public void setVoterPhone(String voterPhone) { this.voterPhone = voterPhone; }

    public Timestamp getVotedAt() { return votedAt; }
    public void setVotedAt(Timestamp votedAt) { this.votedAt = votedAt; }
}
