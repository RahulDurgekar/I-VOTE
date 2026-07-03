<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Register — I-VOTE</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="auth-wrap">
  <div class="auth-card" style="max-width:480px;">
    <div class="auth-logo">
      <h1>I<span>-VOTE</span></h1>
      <p>Create your account</p>
    </div>

    <% if (request.getAttribute("error") != null) { %>
      <div class="alert alert-error">&#9888; <%= request.getAttribute("error") %></div>
    <% } %>

    <form method="post" action="${pageContext.request.contextPath}/register">
      <div class="form-group">
        <label class="form-label" for="name">Full Name</label>
        <input type="text" id="name" name="name" class="form-control"
               placeholder="John Doe" required>
      </div>
      <div class="form-group">
        <label class="form-label" for="email">Email address</label>
        <input type="email" id="email" name="email" class="form-control"
               placeholder="you@example.com" required>
      </div>
      <div class="form-group">
        <label class="form-label" for="phone">Phone Number</label>
        <input type="tel" id="phone" name="phone" class="form-control"
               placeholder="9876543210" required pattern="[0-9]{10,15}">
        <p class="form-hint">Used to prevent duplicate votes in the same election.</p>
      </div>
      <div class="form-row">
        <div class="form-group">
          <label class="form-label" for="password">Password</label>
          <input type="password" id="password" name="password" class="form-control"
                 placeholder="••••••••" required minlength="6">
        </div>
        <div class="form-group">
          <label class="form-label" for="confirmPassword">Confirm Password</label>
          <input type="password" id="confirmPassword" name="confirmPassword" class="form-control"
                 placeholder="••••••••" required minlength="6">
        </div>
      </div>
      <button type="submit" class="btn btn-primary" style="width:100%;justify-content:center;">Create Account</button>
    </form>

    <div class="auth-footer">
      Already have an account? <a href="${pageContext.request.contextPath}/login">Sign in</a>
    </div>
  </div>
</div>
</body>
</html>
