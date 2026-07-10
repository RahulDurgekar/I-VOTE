package com.ivote.model;

/**
 * Represents a candidate in an election.
 * A user joins as a candidate by registering with a manifesto and optional profile picture.
 */
public class Candidate {

    private int id;
    private int userId;
    private int electionId;
    private String manifesto;
    private String userName;
    private String userPhone;
    private int voteCount;
    private byte[] profilePic;

    public Candidate() {}

    public int getId() { 
    	return id; 
    	}
    public void setId(int id) { 
    	this.id = id; 
    }

    public int getUserId() { 
    	return userId; 
    	}
    
    public void setUserId(int userId) { 
    	this.userId = userId; 
    	}

    public int getElectionId() { return electionId; }
    public void setElectionId(int electionId) { this.electionId = electionId; }

    public String getManifesto() { return manifesto; }
    public void setManifesto(String manifesto) { this.manifesto = manifesto; }

    public String getUserName() { return userName; }
    public void setUserName(String userName) { this.userName = userName; }

    public String getUserPhone() { return userPhone; }
    public void setUserPhone(String userPhone) { this.userPhone = userPhone; }

    public int getVoteCount() { return voteCount; }
    public void setVoteCount(int voteCount) { this.voteCount = voteCount; }

    public byte[] getProfilePic() { return profilePic; }
    public void setProfilePic(byte[] profilePic) { this.profilePic = profilePic; }
}
