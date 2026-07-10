package com.ivote.servlet;

import com.ivote.dao.ElectionDAO;
import com.ivote.dao.UserDAO;
import com.ivote.dao.VoteDAO;
import com.ivote.dao.impl.ElectionDAOImpl;
import com.ivote.dao.impl.UserDAOImpl;
import com.ivote.dao.impl.VoteDAOImpl;
import com.ivote.model.Election;
import com.ivote.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.UUID;

@WebServlet({"/admin", "/admin/*"})
public class AdminServlet extends HttpServlet {

    private final ElectionDAO electionDAO= new ElectionDAOImpl();
    private final VoteDAO voteDAO= new VoteDAOImpl();
    private final UserDAO userDAO= new UserDAOImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        if (!isAdmin(req, resp)) return;

        String path = req.getPathInfo();
        if (path == null || path.equals("/") || path.equals("/dashboard")) {
            User admin = (User) req.getSession().getAttribute("user");
            req.setAttribute("elections", electionDAO.getElectionsByAdmin(admin.getId()));
            req.getRequestDispatcher("/admin-dashboard.jsp").forward(req, resp);
            return;
        }

        if (path.equals("/results")) {
            String idParam = req.getParameter("electionId");
            if (idParam != null) {
                int eid = Integer.parseInt(idParam);
                req.setAttribute("results",  voteDAO.getResults(eid));
                req.setAttribute("election", electionDAO.findById(eid));
            }
            req.getRequestDispatcher("/results.jsp").forward(req, resp);
            return;
        }

        resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        if (!isAdmin(req, resp)) return;

        String action = req.getParameter("action");
        if (action == null) action = "";

        switch (action) {
            case "create":           handleCreate(req, resp);           break;
            case "edit":             handleEdit(req, resp);             break;
            case "updateStatus":     handleStatusUpdate(req, resp);     break;
            case "delete":           handleDelete(req, resp);           break;
            case "updateUniversity": handleUpdateUniversity(req, resp); break;
            default:                 resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
        }
    }

    private void handleCreate(HttpServletRequest req, HttpServletResponse resp)
            throws IOException, ServletException {
        String title       = req.getParameter("title");
        String desc        = req.getParameter("description");
        String institution = req.getParameter("institutionName");
        String start       = req.getParameter("startTime");
        String end         = req.getParameter("endTime");
        String deadline    = req.getParameter("candidateDeadline");

        if (title == null || title.isBlank() || institution == null || institution.isBlank()) {
            req.setAttribute("error", "Title and institution name are required.");
            User admin = (User) req.getSession().getAttribute("user");
            req.setAttribute("elections", electionDAO.getElectionsByAdmin(admin.getId()));
            req.getRequestDispatcher("/admin-dashboard.jsp").forward(req, resp);
            return;
        }

        User admin = (User) req.getSession().getAttribute("user");

        Election election = new Election();
        election.setTitle(title.trim());
        election.setDescription(desc != null ? desc.trim() : "");
        election.setInstitutionName(institution.trim());
        election.setElectionCode(UUID.randomUUID().toString().substring(0, 8).toUpperCase());
        election.setStatus(Election.Status.UPCOMING);
        election.setStartTime(parseDateTime(start, LocalDateTime.now()));
        election.setEndTime(parseDateTime(end, LocalDateTime.now().plusDays(7)));
        election.setCandidateRegistrationDeadline(
            (deadline != null && !deadline.isBlank())
                ? Timestamp.valueOf(LocalDateTime.parse(deadline))
                : null
        );
        election.setCreatedBy(admin.getId());

        electionDAO.create(election);
        resp.sendRedirect(req.getContextPath() + "/admin/dashboard?created=true");
    }

    private void handleEdit(HttpServletRequest req, HttpServletResponse resp)
            throws IOException, ServletException {
        String idParam     = req.getParameter("electionId");
        String title       = req.getParameter("title");
        String desc        = req.getParameter("description");
        String institution = req.getParameter("institutionName");
        String start       = req.getParameter("startTime");
        String end         = req.getParameter("endTime");
        String deadline    = req.getParameter("candidateDeadline");

        if (idParam == null || title == null || title.isBlank()) {
            resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
            return;
        }

        Election election = electionDAO.findById(Integer.parseInt(idParam));
        if (election == null) {
            resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
            return;
        }

        election.setTitle(title.trim());
        election.setDescription(desc != null ? desc.trim() : "");
        election.setInstitutionName(institution != null ? institution.trim() : election.getInstitutionName());
        election.setStartTime(parseDateTime(start, election.getStartTime().toLocalDateTime()));
        election.setEndTime(parseDateTime(end, election.getEndTime().toLocalDateTime()));
        election.setCandidateRegistrationDeadline(
            (deadline != null && !deadline.isBlank())
                ? Timestamp.valueOf(LocalDateTime.parse(deadline))
                : null
        );

        electionDAO.update(election);
        resp.sendRedirect(req.getContextPath() + "/admin/dashboard?updated=true");
    }

    private void handleStatusUpdate(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        int    id = Integer.parseInt(req.getParameter("electionId"));
        String st = req.getParameter("status");
        electionDAO.updateStatus(id, Election.Status.valueOf(st));
        resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
    }

    private void handleDelete(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        int id = Integer.parseInt(req.getParameter("electionId"));
        electionDAO.delete(id);
        resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
    }

    private void handleUpdateUniversity(HttpServletRequest req, HttpServletResponse resp)
            throws IOException, ServletException {
        User admin         = (User) req.getSession().getAttribute("user");
        String uniName     = req.getParameter("universityName");
        String uniLocation = req.getParameter("universityLocation");

        if (uniName == null || uniName.isBlank()) {
            req.setAttribute("profileError", "University name cannot be empty.");
            req.setAttribute("elections", electionDAO.getElectionsByAdmin(admin.getId()));
            req.getRequestDispatcher("/admin-dashboard.jsp").forward(req, resp);
            return;
        }

        userDAO.updateUniversity(admin.getId(), uniName.trim(),
                uniLocation != null ? uniLocation.trim() : "");

        User updated = userDAO.findById(admin.getId());
        if (updated != null) req.getSession().setAttribute("user", updated);

        resp.sendRedirect(req.getContextPath() + "/admin/dashboard?profileUpdated=true");
    }

    private boolean isAdmin(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return false;
        }
        User user = (User) session.getAttribute("user");
        if (user.getRole() != User.Role.ADMIN) {
            resp.sendRedirect(req.getContextPath() + "/dashboard/home");
            return false;
        }
        return true;
    }

    private Timestamp parseDateTime(String value, LocalDateTime fallback) {
        if (value != null && !value.isBlank()) {
            try {
                return Timestamp.valueOf(LocalDateTime.parse(value));
            } catch (Exception ignored) {}
        }
        return Timestamp.valueOf(fallback);
    }
}
