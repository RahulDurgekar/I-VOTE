package com.ivote.model;

import java.sql.Timestamp;

public class Election {

    public enum Status { UPCOMING, ACTIVE, CLOSED }

    private int       id;
    private String    title;
    private String    description;
    private String    institutionName;
    private String    electionCode;
    private Status    status;
    private Timestamp startTime;
    private Timestamp endTime;
    private Timestamp candidateRegistrationDeadline;
    private int       createdBy;

    public Election() {}

    public int getId()                          { return id; }
    public void setId(int id)                   { this.id = id; }

    public String getTitle()                    { return title; }
    public void setTitle(String title)          { this.title = title; }

    public String getDescription()              { return description; }
    public void setDescription(String desc)     { this.description = desc; }

    public String getInstitutionName()                      { return institutionName; }
    public void setInstitutionName(String institutionName)  { this.institutionName = institutionName; }

    public String getElectionCode()                     { return electionCode; }
    public void setElectionCode(String electionCode)    { this.electionCode = electionCode; }

    public Status getStatus()                   { return status; }
    public void setStatus(Status status)        { this.status = status; }

    public Timestamp getStartTime()             { return startTime; }
    public void setStartTime(Timestamp t)       { this.startTime = t; }

    public Timestamp getEndTime()               { return endTime; }
    public void setEndTime(Timestamp t)         { this.endTime = t; }

    public Timestamp getCandidateRegistrationDeadline()         { return candidateRegistrationDeadline; }
    public void setCandidateRegistrationDeadline(Timestamp t)   { this.candidateRegistrationDeadline = t; }

    public int getCreatedBy()                   { return createdBy; }
    public void setCreatedBy(int createdBy)     { this.createdBy = createdBy; }
}
