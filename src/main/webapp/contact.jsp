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
  <title>Contact Us — I-VOTE</title>
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

  <div class="page-header">
    <h1>Contact Us</h1>
    <p>Have a question or need support? We'd love to hear from you.</p>
  </div>

  <% if (request.getAttribute("sent") != null) { %>
    <div class="alert alert-success">&#10003; Your message has been sent! We'll get back to you shortly.</div>
  <% } %>

  <div class="contact-grid">

    <div class="contact-info">
      <div class="card">
        <div class="contact-item">
          <span class="contact-icon">&#128205;</span>
          <div>
            <h4>Address</h4>
            <p>Tap Academy, Tech Park,<br>Bangalore, Karnataka — 560001</p>
          </div>
        </div>
        <hr class="divider">
        <div class="contact-item">
          <span class="contact-icon">&#128222;</span>
          <div>
            <h4>Phone</h4>
            <p>+91 98765 43210</p>
          </div>
        </div>
        <hr class="divider">
        <div class="contact-item">
          <span class="contact-icon">&#128140;</span>
          <div>
            <h4>Email</h4>
            <p>support@ivote.in</p>
          </div>
        </div>
        <hr class="divider">
        <div class="contact-item">
          <span class="contact-icon">&#128336;</span>
          <div>
            <h4>Support Hours</h4>
            <p>Monday – Friday: 9 AM – 6 PM IST</p>
          </div>
        </div>
      </div>
    </div>

    <div class="contact-form-wrap">
      <div class="card">
        <div class="card-title">Send a Message</div>
        <div class="card-subtitle">Fill out the form and we'll respond within 24 hours.</div>
        <form method="post" action="${pageContext.request.contextPath}/contact">
          <div class="form-row">
            <div class="form-group">
              <label class="form-label" for="cname">Your Name</label>
              <input type="text" id="cname" name="name" class="form-control"
                     placeholder="John Doe" required
                     value="<%= loggedIn ? user.getName() : "" %>">
            </div>
            <div class="form-group">
              <label class="form-label" for="cemail">Email Address</label>
              <input type="email" id="cemail" name="email" class="form-control"
                     placeholder="you@example.com" required
                     value="<%= loggedIn ? user.getEmail() : "" %>">
            </div>
          </div>
          <div class="form-group">
            <label class="form-label" for="subject">Subject</label>
            <input type="text" id="subject" name="subject" class="form-control"
                   placeholder="How can we help?" required>
          </div>
          <div class="form-group">
            <label class="form-label" for="message">Message</label>
            <textarea id="message" name="message" class="form-control" rows="5"
                      placeholder="Describe your issue or question in detail..." required></textarea>
          </div>
          <button type="submit" class="btn btn-primary">Send Message &#10148;</button>
        </form>
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
      <% if (loggedIn) { %><a href="${pageContext.request.contextPath}/profile">Profile</a><% } %>
    </div>
    <p class="footer-copy">&copy; 2025 I-VOTE. All rights reserved.</p>
  </div>
</footer>
</body>
</html>
