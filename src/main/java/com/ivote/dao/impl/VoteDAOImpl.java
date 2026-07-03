package com.ivote.dao.impl;

import com.ivote.dao.VoteDAO;
import com.ivote.model.Candidate;
import com.ivote.model.Vote;
import com.ivote.util.DatabaseUtil;

import java.sql.*;
import java.util.*;

public class VoteDAOImpl implements VoteDAO {

    @Override
    public boolean castVote(Vote vote) {
        String sql = "INSERT INTO votes (voter_id, candidate_id, election_id, voter_phone) VALUES (?, ?, ?, ?)";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, vote.getVoterId());
            ps.setInt(2, vote.getCandidateId());
            ps.setInt(3, vote.getElectionId());
            ps.setString(4, vote.getVoterPhone());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    @Override
    public boolean hasVoted(int voterId, int electionId) {
        String sql = "SELECT id FROM votes WHERE voter_id = ? AND election_id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, voterId);
            ps.setInt(2, electionId);
            return ps.executeQuery().next();
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    @Override
    public boolean hasPhoneVoted(String phone, int electionId) {
        String sql = "SELECT id FROM votes WHERE voter_phone = ? AND election_id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, phone);
            ps.setInt(2, electionId);
            return ps.executeQuery().next();
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    @Override
    public List<Candidate> getResults(int electionId) {
        List<Candidate> list = new ArrayList<>();
        String sql = "SELECT c.id, c.user_id, c.election_id, c.manifesto, c.profile_pic, " +
                     "u.name AS user_name, u.phone AS user_phone, COUNT(v.id) AS vote_count " +
                     "FROM candidates c " +
                     "JOIN users u ON c.user_id = u.id " +
                     "LEFT JOIN votes v ON v.candidate_id = c.id AND v.election_id = c.election_id " +
                     "WHERE c.election_id = ? " +
                     "GROUP BY c.id, c.user_id, c.election_id, c.manifesto, c.profile_pic, u.name, u.phone " +
                     "ORDER BY vote_count DESC";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, electionId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Candidate c = new Candidate();
                c.setId(rs.getInt("id"));
                c.setUserId(rs.getInt("user_id"));
                c.setElectionId(rs.getInt("election_id"));
                c.setManifesto(rs.getString("manifesto"));
                c.setUserName(rs.getString("user_name"));
                c.setUserPhone(rs.getString("user_phone"));
                c.setProfilePic(rs.getBytes("profile_pic"));
                c.setVoteCount(rs.getInt("vote_count"));
                list.add(c);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }
}
