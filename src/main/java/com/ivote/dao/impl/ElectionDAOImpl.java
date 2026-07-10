package com.ivote.dao.impl;

import com.ivote.dao.ElectionDAO;
import com.ivote.model.Election;
import com.ivote.util.DatabaseUtil;

import java.sql.*;
import java.util.*;

public class ElectionDAOImpl implements ElectionDAO {

    @Override
    public List<Election> getAllElections() {
        List<Election> list = new ArrayList<>();
        String sql = "SELECT * FROM elections ORDER BY start_time DESC";
        try (Connection conn = DatabaseUtil.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public List<Election> getElectionsByAdmin(int adminId) {
        List<Election> list = new ArrayList<>();
        String sql = "SELECT * FROM elections WHERE created_by = ? ORDER BY start_time DESC";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, adminId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public Election findById(int id) {
        String sql = "SELECT * FROM elections WHERE id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public Election findByCode(String code) {
        String sql = "SELECT * FROM elections WHERE election_code = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, code);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public boolean create(Election election) {
        String sql = "INSERT INTO elections "
                   + "(title, description, institution_name, election_code, status, "
                   + "start_time, end_time, candidate_registration_deadline, created_by) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, election.getTitle());
            ps.setString(2, election.getDescription());
            ps.setString(3, election.getInstitutionName());
            ps.setString(4, election.getElectionCode());
            ps.setString(5, election.getStatus().name());
            ps.setTimestamp(6, election.getStartTime());
            ps.setTimestamp(7, election.getEndTime());
            ps.setTimestamp(8, election.getCandidateRegistrationDeadline());
            ps.setInt(9, election.getCreatedBy());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public boolean update(Election election) {
        String sql = "UPDATE elections SET title = ?, description = ?, institution_name = ?, "
                   + "start_time = ?, end_time = ?, candidate_registration_deadline = ? "
                   + "WHERE id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, election.getTitle());
            ps.setString(2, election.getDescription());
            ps.setString(3, election.getInstitutionName());
            ps.setTimestamp(4, election.getStartTime());
            ps.setTimestamp(5, election.getEndTime());
            ps.setTimestamp(6, election.getCandidateRegistrationDeadline());
            ps.setInt(7, election.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public boolean updateStatus(int id, Election.Status status) {
        String sql = "UPDATE elections SET status = ? WHERE id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status.name());
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public boolean delete(int id) {
        String sql = "DELETE FROM elections WHERE id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private Election mapRow(ResultSet rs) throws SQLException {
        Election e = new Election();
        e.setId(rs.getInt("id"));
        e.setTitle(rs.getString("title"));
        e.setDescription(rs.getString("description"));
        e.setInstitutionName(rs.getString("institution_name"));
        e.setElectionCode(rs.getString("election_code"));
        e.setStatus(Election.Status.valueOf(rs.getString("status")));
        e.setStartTime(rs.getTimestamp("start_time"));
        e.setEndTime(rs.getTimestamp("end_time"));
        e.setCandidateRegistrationDeadline(rs.getTimestamp("candidate_registration_deadline"));
        e.setCreatedBy(rs.getInt("created_by"));
        return e;
    }
}
