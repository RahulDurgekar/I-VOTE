<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - I-VOTE</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<div class="auth-wrap">
    <div class="auth-card" style="max-width: 500px;">

        <div class="auth-logo">
            <h1>I<span>-VOTE</span></h1>
            <p>Create your account</p>
        </div>

        <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-error"><%= request.getAttribute("error") %></div>
        <% } %>

        <form method="post" action="${pageContext.request.contextPath}/register" id="registerForm">

            <div class="form-group">
                <label class="form-label" for="name">Full Name</label>
                <input type="text" id="name" name="name" class="form-control"
                       placeholder="Enter your full name" required>
            </div>

            <div class="form-group">
                <label class="form-label" for="email">Email Address</label>
                <input type="email" id="email" name="email" class="form-control"
                       placeholder="you@example.com" required>
            </div>

            <div class="form-group">
                <label class="form-label" for="phone">Phone Number</label>
                <input type="tel" id="phone" name="phone" class="form-control"
                       placeholder="10-digit mobile number" required pattern="[0-9]{10,15}">
                <p class="form-hint">Used to prevent duplicate votes in the same election.</p>
            </div>

            <div class="form-group">
                <label class="form-label" for="role">Register As</label>
                <select id="role" name="role" class="form-control" required
                        onchange="toggleUniversityFields()">
                    <option value="">-- Select your role --</option>
                    <option value="USER">User (Voter or Candidate)</option>
                    <option value="ADMIN">Admin (University or Institution)</option>
                </select>
                <p class="form-hint">
                    Select Admin if you represent a university or institution and will create elections.
                </p>
            </div>

            <div id="universityFields" style="display: none;">
                <div class="form-group">
                    <label class="form-label" for="universityName">University / Institution Name</label>
                    <input type="text" id="universityName" name="universityName" class="form-control"
                           placeholder="e.g. ABC University">
                </div>
                <div class="form-group">
                    <label class="form-label" for="universityLocation">University Location</label>
                    <input type="text" id="universityLocation" name="universityLocation" class="form-control"
                           placeholder="e.g. Bangalore, Karnataka">
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label class="form-label" for="password">Password</label>
                    <input type="password" id="password" name="password" class="form-control"
                           placeholder="Minimum 6 characters" required minlength="6">
                </div>
                <div class="form-group">
                    <label class="form-label" for="confirmPassword">Confirm Password</label>
                    <input type="password" id="confirmPassword" name="confirmPassword" class="form-control"
                           placeholder="Re-enter password" required minlength="6">
                </div>
            </div>

            <button type="submit" class="btn btn-primary"
                    style="width: 100%; justify-content: center;">
                Create Account
            </button>

        </form>

        <div class="auth-footer">
            Already have an account? <a href="${pageContext.request.contextPath}/login">Sign in</a>
        </div>

    </div>
</div>

<script>
    function toggleUniversityFields() {
        var role   = document.getElementById("role").value;
        var fields = document.getElementById("universityFields");
        var uniName = document.getElementById("universityName");

        if (role === "ADMIN") {
            fields.style.display = "block";
            uniName.required = true;
        } else {
            fields.style.display = "none";
            uniName.required = false;
        }
    }
</script>

</body>
</html>
