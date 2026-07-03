<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.ivote.model.User" %>
<%
    User user = (User) (session != null ? session.getAttribute("user") : null);
    boolean loggedIn = user != null;
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>About Us — I-VOTE</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<nav class="navbar">
  <div class="navbar-inner">
    <a class="navbar-brand" href="${pageContext.request.contextPath}<%= loggedIn ? "/dashboard/home" : "/login" %>">I<span class="dot">-VOTE</span></a>
    <div class="navbar-links">
      <% if (loggedIn) { %>
        <a href="${pageContext.request.contextPath}/dashboard/home">Dashboard</a>
      <% } %>
      <a href="${pageContext.request.contextPath}/about">About</a>
      <a href="${pageContext.request.contextPath}/contact">Contact</a>
    </div>
    <div class="navbar-actions">
      <% if (loggedIn) { %>
        <span class="nav-user-name"><%= user.getName() %></span>
        <a href="${pageContext.request.contextPath}/logout" class="btn btn-ghost btn-sm">Sign out</a>
      <% } else { %>
        <a href="${pageContext.request.contextPath}/login" class="btn btn-ghost btn-sm">Sign in</a>
        <a href="${pageContext.request.contextPath}/register" class="btn btn-primary btn-sm">Register</a>
      <% } %>
    </div>
  </div>
</nav>

<div class="page-wrap">

  <div class="hero-section" style="padding-top:40px;">
    <h1>Secure. Transparent. <span style="color:var(--violet);">Democratic.</span></h1>
    <p>I-VOTE is a modern online voting platform built for educational institutions to conduct fair, secure, and efficient elections.</p>
  </div>

  <div class="features-grid">
    <div class="feature-card">
      <div class="feature-icon">&#128274;</div>
      <div class="feature-title">Secure Voting</div>
      <div class="feature-desc">Every vote is tied to a unique user account and phone number, ensuring one person can only vote once per election.</div>
    </div>
    <div class="feature-card">
      <div class="feature-icon">&#128273;</div>
      <div class="feature-title">Election Codes</div>
      <div class="feature-desc">Admins generate unique election codes. Only users with the code can participate, keeping elections private to their institution.</div>
    </div>
    <div class="feature-card">
      <div class="feature-icon">&#128202;</div>
      <div class="feature-title">Real-time Results</div>
      <div class="feature-desc">Vote counts update in real time. Transparent results are visible to all participants with live progress bars.</div>
    </div>
    <div class="feature-card">
      <div class="feature-icon">&#127942;</div>
      <div class="feature-title">Candidate Profiles</div>
      <div class="feature-desc">Candidates can register with a profile photo and manifesto, giving voters the information they need to decide.</div>
    </div>
    <div class="feature-card">
      <div class="feature-icon">&#127979;</div>
      <div class="feature-title">Institution Focused</div>
      <div class="feature-desc">Each election is linked to an institution. Admins manage the entire lifecycle — from creating elections to viewing final results.</div>
    </div>
    <div class="feature-card">
      <div class="feature-icon">&#128241;</div>
      <div class="feature-title">Fully Responsive</div>
      <div class="feature-desc">Works seamlessly on desktops, tablets, and mobile phones. Vote from anywhere, anytime.</div>
    </div>
  </div>

  <hr class="divider" style="margin:48px 0 32px;">

  <div class="section-header" style="justify-content:center;flex-direction:column;text-align:center;gap:8px;">
    <span class="section-title" style="font-size:24px;">Meet the Team</span>
    <p style="color:var(--slate);font-size:15px;">Built with passion by developers committed to fair elections.</p>
  </div>

  <div class="team-grid">
    <div class="team-card">
      <div class="team-avatar">R</div>
      <div class="team-name">Rahul</div>
      <div class="team-role">Lead Developer</div>
    </div>
    <div class="team-card">
      <div class="team-avatar">A</div>
      <div class="team-name">Admin Team</div>
      <div class="team-role">Backend &amp; DB Design</div>
    </div>
    <div class="team-card">
      <div class="team-avatar">U</div>
      <div class="team-name">UX Team</div>
      <div class="team-role">UI &amp; Frontend</div>
    </div>
  </div>

  <hr class="divider" style="margin:48px 0 32px;">

  <div style="text-align:center;">
    <h2 style="font-size:28px;font-weight:700;color:var(--ink);margin-bottom:12px;">Ready to get started?</h2>
    <p style="color:var(--slate);font-size:16px;margin-bottom:24px;">Register your account and join an election with your institution code.</p>
    <div style="display:flex;gap:12px;justify-content:center;flex-wrap:wrap;">
      <a href="${pageContext.request.contextPath}/register" class="btn btn-primary">Create Account</a>
      <a href="${pageContext.request.contextPath}/contact" class="btn btn-ghost">Contact Us</a>
    </div>
  </div>

</div>

<footer>
  <div class="footer-inner">
    <div class="footer-brand">I<span>-VOTE</span></div>
    <div class="footer-links">
      <a href="${pageContext.request.contextPath}/about">About</a>
      <a href="${pageContext.request.contextPath}/contact">Contact</a>
      <% if (loggedIn) { %><a href="${pageContext.request.contextPath}/profile">Profile</a><% } %>
    </div>
    <p class="footer-copy">&copy; 2025 I-VOTE. All rights reserved.</p>
  </div>
</footer>
</body>
</html>
