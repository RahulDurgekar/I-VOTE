<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.ivote.model.User" %>
<%
    User user = (User) session.getAttribute("user");
    boolean hasPic = user != null && user.getProfilePic() != null && user.getProfilePic().length > 0;
    char initial = user != null && user.getName().length() > 0 ? Character.toUpperCase(user.getName().charAt(0)) : 'U';
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Profile — I-VOTE</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<nav class="navbar">
  <div class="navbar-inner">
    <a class="navbar-brand" href="${pageContext.request.contextPath}/dashboard/home">I<span class="dot">-VOTE</span></a>
    <div class="navbar-links">
      <a href="${pageContext.request.contextPath}/dashboard/home">Dashboard</a>
      <a href="${pageContext.request.contextPath}/about">About</a>
      <a href="${pageContext.request.contextPath}/contact">Contact</a>
    </div>
    <div class="navbar-actions">
      <a href="${pageContext.request.contextPath}/logout" class="btn btn-ghost btn-sm">Sign out</a>
    </div>
  </div>
</nav>

<div class="page-wrap">
  <div class="page-header">
    <h1>My Profile</h1>
    <p>Update your name, email, phone number, or profile photo.</p>
  </div>

  <% if ("true".equals(request.getParameter("updated"))) { %>
    <div class="alert alert-success">&#10003; Profile updated successfully.</div>
  <% } %>
  <% if (request.getAttribute("error") != null) { %>
    <div class="alert alert-error">&#9888; <%= request.getAttribute("error") %></div>
  <% } %>

  <div class="profile-wrap">

    <%-- SIDEBAR --%>
    <div class="profile-sidebar">
      <% if (hasPic) { %>
        <img src="${pageContext.request.contextPath}/profile/photo" class="profile-avatar" alt="avatar">
      <% } else { %>
        <div class="profile-avatar-placeholder"><%= initial %></div>
      <% } %>
      <div class="profile-name"><%= user.getName() %></div>
      <div class="profile-email"><%= user.getEmail() %></div>
      <div class="profile-phone">&#128222; <%= user.getPhone() %></div>
      <span class="badge badge-violet"><%= user.getRole() %></span>

      <hr class="divider" style="width:100%;margin:8px 0;">

      <%-- PHOTO UPLOAD --%>
      <form method="post" action="${pageContext.request.contextPath}/profile"
            enctype="multipart/form-data" style="width:100%;">
        <input type="hidden" name="action" value="uploadPic">
        <div class="form-group" style="margin-bottom:10px;">
          <label class="form-label" style="text-align:center;display:block;">Change Photo</label>
          <input type="file" name="photo" class="form-control" accept="image/*" required>
          <p class="form-hint">Max 2MB · JPEG or PNG</p>
        </div>
        <button type="submit" class="btn btn-outline-violet btn-sm"
                style="width:100%;justify-content:center;">Upload Photo</button>
      </form>
    </div>

    <%-- MAIN AREA --%>
    <div class="profile-main">

      <%-- NAME & EMAIL --%>
      <div class="card">
        <div class="card-title">Basic Information</div>
        <div class="card-subtitle">Update your display name and email address.</div>
        <form method="post" action="${pageContext.request.contextPath}/profile">
          <input type="hidden" name="action" value="updateInfo">
          <div class="form-row">
            <div class="form-group">
              <label class="form-label" for="name">Full Name</label>
              <input type="text" id="name" name="name" class="form-control"
                     value="<%= user.getName() %>" required>
            </div>
            <div class="form-group">
              <label class="form-label" for="email">Email Address</label>
              <input type="email" id="email" name="email" class="form-control"
                     value="<%= user.getEmail() %>" required>
            </div>
          </div>
          <button type="submit" class="btn btn-primary">Save Name &amp; Email</button>
        </form>
      </div>

      <%-- PHONE UPDATE --%>
      <div class="card">
        <div class="card-title">Phone Number</div>
        <div class="card-subtitle">
          Changing your phone number will update it across all elections you have voted in.
          Make sure the new number is unique and not registered to another account.
        </div>
        <form method="post" action="${pageContext.request.contextPath}/profile">
          <input type="hidden" name="action" value="updatePhone">
          <div class="form-group">
            <label class="form-label" for="phone">Phone Number</label>
            <input type="tel" id="phone" name="phone" class="form-control"
                   value="<%= user.getPhone() %>"
                   placeholder="10–15 digit number" required pattern="[0-9]{10,15}">
            <p class="form-hint">
              &#9888; This will also update your phone on all past votes to keep records consistent.
            </p>
          </div>
          <button type="submit" class="btn btn-primary"
                  onclick="return confirm('Changing your phone number will update it on all your past votes. Continue?');">
            Update Phone Number
          </button>
        </form>
      </div>

      <%-- ACCOUNT SUMMARY --%>
      <div class="card">
        <div class="card-title">Account Summary</div>
        <div style="display:flex;flex-direction:column;">
          <div style="display:flex;justify-content:space-between;align-items:center;
                      padding:12px 0;border-bottom:1px solid var(--fog);">
            <span style="font-size:14px;color:var(--slate);">Role</span>
            <span class="badge badge-violet"><%= user.getRole() %></span>
          </div>
          <div style="display:flex;justify-content:space-between;align-items:center;
                      padding:12px 0;border-bottom:1px solid var(--fog);">
            <span style="font-size:14px;color:var(--slate);">Phone</span>
            <span style="font-size:14px;font-weight:500;color:var(--ink);">+91 <%= user.getPhone() %></span>
          </div>
          <div style="display:flex;justify-content:space-between;align-items:center;
                      padding:12px 0;border-bottom:1px solid var(--fog);">
            <span style="font-size:14px;color:var(--slate);">Email</span>
            <span style="font-size:14px;font-weight:500;color:var(--ink);"><%= user.getEmail() %></span>
          </div>
          <div style="display:flex;justify-content:space-between;align-items:center;padding:12px 0;">
            <span style="font-size:14px;color:var(--slate);">Name</span>
            <span style="font-size:14px;font-weight:500;color:var(--ink);"><%= user.getName() %></span>
          </div>
        </div>
      </div>

    </div>
  </div>
</div>

<footer>
  <div class="footer-inner">
    <div class="footer-brand">I<span>-VOTE</span></div>
    <div class="footer-links">
      <a href="${pageContext.request.contextPath}/about">About</a>
      <a href="${pageContext.request.contextPath}/contact">Contact</a>
    </div>
    <p class="footer-copy">&copy; 2025 I-VOTE. All rights reserved.</p>
  </div>
</footer>
</body>
</html>
