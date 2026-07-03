<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.ivote.model.*,java.util.*" %>
<%
    User admin = (User) session.getAttribute("user");
    List<Election> elections = (List<Election>) request.getAttribute("elections");
    long activeCount   = elections != null ? elections.stream().filter(e -> e.getStatus() == Election.Status.ACTIVE).count() : 0;
    long upcomingCount = elections != null ? elections.stream().filter(e -> e.getStatus() == Election.Status.UPCOMING).count() : 0;
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Admin Dashboard — I-VOTE</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<nav class="navbar">
  <div class="navbar-inner">
    <a class="navbar-brand" href="#">I<span class="dot">-VOTE</span></a>
    <div class="navbar-links">
      <a href="${pageContext.request.contextPath}/admin/dashboard">Elections</a>
    </div>
    <div class="navbar-actions">
      <span class="nav-user-name"><%= admin.getName() %></span>
      <span class="badge badge-violet">ADMIN</span>
      <a href="${pageContext.request.contextPath}/logout" class="btn btn-ghost btn-sm">Sign out</a>
    </div>
  </div>
</nav>

<div class="page-wrap">
  <div class="page-header">
    <h1>Admin Dashboard</h1>
    <p>Create and manage elections. Share election codes with participants.</p>
  </div>

  <div class="stats-grid">
    <div class="stat-card">
      <div class="stat-number"><%= elections != null ? elections.size() : 0 %></div>
      <div class="stat-label">Total Elections</div>
    </div>
    <div class="stat-card">
      <div class="stat-number"><%= activeCount %></div>
      <div class="stat-label">Active</div>
    </div>
    <div class="stat-card">
      <div class="stat-number"><%= upcomingCount %></div>
      <div class="stat-label">Upcoming</div>
    </div>
    <div class="stat-card">
      <div class="stat-number"><%= elections != null ? elections.size() - activeCount - upcomingCount : 0 %></div>
      <div class="stat-label">Closed</div>
    </div>
  </div>

  <% if (request.getAttribute("error") != null) { %>
    <div class="alert alert-error">&#9888; <%= request.getAttribute("error") %></div>
  <% } %>

  <div class="section-header">
    <span class="section-title">Elections</span>
    <button class="btn btn-primary"
            onclick="document.getElementById('createModal').classList.add('active')">+ New Election</button>
  </div>

  <% if (elections == null || elections.isEmpty()) { %>
    <div class="card" style="text-align:center;padding:48px;color:var(--slate);">
      No elections yet. Create your first election.
    </div>
  <% } else { %>
  <div class="elections-grid">
    <% for (Election e : elections) { %>
    <div class="election-card">
      <div class="election-card-header">
        <span class="election-title"><%= e.getTitle() %></span>
        <span class="badge badge-<%= e.getStatus() %>"><%= e.getStatus() %></span>
      </div>
      <p style="font-size:13px;color:var(--violet);font-weight:500;">&#127979; <%= e.getInstitutionName() %></p>
      <p class="election-desc"><%= e.getDescription() != null ? e.getDescription() : "" %></p>
      <div class="election-meta">
        <span>&#128197; Start: <%= e.getStartTime() %></span>
        <span>&#128197; End: &nbsp;&nbsp;<%= e.getEndTime() %></span>
      </div>
      <div>Code: <span class="election-code"><%= e.getElectionCode() %></span></div>
      <div class="election-actions">
        <% if (e.getStatus() == Election.Status.UPCOMING) { %>
          <form method="post" action="${pageContext.request.contextPath}/admin/dashboard" style="display:inline">
            <input type="hidden" name="action" value="updateStatus">
            <input type="hidden" name="electionId" value="<%= e.getId() %>">
            <input type="hidden" name="status" value="ACTIVE">
            <button class="btn btn-primary btn-sm" type="submit">Activate</button>
          </form>
        <% } else if (e.getStatus() == Election.Status.ACTIVE) { %>
          <form method="post" action="${pageContext.request.contextPath}/admin/dashboard" style="display:inline">
            <input type="hidden" name="action" value="updateStatus">
            <input type="hidden" name="electionId" value="<%= e.getId() %>">
            <input type="hidden" name="status" value="CLOSED">
            <button class="btn btn-ghost btn-sm" type="submit">Close</button>
          </form>
        <% } %>
        <a href="${pageContext.request.contextPath}/admin/results?electionId=<%= e.getId() %>"
           class="btn btn-outline-violet btn-sm">Results</a>
        <form method="post" action="${pageContext.request.contextPath}/admin/dashboard" style="display:inline"
              onsubmit="return confirm('Delete this election? This cannot be undone.')">
          <input type="hidden" name="action" value="delete">
          <input type="hidden" name="electionId" value="<%= e.getId() %>">
          <button class="btn btn-danger btn-sm" type="submit">Delete</button>
        </form>
      </div>
    </div>
    <% } %>
  </div>
  <% } %>
</div>

<%-- CREATE ELECTION MODAL --%>
<div class="modal-overlay" id="createModal"
     onclick="if(event.target===this)this.classList.remove('active')">
  <div class="modal">
    <h3 class="modal-title">Create New Election</h3>
    <form method="post" action="${pageContext.request.contextPath}/admin/dashboard">
      <input type="hidden" name="action" value="create">
      <div class="form-group">
        <label class="form-label">Election Title *</label>
        <input type="text" name="title" class="form-control"
               placeholder="Student Council Election 2025" required>
      </div>
      <div class="form-group">
        <label class="form-label">Institution Name *</label>
        <input type="text" name="institutionName" class="form-control"
               placeholder="ABC University" required>
      </div>
      <div class="form-group">
        <label class="form-label">Description</label>
        <textarea name="description" class="form-control" rows="3"
                  placeholder="Brief description..."></textarea>
      </div>
      <div class="form-row">
        <div class="form-group">
          <label class="form-label">Start Date &amp; Time</label>
          <input type="datetime-local" name="startTime" class="form-control">
        </div>
        <div class="form-group">
          <label class="form-label">End Date &amp; Time</label>
          <input type="datetime-local" name="endTime" class="form-control">
        </div>
      </div>
      <div class="modal-actions">
        <button type="button" class="btn btn-ghost"
                onclick="document.getElementById('createModal').classList.remove('active')">Cancel</button>
        <button type="submit" class="btn btn-primary">Create Election</button>
      </div>
    </form>
  </div>
</div>

</body>
</html>
