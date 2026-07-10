<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.ivote.model.User" %>
<%
    User    user     = (User) session.getAttribute("user");
    String  userName = user != null ? user.getName() : "";
    char    initial  = userName.length() > 0 ? Character.toUpperCase(userName.charAt(0)) : 'U';
    boolean hasPic   = user != null && user.getProfilePic() != null && user.getProfilePic().length > 0;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - I-VOTE</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<nav class="navbar">
    <div class="navbar-inner">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/dashboard/home">
            I<span class="dot">-VOTE</span>
        </a>
        <div class="navbar-links">
            <a href="${pageContext.request.contextPath}/dashboard/home">Dashboard</a>
            <a href="${pageContext.request.contextPath}/about">About</a>
            <a href="${pageContext.request.contextPath}/contact">Contact</a>
        </div>
        <div class="navbar-actions">
            <span class="nav-user-name"><%= userName %></span>
            <a href="${pageContext.request.contextPath}/profile">
                <% if (hasPic) { %>
                    <img src="${pageContext.request.contextPath}/profile/photo"
                         class="avatar-sm" alt="avatar">
                <% } else { %>
                    <div class="avatar-placeholder"><%= initial %></div>
                <% } %>
            </a>
            <a href="${pageContext.request.contextPath}/logout" class="btn btn-ghost btn-sm">
                Sign Out
            </a>
        </div>
    </div>
</nav>

<div class="page-wrap">

    <div class="page-header"
         style="display: flex; justify-content: space-between; align-items: flex-start;
                flex-wrap: wrap; gap: 12px;">
        <div>
            <h1>Welcome, <%= userName %></h1>
            <p>Enter an election code to participate as a voter or candidate.</p>
        </div>
        <button class="btn btn-outline-violet"
                onclick="document.getElementById('howToModal').classList.add('active')">
            How to Use
        </button>
    </div>

    <% if (request.getAttribute("searchError") != null) { %>
        <div class="alert alert-error"><%= request.getAttribute("searchError") %></div>
    <% } %>

    <form action="${pageContext.request.contextPath}/dashboard/election" method="get">
        <div class="search-bar">
            <div class="form-group">
                <label class="form-label">Enter Election Code</label>
                <input type="text" name="code" class="form-control"
                       placeholder="e.g. A1B2C3D4"
                       style="text-transform: uppercase; letter-spacing: 2px;"
                       required maxlength="8">
            </div>
            <button type="submit" class="btn btn-primary">Find Election</button>
        </div>
    </form>

    <div class="features-grid" style="margin-top: 0;">
        <div class="feature-card">
            <div class="feature-title">Enter Code to Participate</div>
            <div class="feature-desc">
                Get the unique election code from your institution admin and enter it above.
            </div>
        </div>
        <div class="feature-card">
            <div class="feature-title">Register as Candidate</div>
            <div class="feature-desc">
                Once you find an election, register as a candidate with your manifesto and photo.
            </div>
        </div>
        <div class="feature-card">
            <div class="feature-title">Live Results</div>
            <div class="feature-desc">
                Track real-time vote counts and see who is leading as votes come in.
            </div>
        </div>
        <div class="feature-card">
            <div class="feature-title">One Vote Per Person</div>
            <div class="feature-desc">
                The system ensures one vote per person per election using your account and phone number.
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
            <a href="${pageContext.request.contextPath}/profile">Profile</a>
        </div>
        <p class="footer-copy">&copy; 2025 I-VOTE. All rights reserved.</p>
    </div>
</footer>

<%-- HOW TO USE MODAL --%>
<div class="modal-overlay" id="howToModal"
     onclick="if(event.target === this) this.classList.remove('active')">
    <div class="modal" style="max-width: 600px;">
        <h3 class="modal-title">How to Use I-VOTE</h3>

        <div style="display: flex; flex-direction: column; gap: 4px;">

            <div class="how-to-step">
                <div class="step-number">1</div>
                <div>
                    <strong>Register an Account</strong>
                    <p>
                        Go to the Register page. Select your role: choose User if you want to vote
                        or stand as a candidate, or choose Admin if you are an institution
                        representative who will create and manage elections.
                    </p>
                </div>
            </div>

            <div class="how-to-step">
                <div class="step-number">2</div>
                <div>
                    <strong>Admin: Create an Election</strong>
                    <p>
                        After logging in as Admin, click New Election on your dashboard.
                        Fill in the election title, institution name, start and end dates,
                        and an optional candidate registration deadline.
                        The system generates a unique 8-character election code automatically.
                    </p>
                </div>
            </div>

            <div class="how-to-step">
                <div class="step-number">3</div>
                <div>
                    <strong>Admin: Share the Election Code</strong>
                    <p>
                        On your election card, click Copy Invite Message. This copies a
                        ready-to-send message with the election code and step-by-step instructions.
                        Share it with students via WhatsApp, email, or any channel.
                    </p>
                </div>
            </div>

            <div class="how-to-step">
                <div class="step-number">4</div>
                <div>
                    <strong>User: Find the Election</strong>
                    <p>
                        Log in and enter the election code you received in the search bar above.
                        Click Find Election to open the election page.
                    </p>
                </div>
            </div>

            <div class="how-to-step">
                <div class="step-number">5</div>
                <div>
                    <strong>User: Register as Candidate or Vote</strong>
                    <p>
                        If the election is Upcoming, you can register as a candidate by clicking
                        Register as Candidate and submitting your manifesto and photo.
                        Once the election is Active, select a candidate and click Submit Vote.
                        You can only vote once per election.
                    </p>
                </div>
            </div>

            <div class="how-to-step">
                <div class="step-number">6</div>
                <div>
                    <strong>View Results</strong>
                    <p>
                        Live vote counts are visible on the election page at all times.
                        Once the admin closes the election, the final winner is announced.
                    </p>
                </div>
            </div>

        </div>

        <div class="modal-actions">
            <button type="button" class="btn btn-primary"
                    onclick="document.getElementById('howToModal').classList.remove('active')">
                Got It
            </button>
        </div>
    </div>
</div>

</body>
</html>
