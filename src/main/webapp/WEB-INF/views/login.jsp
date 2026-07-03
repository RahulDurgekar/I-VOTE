<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Login — I-VOTE</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="auth-wrap">
  <div class="auth-card">
    <div class="auth-logo">
      <h1>I<span>-VOTE</span></h1>
      <p>Secure Online Voting System</p>
    </div>

    <% if (request.getParameter("registered") != null) { %>
      <div class="alert alert-success">&#10003; Registration successful! Please sign in.</div>
    <% } %>
    <% if (request.getAttribute("error") != null) { %>
      <div class="alert alert-error">&#9888; <%= request.getAttribute("error") %></div>
    <% } %>

    <form method="post" action="${pageContext.request.contextPath}/login">
      <div class="form-group">
        <label class="form-label" for="email">Email address</label>
        <input type="email" id="email" name="email" class="form-control"
               placeholder="you@example.com" required autocomplete="email">
      </div>
      <div class="form-group">
        <label class="form-label" for="password">Password</label>
        <input type="password" id="password" name="password" class="form-control"
               placeholder="••••••••" required autocomplete="current-password">
      </div>
      <button type="submit" class="btn btn-primary" style="width:100%;justify-content:center;">Sign in</button>
    </form>

    <div class="auth-footer">
      Don't have an account? <a href="${pageContext.request.contextPath}/register">Register</a>
    </div>
  </div>
</div>
</body>
</html>
