package com.ivote.controller;

import com.ivote.dao.ElectionDAO;
import com.ivote.dao.VoteDAO;
import com.ivote.dao.impl.ElectionDAOImpl;
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

@WebServlet("/admin/*")
public class AdminServlet extends HttpServlet {

    private final ElectionDAO electionDAO = new ElectionDAOImpl();
    private final VoteDAO voteDAO         = new VoteDAOImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        if (!isAdmin(req, resp)) return;

        String path = req.getPathInfo();
        if (path == null) path = "/dashboard";

        switch (path) {
            case "/dashboard" -> {
                req.setAttribute("elections", electionDAO.getAllElections());
                req.getRequestDispatcher("/WEB-INF/views/admin-dashboard.jsp").forward(req, resp);
            }
            case "/results" -> {
                String idParam = req.getParameter("electionId");
                if (idParam != null) {
                    int eid = Integer.parseInt(idParam);
                    req.setAttribute("results", voteDAO.getResults(eid));
                    req.setAttribute("election", electionDAO.findById(eid));
                }
                req.getRequestDispatcher("/WEB-INF/views/results.jsp").forward(req, resp);
            }
            default -> resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        if (!isAdmin(req, resp)) return;

        String action = req.getParameter("action");
        switch (action != null ? action : "") {
            case "create"       -> handleCreate(req, resp);
            case "updateStatus" -> handleStatusUpdate(req, resp);
            case "delete"       -> handleDelete(req, resp);
            default             -> resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
        }
    }

    private void handleCreate(HttpServletRequest req, HttpServletResponse resp)
            throws IOException, ServletException {
        String title       = req.getParameter("title");
        String desc        = req.getParameter("description");
        String institution = req.getParameter("institutionName");
        String start       = req.getParameter("startTime");
        String end         = req.getParameter("endTime");

        if (title == null || title.isBlank() || institution == null || institution.isBlank()) {
            req.setAttribute("error", "Title and institution name are required.");
            req.setAttribute("elections", electionDAO.getAllElections());
            req.getRequestDispatcher("/WEB-INF/views/admin-dashboard.jsp").forward(req, resp);
            return;
        }

        User admin = (User) req.getSession().getAttribute("user");
        Election election = new Election();
        election.setTitle(title.trim());
        election.setDescription(desc != null ? desc.trim() : "");
        election.setInstitutionName(institution.trim());
        election.setElectionCode(UUID.randomUUID().toString().substring(0, 8).toUpperCase());
        election.setStatus(Election.Status.UPCOMING);
        election.setStartTime(start != null && !start.isBlank()
            ? Timestamp.valueOf(LocalDateTime.parse(start)) : Timestamp.valueOf(LocalDateTime.now()));
        election.setEndTime(end != null && !end.isBlank()
            ? Timestamp.valueOf(LocalDateTime.parse(end)) : Timestamp.valueOf(LocalDateTime.now().plusDays(7)));
        election.setCreatedBy(admin.getId());

        electionDAO.create(election);
        resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
    }

    private void handleStatusUpdate(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        int id     = Integer.parseInt(req.getParameter("electionId"));
        String st  = req.getParameter("status");
        electionDAO.updateStatus(id, Election.Status.valueOf(st));
        resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
    }

    private void handleDelete(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        int id = Integer.parseInt(req.getParameter("electionId"));
        electionDAO.delete(id);
        resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
    }

    private boolean isAdmin(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return false;
        }
        User user = (User) session.getAttribute("user");
        if (user.getRole() != User.Role.ADMIN) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return false;
        }
        return true;
    }
}
