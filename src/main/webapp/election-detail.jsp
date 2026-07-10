<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.ivote.model.*,java.util.*" %>
<%
    User            user         = (User)      session.getAttribute("user");
    Election        election     = (Election)  request.getAttribute("election");
    List<Candidate> candidates   = (List<Candidate>) request.getAttribute("candidates");
    List<Candidate> results      = (List<Candidate>) request.getAttribute("results");
    Boolean hasVoted      = (Boolean) request.getAttribute("hasVoted");
    Boolean hasPhoneVoted = (Boolean) request.getAttribute("hasPhoneVoted");
    Boolean isCandidate   = (Boolean) request.getAttribute("isCandidate");
    boolean voted   = Boolean.TRUE.equals(hasVoted) || Boolean.TRUE.equals(hasPhoneVoted);
    char    initial = user.getName().charAt(0);
    boolean hasPic  = user.getProfilePic() != null && user.getProfilePic().length > 0;
    String  code    = election != null ? election.getElectionCode() : "";
    int totalVotes  = 0;
    if (results != null) for (Candidate c : results) totalVotes += c.getVoteCount();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= election != null ? election.getTitle() : "Election" %> - I-VOTE</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<nav class="navbar">
    <div class="navbar-inner">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/dashboard/home">
            I<span class="dot">-VOTE</span>
        </a>
        <div class="navbar-links">
            <a href="${pageContext.request.contextPath}/dashboard/home">Dashboard</a>
            <a href="${pageContext.request.contextPath}/about">About</a>
            <a href="${pageContext.request.contextPath}/contact">Contact</a>
        </div>
        <div class="navbar-actions">
            <span class="nav-user-name"><%= user.getName() %></span>
            <a href="${pageContext.request.contextPath}/profile">
                <% if (hasPic) { %>
                    <img src="${pageContext.request.contextPath}/profile/photo"
                         class="avatar-sm" alt="avatar">
                <% } else { %>
                    <div class="avatar-placeholder"><%= initial %></div>
                <% } %>
            </a>
            <a href="${pageContext.request.contextPath}/logout" class="btn btn-ghost btn-sm">Sign Out</a>
        </div>
    </div>
</nav>

<div class="page-wrap">

    <a href="${pageContext.request.contextPath}/dashboard/home"
       class="btn btn-ghost btn-sm" style="margin-bottom: 20px;">
        Back to Dashboard
    </a>

    <% if (election == null) { %>
        <div class="alert alert-error">Election not found.</div>
    <% } else { %>

    <div class="card" style="margin-bottom: 24px;">
        <div style="display: flex; justify-content: space-between; align-items: flex-start;
                    flex-wrap: wrap; gap: 12px;">
            <div style="display: flex; flex-direction: column; gap: 6px;">
                <div style="display: flex; align-items: center; gap: 12px; flex-wrap: wrap;">
                    <h1 style="font-size: 24px; font-weight: 700; color: var(--ink);">
                        <%= election.getTitle() %>
                    </h1>
                    <span class="badge badge-<%= election.getStatus() %>">
                        <%= election.getStatus() %>
                    </span>
                </div>
                <p style="font-size: 14px; color: var(--slate);">
                    <%= election.getDescription() != null ? election.getDescription() : "" %>
                </p>
                <div style="display: flex; gap: 20px; flex-wrap: wrap; font-size: 13px;
                            color: var(--steel); margin-top: 4px;">
                    <span><%= election.getInstitutionName() %></span>
                    <span>Start: <%= election.getStartTime() %></span>
                    <span>End: <%= election.getEndTime() %></span>
                    <% if (election.getCandidateRegistrationDeadline() != null) { %>
                        <span>Candidate Deadline: <%= election.getCandidateRegistrationDeadline() %></span>
                    <% } %>
                </div>
            </div>
            <div style="display: flex; flex-direction: column; align-items: flex-end; gap: 6px;">
                <span style="font-size: 12px; color: var(--steel);">Election Code</span>
                <span class="election-code"><%= code %></span>
            </div>
        </div>
    </div>

    <% if ("true".equals(request.getParameter("voted"))) { %>
        <div class="alert alert-success">Your vote has been recorded successfully.</div>
    <% } else if ("already_voted".equals(request.getParameter("error"))
               || "phone_voted".equals(request.getParameter("error"))) { %>
        <div class="alert alert-error">You have already voted in this election.</div>
    <% } else if ("not_active".equals(request.getParameter("error"))) { %>
        <div class="alert alert-error">This election is not currently active for voting.</div>
    <% } else if ("reg_closed".equals(request.getParameter("error"))) { %>
        <div class="alert alert-error">Candidate registration is closed for this election.</div>
    <% } else if ("already_candidate".equals(request.getParameter("error"))) { %>
        <div class="alert alert-info">You are already registered as a candidate in this election.</div>
    <% } else if ("candidate".equals(request.getParameter("joined"))) { %>
        <div class="alert alert-success">You are now registered as a candidate. Good luck!</div>
    <% } %>

    <div style="display: flex; gap: 24px; flex-wrap: wrap; align-items: flex-start;">

        <div style="flex: 1; min-width: 300px; display: flex; flex-direction: column; gap: 20px;">

            <div class="card">
                <div class="card-title">Cast Your Vote</div>
                <div class="card-subtitle">
                    Select a candidate below and submit your vote. You can only vote once.
                </div>

                <% if (voted) { %>
                    <div class="alert alert-info" style="margin-bottom: 0;">
                        You have already voted in this election.
                    </div>
                <% } else if (election.getStatus() == Election.Status.UPCOMING) { %>
                    <div class="alert alert-warn" style="margin-bottom: 0;">
                        Voting has not started yet. The election is upcoming.
                    </div>
                <% } else if (election.getStatus() == Election.Status.CLOSED) { %>
                    <div class="alert alert-warn" style="margin-bottom: 0;">
                        This election is closed. Voting is no longer available.
                    </div>
                <% } else if (candidates == null || candidates.isEmpty()) { %>
                    <div class="alert alert-info" style="margin-bottom: 0;">
                        No candidates have registered yet.
                    </div>
                <% } else { %>
                    <form method="post"
                          action="${pageContext.request.contextPath}/dashboard/election"
                          id="voteForm">
                        <input type="hidden" name="action"       value="vote">
                        <input type="hidden" name="electionCode" value="<%= code %>">
                        <input type="hidden" name="candidateId"  id="selectedCandidate" value="">
                        <div class="candidates-grid">
                            <% for (Candidate c : candidates) { %>
                            <div class="candidate-card"
                                 onclick="selectCandidate(<%= c.getId() %>, this)">
                                <% if (c.getProfilePic() != null && c.getProfilePic().length > 0) { %>
                                    <img src="${pageContext.request.contextPath}/candidatePhoto?id=<%= c.getId() %>"
                                         class="candidate-photo" alt="<%= c.getUserName() %>">
                                <% } else { %>
                                    <div class="candidate-photo-placeholder">
                                        <%= c.getUserName().charAt(0) %>
                                    </div>
                                <% } %>
                                <div class="candidate-name"><%= c.getUserName() %></div>
                                <div class="candidate-manifesto">
                                    <%= c.getManifesto() != null ? c.getManifesto() : "" %>
                                </div>
                                <span class="selected-mark">Selected</span>
                            </div>
                            <% } %>
                        </div>
                        <button type="submit" id="voteBtn" disabled class="btn btn-primary"
                                style="width: 100%; justify-content: center; margin-top: 20px;">
                            Submit Vote
                        </button>
                    </form>
                <% } %>
            </div>

            <% if (Boolean.TRUE.equals(isCandidate)) { %>
                <div class="card">
                    <div class="card-title">Registered as Candidate</div>
                    <div class="card-subtitle">
                        You are participating in this election as a candidate.
                    </div>
                </div>
            <% } else if (election.getStatus() == Election.Status.UPCOMING) { %>
                <div class="card">
                    <div class="card-title">Stand as Candidate</div>
                    <div class="card-subtitle">
                        Register before the election starts. Add your manifesto and a photo.
                    </div>
                    <button class="btn btn-outline-violet"
                            onclick="document.getElementById('candidateModal').classList.add('active')">
                        Register as Candidate
                    </button>
                </div>
            <% } %>

        </div>

        <div class="card" style="flex: 1; min-width: 280px;">
            <div class="card-title">
                <% if (election.getStatus() == Election.Status.CLOSED) { %>
                    Final Results
                <% } else { %>
                    Live Results
                <% } %>
            </div>
            <div class="card-subtitle">
                Total votes cast: <strong><%= totalVotes %></strong>
            </div>

            <% if (results == null || results.isEmpty()) { %>
                <p style="font-size: 14px; color: var(--slate);">No votes have been cast yet.</p>
            <% } else { %>
            <div class="results-list">
                <% boolean first = true; for (Candidate c : results) { %>
                <div class="result-item">
                    <div class="result-header">
                        <span class="result-name">
                            <% if (c.getProfilePic() != null && c.getProfilePic().length > 0) { %>
                                <img src="${pageContext.request.contextPath}/candidatePhoto?id=<%= c.getId() %>"
                                     style="width: 28px; height: 28px; border-radius: 50%; object-fit: cover;"
                                     alt="">
                            <% } else { %>
                                <span style="width: 28px; height: 28px; border-radius: 50%;
                                             background: var(--violet); color: #fff;
                                             display: inline-flex; align-items: center;
                                             justify-content: center; font-size: 12px; font-weight: 700;">
                                    <%= c.getUserName().charAt(0) %>
                                </span>
                            <% } %>
                            <%= c.getUserName() %>
                            <% if (first && totalVotes > 0) { %>
                                <span class="winner-badge">
                                    <%= election.getStatus() == Election.Status.CLOSED
                                        ? "Winner" : "Leading" %>
                                </span>
                            <% } %>
                        </span>
                        <span class="result-votes">
                            <%= c.getVoteCount() %> vote<%= c.getVoteCount() != 1 ? "s" : "" %>
                            <% if (totalVotes > 0) { %>
                                (<%= String.format("%.0f", c.getVoteCount() * 100.0 / totalVotes) %>%)
                            <% } %>
                        </span>
                    </div>
                    <div class="result-bar-track">
                        <div class="result-bar-fill"
                             style="width: <%= totalVotes > 0 ? (c.getVoteCount() * 100 / totalVotes) : 0 %>%;">
                        </div>
                    </div>
                </div>
                <% first = false; } %>
            </div>
            <% } %>
        </div>

    </div>
    <% } %>
</div>

<div class="modal-overlay" id="candidateModal"
     onclick="if(event.target === this) this.classList.remove('active')">
    <div class="modal">
        <h3 class="modal-title">Register as Candidate</h3>
        <form method="post"
              action="${pageContext.request.contextPath}/dashboard/election"
              enctype="multipart/form-data">
            <input type="hidden" name="action"       value="joinCandidate">
            <input type="hidden" name="electionCode" value="<%= code %>">
            <div class="form-group">
                <label class="form-label">Profile Photo (optional)</label>
                <input type="file" name="profilePic" class="form-control" accept="image/*">
                <p class="form-hint">Maximum 2MB. JPEG or PNG recommended.</p>
            </div>
            <div class="form-group">
                <label class="form-label">Your Manifesto *</label>
                <textarea name="manifesto" class="form-control" rows="4"
                          placeholder="Describe your goals and plans for this election..."
                          required></textarea>
            </div>
            <div class="modal-actions">
                <button type="button" class="btn btn-ghost"
                        onclick="document.getElementById('candidateModal').classList.remove('active')">
                    Cancel
                </button>
                <button type="submit" class="btn btn-primary">Register</button>
            </div>
        </form>
    </div>
</div>

<script>
    function selectCandidate(id, el) {
        document.querySelectorAll(".candidate-card").forEach(function (c) {
            c.classList.remove("selected");
        });
        el.classList.add("selected");
        document.getElementById("selectedCandidate").value = id;
        document.getElementById("voteBtn").disabled = false;
    }
</script>

</body>
</html>
