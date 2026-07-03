package com.ivote.dao;

import com.ivote.model.Candidate;
import com.ivote.model.Vote;
import java.util.List;

public interface VoteDAO {
    boolean castVote(Vote vote);
    boolean hasVoted(int voterId, int electionId);
    boolean hasPhoneVoted(String phone, int electionId);
    List<Candidate> getResults(int electionId);
}
