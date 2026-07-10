package com.ivote.model;

public class User {

    public enum Role { ADMIN, USER }

    private int    id;
    private String name;
    private String email;
    private String phone;
    private String password;
    private Role   role;
    private String universityName;
    private String universityLocation;
    private byte[] profilePic;

    public User() {}

    public int getId()                          { return id; }
    public void setId(int id)                   { this.id = id; }

    public String getName()                     { return name; }
    public void setName(String name)            { this.name = name; }

    public String getEmail()                    { return email; }
    public void setEmail(String email)          { this.email = email; }

    public String getPhone()                    { return phone; }
    public void setPhone(String phone)          { this.phone = phone; }

    public String getPassword()                 { return password; }
    public void setPassword(String password)    { this.password = password; }

    public Role getRole()                       { return role; }
    public void setRole(Role role)              { this.role = role; }

    public String getUniversityName()                       { return universityName; }
    public void setUniversityName(String universityName)    { this.universityName = universityName; }

    public String getUniversityLocation()                           { return universityLocation; }
    public void setUniversityLocation(String universityLocation)    { this.universityLocation = universityLocation; }

    public byte[] getProfilePic()               { return profilePic; }
    public void setProfilePic(byte[] profilePic){ this.profilePic = profilePic; }
}
