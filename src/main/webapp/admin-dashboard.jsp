<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.ivote.model.*,java.util.*" %>
<%
    User           admin      = (User) session.getAttribute("user");
    List<Election> elections  = (List<Election>) request.getAttribute("elections");
    long activeCount   = elections != null ? elections.stream().filter(e -> e.getStatus() == Election.Status.ACTIVE).count()   : 0;
    long upcomingCount = elections != null ? elections.stream().filter(e -> e.getStatus() == Election.Status.UPCOMING).count() : 0;
    long closedCount   = elections != null ? elections.stream().filter(e -> e.getStatus() == Election.Status.CLOSED).count()   : 0;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - I-VOTE</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<nav class="navbar">
    <div class="navbar-inner">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/admin/dashboard">
            I<span class="dot">-VOTE</span>
        </a>
        <div class="navbar-links">
            <a href="${pageContext.request.contextPath}/admin/dashboard">Elections</a>
            <a href="${pageContext.request.contextPath}/profile">My Profile</a>
        </div>
        <div class="navbar-actions">
            <span class="nav-user-name"><%= admin.getName() %></span>
            <span class="badge badge-violet">ADMIN</span>
            <a href="${pageContext.request.contextPath}/logout" class="btn btn-ghost btn-sm">Sign Out</a>
        </div>
    </div>
</nav>

<div class="page-wrap">

    <div class="page-header">
        <h1>Admin Dashboard</h1>
        <p>
            <%= admin.getUniversityName() != null ? admin.getUniversityName() : "Your Institution" %>
            <% if (admin.getUniversityLocation() != null && !admin.getUniversityLocation().isBlank()) { %>
                &mdash; <%= admin.getUniversityLocation() %>
            <% } %>
        </p>
    </div>

    <% if ("true".equals(request.getParameter("created"))) { %>
        <div class="alert alert-success">Election created successfully.</div>
    <% } %>
    <% if ("true".equals(request.getParameter("updated"))) { %>
        <div class="alert alert-success">Election updated successfully.</div>
    <% } %>
    <% if ("true".equals(request.getParameter("profileUpdated"))) { %>
        <div class="alert alert-success">University details updated successfully.</div>
    <% } %>
    <% if (request.getAttribute("error") != null) { %>
        <div class="alert alert-error"><%= request.getAttribute("error") %></div>
    <% } %>
    <% if (request.getAttribute("profileError") != null) { %>
        <div class="alert alert-error"><%= request.getAttribute("profileError") %></div>
    <% } %>

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
            <div class="stat-number"><%= closedCount %></div>
            <div class="stat-label">Closed</div>
        </div>
    </div>

    <div class="card" style="margin-bottom: 28px;">
        <div class="card-title">Institution Details</div>
        <div class="card-subtitle">
            Update your university name and location. This appears on all your elections.
        </div>
        <form method="post" action="${pageContext.request.contextPath}/admin/dashboard">
            <input type="hidden" name="action" value="updateUniversity">
            <div class="form-row">
                <div class="form-group">
                    <label class="form-label" for="uniName">University / Institution Name</label>
                    <input type="text" id="uniName" name="universityName" class="form-control"
                           value="<%= admin.getUniversityName() != null ? admin.getUniversityName() : "" %>"
                           placeholder="e.g. ABC University" required>
                </div>
                <div class="form-group">
                    <label class="form-label" for="uniLocation">Location</label>
                    <input type="text" id="uniLocation" name="universityLocation" class="form-control"
                           value="<%= admin.getUniversityLocation() != null ? admin.getUniversityLocation() : "" %>"
                           placeholder="e.g. Bangalore, Karnataka">
                </div>
            </div>
            <button type="submit" class="btn btn-primary">Save Institution Details</button>
        </form>
    </div>

    <div class="section-header">
        <span class="section-title">My Elections</span>
        <button class="btn btn-primary"
                onclick="document.getElementById('createModal').classList.add('active')">
            + New Election
        </button>
    </div>

    <% if (elections == null || elections.isEmpty()) { %>
        <div class="card" style="text-align: center; padding: 48px; color: var(--slate);">
            No elections yet. Click "New Election" to create your first one.
        </div>
    <% } else { %>
    <div class="elections-grid">
        <% for (Election e : elections) { %>
        <div class="election-card">
            <div class="election-card-header">
                <span class="election-title"><%= e.getTitle() %></span>
                <span class="badge badge-<%= e.getStatus() %>"><%= e.getStatus() %></span>
            </div>

            <p style="font-size: 13px; color: var(--violet); font-weight: 500;">
                <%= e.getInstitutionName() %>
            </p>

            <p class="election-desc">
                <%= e.getDescription() != null ? e.getDescription() : "" %>
            </p>

            <div class="election-meta">
                <span>Start: <%= e.getStartTime() %></span>
                <span>End: &nbsp;&nbsp;<%= e.getEndTime() %></span>
                <% if (e.getCandidateRegistrationDeadline() != null) { %>
                    <span>Candidate Deadline: <%= e.getCandidateRegistrationDeadline() %></span>
                <% } %>
            </div>

            <div style="display: flex; align-items: center; gap: 10px; flex-wrap: wrap; margin-top: 4px;">
                <span style="font-size: 13px; color: var(--slate);">Code:</span>
                <span class="election-code"><%= e.getElectionCode() %></span>
                <button type="button" class="btn btn-outline-violet btn-sm"
                        onclick="copyElectionMessage(
                            '<%= e.getElectionCode() %>',
                            '<%= e.getTitle().replace("'", "\\'") %>',
                            '<%= e.getInstitutionName().replace("'", "\\'") %>')">
                    Copy Invite Message
                </button>
            </div>

            <div class="election-actions">
                <% if (e.getStatus() == Election.Status.UPCOMING) { %>
                    <form method="post" action="${pageContext.request.contextPath}/admin/dashboard"
                          style="display: inline;">
                        <input type="hidden" name="action"     value="updateStatus">
                        <input type="hidden" name="electionId" value="<%= e.getId() %>">
                        <input type="hidden" name="status"     value="ACTIVE">
                        <button class="btn btn-primary btn-sm" type="submit">Activate</button>
                    </form>
                    <button class="btn btn-ghost btn-sm"
                            onclick="openEditModal(
                                <%= e.getId() %>,
                                '<%= e.getTitle().replace("'", "\\'") %>',
                                '<%= e.getDescription() != null ? e.getDescription().replace("'", "\\'") : "" %>',
                                '<%= e.getInstitutionName().replace("'", "\\'") %>',
                                '<%= e.getStartTime().toString().replace(" ", "T").substring(0, 16) %>',
                                '<%= e.getEndTime().toString().replace(" ", "T").substring(0, 16) %>',
                                '<%= e.getCandidateRegistrationDeadline() != null ? e.getCandidateRegistrationDeadline().toString().replace(" ", "T").substring(0, 16) : "" %>')">
                        Edit
                    </button>
                <% } else if (e.getStatus() == Election.Status.ACTIVE) { %>
                    <form method="post" action="${pageContext.request.contextPath}/admin/dashboard"
                          style="display: inline;">
                        <input type="hidden" name="action"     value="updateStatus">
                        <input type="hidden" name="electionId" value="<%= e.getId() %>">
                        <input type="hidden" name="status"     value="CLOSED">
                        <button class="btn btn-ghost btn-sm" type="submit">Close Election</button>
                    </form>
                <% } %>

                <a href="${pageContext.request.contextPath}/admin/results?electionId=<%= e.getId() %>"
                   class="btn btn-outline-violet btn-sm">View Results</a>

                <form method="post" action="${pageContext.request.contextPath}/admin/dashboard"
                      style="display: inline;"
                      onsubmit="return confirm('Delete this election? This cannot be undone.');">
                    <input type="hidden" name="action"     value="delete">
                    <input type="hidden" name="electionId" value="<%= e.getId() %>">
                    <button class="btn btn-danger btn-sm" type="submit">Delete</button>
                </form>
            </div>
        </div>
        <% } %>
    </div>
    <% } %>

</div>

<%-- CREATE MODAL --%>
<div class="modal-overlay" id="createModal"
     onclick="if(event.target === this) this.classList.remove('active')">
    <div class="modal">
        <h3 class="modal-title">Create New Election</h3>
        <form method="post" action="${pageContext.request.contextPath}/admin/dashboard">
            <input type="hidden" name="action" value="create">
            <div class="form-group">
                <label class="form-label">Election Title *</label>
                <input type="text" name="title" class="form-control"
                       placeholder="e.g. Student Council Election 2025" required>
            </div>
            <div class="form-group">
                <label class="form-label">Institution Name *</label>
                <input type="text" name="institutionName" class="form-control"
                       value="<%= admin.getUniversityName() != null ? admin.getUniversityName() : "" %>"
                       placeholder="e.g. ABC University" required>
            </div>
            <div class="form-group">
                <label class="form-label">Description</label>
                <textarea name="description" class="form-control" rows="3"
                          placeholder="Brief description of this election..."></textarea>
            </div>
            <div class="form-row">
                <div class="form-group">
                    <label class="form-label">Start Date and Time</label>
                    <input type="datetime-local" name="startTime" class="form-control">
                </div>
                <div class="form-group">
                    <label class="form-label">End Date and Time</label>
                    <input type="datetime-local" name="endTime" class="form-control">
                </div>
            </div>
            <div class="form-group">
                <label class="form-label">Candidate Registration Deadline</label>
                <input type="datetime-local" name="candidateDeadline" class="form-control">
                <p class="form-hint">Leave blank if there is no deadline for candidate registration.</p>
            </div>
            <div class="modal-actions">
                <button type="button" class="btn btn-ghost"
                        onclick="document.getElementById('createModal').classList.remove('active')">
                    Cancel
                </button>
                <button type="submit" class="btn btn-primary">Create Election</button>
            </div>
        </form>
    </div>
</div>

<%-- EDIT MODAL --%>
<div class="modal-overlay" id="editModal"
     onclick="if(event.target === this) this.classList.remove('active')">
    <div class="modal">
        <h3 class="modal-title">Edit Election</h3>
        <form method="post" action="${pageContext.request.contextPath}/admin/dashboard">
            <input type="hidden" name="action"     value="edit">
            <input type="hidden" name="electionId" id="editElectionId">
            <div class="form-group">
                <label class="form-label">Election Title *</label>
                <input type="text" name="title" id="editTitle" class="form-control" required>
            </div>
            <div class="form-group">
                <label class="form-label">Institution Name *</label>
                <input type="text" name="institutionName" id="editInstitution" class="form-control" required>
            </div>
            <div class="form-group">
                <label class="form-label">Description</label>
                <textarea name="description" id="editDesc" class="form-control" rows="3"></textarea>
            </div>
            <div class="form-row">
                <div class="form-group">
                    <label class="form-label">Start Date and Time</label>
                    <input type="datetime-local" name="startTime" id="editStart" class="form-control">
                </div>
                <div class="form-group">
                    <label class="form-label">End Date and Time</label>
                    <input type="datetime-local" name="endTime" id="editEnd" class="form-control">
                </div>
            </div>
            <div class="form-group">
                <label class="form-label">Candidate Registration Deadline</label>
                <input type="datetime-local" name="candidateDeadline" id="editDeadline" class="form-control">
            </div>
            <div class="modal-actions">
                <button type="button" class="btn btn-ghost"
                        onclick="document.getElementById('editModal').classList.remove('active')">
                    Cancel
                </button>
                <button type="submit" class="btn btn-primary">Save Changes</button>
            </div>
        </form>
    </div>
</div>

<div id="copyToast" style="display: none; position: fixed; bottom: 28px; right: 28px;
     background: #166534; color: #fff; padding: 12px 20px; border-radius: 10px;
     font-size: 14px; z-index: 999; box-shadow: 0 4px 16px rgba(0,0,0,0.15);">
    Invite message copied to clipboard.
</div>

<script>
    function openEditModal(id, title, desc, institution, start, end, deadline) {
        document.getElementById("editElectionId").value  = id;
        document.getElementById("editTitle").value       = title;
        document.getElementById("editDesc").value        = desc;
        document.getElementById("editInstitution").value = institution;
        document.getElementById("editStart").value       = start;
        document.getElementById("editEnd").value         = end;
        document.getElementById("editDeadline").value    = deadline;
        document.getElementById("editModal").classList.add("active");
    }

    function copyElectionMessage(code, title, institution) {
        var message = "You are invited to participate in the election:\n\n"
                    + "Election: " + title + "\n"
                    + "Institution: " + institution + "\n\n"
                    + "Use the code below to join on I-VOTE:\n\n"
                    + "Election Code: " + code + "\n\n"
                    + "Steps:\n"
                    + "1. Go to the I-VOTE website and log in or register.\n"
                    + "2. On the dashboard, enter the election code: " + code + "\n"
                    + "3. Choose to register as a Candidate or vote for a Candidate.\n\n"
                    + "Voting is secure. Each person can vote only once.";

        navigator.clipboard.writeText(message).then(function () {
            var toast = document.getElementById("copyToast");
            toast.style.display = "block";
            setTimeout(function () { toast.style.display = "none"; }, 3000);
        }).catch(function () {
            alert("Election Code: " + code + "\n\nShare this code with participants.");
        });
    }
</script>

</body>
</html>
