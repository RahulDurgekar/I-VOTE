package com.ivote.dao.impl;

import com.ivote.dao.CandidateDAO;
import com.ivote.model.Candidate;
import com.ivote.util.DatabaseUtil;

import java.sql.*;
import java.util.*;

public class CandidateDAOImpl implements CandidateDAO {

    @Override
    public List<Candidate> getCandidatesByElection(int electionId) {
        List<Candidate> list = new ArrayList<>();
        String sql = "SELECT c.*, u.name AS user_name, u.phone AS user_phone FROM candidates c " +
                     "JOIN users u ON c.user_id = u.id WHERE c.election_id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, electionId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    @Override
    public Candidate findById(int id) {
        String sql = "SELECT c.*, u.name AS user_name, u.phone AS user_phone FROM candidates c " +
                     "JOIN users u ON c.user_id = u.id WHERE c.id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    @Override
    public boolean register(Candidate candidate) {
        String sql = "INSERT INTO candidates (user_id, election_id, manifesto, profile_pic) VALUES (?, ?, ?, ?)";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, candidate.getUserId());
            ps.setInt(2, candidate.getElectionId());
            ps.setString(3, candidate.getManifesto());
            ps.setBytes(4, candidate.getProfilePic());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    @Override
    public boolean isAlreadyRegistered(int userId, int electionId) {
        String sql = "SELECT id FROM candidates WHERE user_id = ? AND election_id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, electionId);
            return ps.executeQuery().next();
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    private Candidate mapRow(ResultSet rs) throws SQLException {
        Candidate c = new Candidate();
        c.setId(rs.getInt("id"));
        c.setUserId(rs.getInt("user_id"));
        c.setElectionId(rs.getInt("election_id"));
        c.setManifesto(rs.getString("manifesto"));
        c.setUserName(rs.getString("user_name"));
        c.setUserPhone(rs.getString("user_phone"));
        c.setProfilePic(rs.getBytes("profile_pic"));
        return c;
    }
}
