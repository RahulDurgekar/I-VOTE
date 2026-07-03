<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.ivote.model.User" %>
<%
    User user = (User) session.getAttribute("user");
    String userName = user != null ? user.getName() : "";
    char initial = userName.length() > 0 ? Character.toUpperCase(userName.charAt(0)) : 'U';
    boolean hasPic = user != null && user.getProfilePic() != null && user.getProfilePic().length > 0;
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Dashboard — I-VOTE</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<%-- NAVBAR --%>
<nav class="navbar">
  <div class="navbar-inner">
    <a class="navbar-brand" href="${pageContext.request.contextPath}/dashboard/home">I<span class="dot">-VOTE</span></a>
    <div class="navbar-links">
      <a href="${pageContext.request.contextPath}/dashboard/home">Dashboard</a>
      <a href="${pageContext.request.contextPath}/about">About</a>
      <a href="${pageContext.request.contextPath}/contact">Contact</a>
    </div>
    <div class="navbar-actions">
      <span class="nav-user-name"><%= userName %></span>
      <a href="${pageContext.request.contextPath}/profile">
        <% if (hasPic) { %>
          <img src="${pageContext.request.contextPath}/profile/photo" class="avatar-sm" alt="avatar">
        <% } else { %>
          <div class="avatar-placeholder"><%= initial %></div>
        <% } %>
      </a>
      <a href="${pageContext.request.contextPath}/logout" class="btn btn-ghost btn-sm">Sign out</a>
    </div>
  </div>
</nav>

<div class="page-wrap">
  <div class="page-header">
    <h1>Welcome, <%= userName %> &#128075;</h1>
    <p>Search for an election using its unique code to vote or register as a candidate.</p>
  </div>

  <%-- ALERTS --%>
  <% if (request.getAttribute("searchError") != null) { %>
    <div class="alert alert-error">&#9888; <%= request.getAttribute("searchError") %></div>
  <% } %>

  <%-- SEARCH BAR --%>
  <form action="${pageContext.request.contextPath}/dashboard/election" method="get">
    <div class="search-bar">
      <div class="form-group">
        <label class="form-label">Enter Election Code</label>
        <input type="text" name="code" class="form-control"
               placeholder="e.g. A1B2C3D4" style="text-transform:uppercase;letter-spacing:2px;"
               required maxlength="8">
      </div>
      <button type="submit" class="btn btn-primary">Search Election &#8594;</button>
    </div>
  </form>

  <%-- INFO CARDS --%>
  <div class="features-grid" style="margin-top:0;">
    <div class="feature-card">
      <div class="feature-icon">&#128273;</div>
      <div class="feature-title">Enter Code to Vote</div>
      <div class="feature-desc">Get the unique election code from your institution admin and enter it above to find your election.</div>
    </div>
    <div class="feature-card">
      <div class="feature-icon">&#127942;</div>
      <div class="feature-title">Stand as Candidate</div>
      <div class="feature-desc">Once you find an election, you can register as a candidate with your manifesto and a profile photo.</div>
    </div>
    <div class="feature-card">
      <div class="feature-icon">&#128202;</div>
      <div class="feature-title">Live Results</div>
      <div class="feature-desc">Track real-time vote counts and see who is leading as votes come in.</div>
    </div>
    <div class="feature-card">
      <div class="feature-icon">&#128274;</div>
      <div class="feature-title">One Vote Only</div>
      <div class="feature-desc">The system ensures one vote per person per election using both your account and phone number.</div>
    </div>
  </div>
</div>

<footer>
  <div class="footer-inner">
    <div class="footer-brand">I<span>-VOTE</span></div>
    <div class="footer-links">
      <a href="${pageContext.request.contextPath}/about">About</a>
      <a href="${pageContext.request.contextPath}/contact">Contact</a>
      <a href="${pageContext.request.contextPath}/profile">Profile</a>
    </div>
    <p class="footer-copy">&copy; 2025 I-VOTE. All rights reserved.</p>
  </div>
</footer>
</body>
</html>
