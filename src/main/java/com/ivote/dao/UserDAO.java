package com.ivote.dao;

import com.ivote.model.User;

public interface UserDAO {
    User    findByEmailAndPassword(String email, String password);
    User    findById(int id);
    boolean register(User user);
    boolean emailExists(String email);
    boolean phoneExists(String phone);
    boolean phoneExistsForOther(String phone, int excludeUserId);
    boolean updateProfile(int id, String name, String email);
    boolean updatePhone(int id, String newPhone);
    boolean updateUniversity(int id, String universityName, String universityLocation);
    boolean updateProfilePic(int id, byte[] pic);
}
