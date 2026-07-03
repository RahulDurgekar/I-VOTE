package com.ivote.dao;

import com.ivote.model.Candidate;
import java.util.List;

public interface CandidateDAO {
    List<Candidate> getCandidatesByElection(int electionId);
    Candidate findById(int id);
    boolean register(Candidate candidate);
    boolean isAlreadyRegistered(int userId, int electionId);
}
