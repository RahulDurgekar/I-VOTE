<%@ page contentType="text/html;charset=UTF-8" isErrorPage="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Error — I-VOTE</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="auth-wrap">
  <div class="auth-card" style="text-align:center;">
    <div style="font-size:48px;margin-bottom:16px;">&#9888;&#65039;</div>
    <h2 style="font-size:24px;font-weight:700;color:var(--ink);margin-bottom:8px;">Something went wrong</h2>
    <p style="color:var(--slate);margin-bottom:24px;">The page you requested could not be found or an error occurred.</p>
    <div style="display:flex;gap:12px;justify-content:center;flex-wrap:wrap;">
      <a href="${pageContext.request.contextPath}/login" class="btn btn-primary">Go to Login</a>
      <a href="${pageContext.request.contextPath}/about" class="btn btn-ghost">About I-VOTE</a>
    </div>
  </div>
</div>
</body>
</html>
