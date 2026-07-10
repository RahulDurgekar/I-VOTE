<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.ivote.model.*,java.util.*" %>
<%
    User           user     = (User)      session.getAttribute("user");
    Election       election = (Election)  request.getAttribute("election");
    List<Candidate> results = (List<Candidate>) request.getAttribute("results");
    int totalVotes = 0;
    if (results != null) for (Candidate c : results) totalVotes += c.getVoteCount();
    boolean isAdmin = user != null && user.getRole() == User.Role.ADMIN;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Results - I-VOTE</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<nav class="navbar">
    <div class="navbar-inner">
        <a class="navbar-brand" href="#">I<span class="dot">-VOTE</span></a>
        <div class="navbar-actions">
            <span class="nav-user-name"><%= user != null ? user.getName() : "" %></span>
            <% if (isAdmin) { %>
                <span class="badge badge-violet">ADMIN</span>
            <% } %>
            <a href="${pageContext.request.contextPath}/logout" class="btn btn-ghost btn-sm">Sign Out</a>
        </div>
    </div>
</nav>

<div class="page-wrap">

    <a href="${pageContext.request.contextPath}<%= isAdmin ? "/admin/dashboard" : "/dashboard" %>"
       class="btn btn-ghost btn-sm" style="margin-bottom: 20px;">
        Back to Dashboard
    </a>

    <div class="page-header">
        <h1><%= election != null ? election.getTitle() : "Election Results" %></h1>
        <% if (election != null) { %>
        <div style="display: flex; align-items: center; gap: 12px; flex-wrap: wrap; margin-top: 8px;">
            <span class="badge badge-<%= election.getStatus() %>"><%= election.getStatus() %></span>
            <span style="font-size: 14px; color: var(--slate);">
                <%= election.getInstitutionName() %>
            </span>
            <span style="font-size: 14px; color: var(--slate);">
                Total votes: <strong><%= totalVotes %></strong>
            </span>
        </div>
        <% } %>
    </div>

    <div class="card" style="max-width: 680px;">
        <div class="card-title">Vote Tally</div>
        <div class="card-subtitle">Candidates ranked by vote count.</div>

        <% if (results == null || results.isEmpty()) { %>
            <p style="color: var(--slate);">No votes have been cast yet.</p>
        <% } else { %>
        <div class="results-list">
            <% boolean first = true; for (Candidate c : results) { %>
            <div class="result-item">
                <div class="result-header">
                    <span class="result-name">
                        <% if (c.getProfilePic() != null && c.getProfilePic().length > 0) { %>
                            <img src="${pageContext.request.contextPath}/candidatePhoto?id=<%= c.getId() %>"
                                 style="width: 32px; height: 32px; border-radius: 50%; object-fit: cover;"
                                 alt="">
                        <% } else { %>
                            <span style="width: 32px; height: 32px; border-radius: 50%;
                                         background: var(--violet); color: #fff;
                                         display: inline-flex; align-items: center;
                                         justify-content: center; font-size: 13px;
                                         font-weight: 700; flex-shrink: 0;">
                                <%= c.getUserName().charAt(0) %>
                            </span>
                        <% } %>
                        <%= c.getUserName() %>
                        <% if (first && totalVotes > 0) { %>
                            <span class="winner-badge">
                                <%= election != null && election.getStatus() == Election.Status.CLOSED
                                    ? "Winner" : "Leading" %>
                            </span>
                        <% } %>
                    </span>
                    <span class="result-votes">
                        <%= c.getVoteCount() %> vote<%= c.getVoteCount() != 1 ? "s" : "" %>
                        <% if (totalVotes > 0) { %>
                            (<%= String.format("%.1f", c.getVoteCount() * 100.0 / totalVotes) %>%)
                        <% } %>
                    </span>
                </div>
                <div class="result-bar-track">
                    <div class="result-bar-fill"
                         style="width: <%= totalVotes > 0 ? (c.getVoteCount() * 100 / totalVotes) : 0 %>%;">
                    </div>
                </div>
                <% if (c.getManifesto() != null && !c.getManifesto().isBlank()) { %>
                    <p style="font-size: 13px; color: var(--slate); margin-top: 2px;">
                        <%= c.getManifesto() %>
                    </p>
                <% } %>
            </div>
            <% first = false; } %>
        </div>
        <% } %>
    </div>

</div>

<footer>
    <div class="footer-inner">
        <div class="footer-brand">I<span>-VOTE</span></div>
        <p class="footer-copy">&copy; 2025 I-VOTE. All rights reserved.</p>
    </div>
</footer>

</body>
</html>
