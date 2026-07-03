package com.ivote.dao;

import com.ivote.model.Election;
import java.util.List;

public interface ElectionDAO {
    List<Election> getAllElections();
    Election findById(int id);
    Election findByCode(String code);
    boolean create(Election election);
    boolean updateStatus(int id, Election.Status status);
    boolean delete(int id);
}
