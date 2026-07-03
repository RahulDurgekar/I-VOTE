package com.ivote.controller;

import com.ivote.dao.*;
import com.ivote.dao.impl.*;
import com.ivote.model.*;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

/**
 * Central hub for logged-in users.
 * GET  /dashboard          — shows search form + joined elections
 * POST /dashboard/search   — search election by code
 * POST /dashboard/join     — join as VOTER or CANDIDATE
 * POST /dashboard/vote     — cast a vote
 */
@WebServlet("/dashboard/*")
@MultipartConfig(maxFileSize = 2 * 1024 * 1024)
public class DashboardServlet extends HttpServlet {

    private final ElectionDAO electionDAO     = new ElectionDAOImpl();
    private final CandidateDAO candidateDAO   = new CandidateDAOImpl();
    private final VoteDAO voteDAO             = new VoteDAOImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        User user = requireUser(req, resp);
        if (user == null) return;

        String path = req.getPathInfo();
        if (path == null || path.equals("/")) path = "/home";

        switch (path) {
            case "/home" -> {
                req.getRequestDispatcher("/WEB-INF/views/dashboard.jsp").forward(req, resp);
            }
            case "/election" -> {
                String code = req.getParameter("code");
                if (code == null || code.isBlank()) {
                    resp.sendRedirect(req.getContextPath() + "/dashboard/home");
                    return;
                }
                Election election = electionDAO.findByCode(code.trim().toUpperCase());
                if (election == null) {
                    req.setAttribute("searchError", "No election found with that code.");
                    req.getRequestDispatcher("/WEB-INF/views/dashboard.jsp").forward(req, resp);
                    return;
                }
                req.setAttribute("election", election);
                req.setAttribute("candidates", candidateDAO.getCandidatesByElection(election.getId()));
                req.setAttribute("results", voteDAO.getResults(election.getId()));
                req.setAttribute("hasVoted", voteDAO.hasVoted(user.getId(), election.getId()));
                req.setAttribute("hasPhoneVoted", voteDAO.hasPhoneVoted(user.getPhone(), election.getId()));
                req.setAttribute("isCandidate", candidateDAO.isAlreadyRegistered(user.getId(), election.getId()));
                req.getRequestDispatcher("/WEB-INF/views/election-detail.jsp").forward(req, resp);
            }
            case "/results" -> {
                String idParam = req.getParameter("electionId");
                if (idParam == null) { resp.sendRedirect(req.getContextPath() + "/dashboard/home"); return; }
                int electionId = Integer.parseInt(idParam);
                req.setAttribute("election", electionDAO.findById(electionId));
                req.setAttribute("results", voteDAO.getResults(electionId));
                req.getRequestDispatcher("/WEB-INF/views/results.jsp").forward(req, resp);
            }
            default -> resp.sendRedirect(req.getContextPath() + "/dashboard/home");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        User user = requireUser(req, resp);
        if (user == null) return;

        String action = req.getParameter("action");
        if (action == null) { resp.sendRedirect(req.getContextPath() + "/dashboard/home"); return; }

        switch (action) {
            case "joinCandidate" -> handleJoinCandidate(req, resp, user);
            case "vote"          -> handleVote(req, resp, user);
            default              -> resp.sendRedirect(req.getContextPath() + "/dashboard/home");
        }
    }

    private void handleJoinCandidate(HttpServletRequest req, HttpServletResponse resp, User user)
            throws IOException, ServletException {
        String electionCode = req.getParameter("electionCode");
        String manifesto    = req.getParameter("manifesto");
        Election election   = electionDAO.findByCode(electionCode);

        if (election == null) { resp.sendRedirect(req.getContextPath() + "/dashboard/home"); return; }
        if (election.getStatus() != Election.Status.UPCOMING) {
            resp.sendRedirect(req.getContextPath() + "/dashboard/election?code=" + electionCode + "&error=reg_closed");
            return;
        }
        if (candidateDAO.isAlreadyRegistered(user.getId(), election.getId())) {
            resp.sendRedirect(req.getContextPath() + "/dashboard/election?code=" + electionCode + "&error=already_candidate");
            return;
        }

        byte[] pic = null;
        try {
            Part part = req.getPart("profilePic");
            if (part != null && part.getSize() > 0) {
                pic = part.getInputStream().readAllBytes();
            }
        } catch (Exception ignored) {}

        Candidate candidate = new Candidate();
        candidate.setUserId(user.getId());
        candidate.setElectionId(election.getId());
        candidate.setManifesto(manifesto != null ? manifesto.trim() : "");
        candidate.setProfilePic(pic);
        candidateDAO.register(candidate);

        resp.sendRedirect(req.getContextPath() + "/dashboard/election?code=" + electionCode + "&joined=candidate");
    }

    private void handleVote(HttpServletRequest req, HttpServletResponse resp, User user)
            throws IOException {
        String electionCode     = req.getParameter("electionCode");
        String candidateIdParam = req.getParameter("candidateId");
        if (electionCode == null || candidateIdParam == null) {
            resp.sendRedirect(req.getContextPath() + "/dashboard/home");
            return;
        }

        Election election = electionDAO.findByCode(electionCode);
        if (election == null || election.getStatus() != Election.Status.ACTIVE) {
            resp.sendRedirect(req.getContextPath() + "/dashboard/election?code=" + electionCode + "&error=not_active");
            return;
        }
        if (voteDAO.hasVoted(user.getId(), election.getId())) {
            resp.sendRedirect(req.getContextPath() + "/dashboard/election?code=" + electionCode + "&error=already_voted");
            return;
        }
        if (voteDAO.hasPhoneVoted(user.getPhone(), election.getId())) {
            resp.sendRedirect(req.getContextPath() + "/dashboard/election?code=" + electionCode + "&error=phone_voted");
            return;
        }

        Vote vote = new Vote();
        vote.setVoterId(user.getId());
        vote.setCandidateId(Integer.parseInt(candidateIdParam));
        vote.setElectionId(election.getId());
        vote.setVoterPhone(user.getPhone());
        voteDAO.castVote(vote);

        resp.sendRedirect(req.getContextPath() + "/dashboard/election?code=" + electionCode + "&voted=true");
    }

    private User requireUser(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return null;
        }
        User user = (User) session.getAttribute("user");
        if (user.getRole() == User.Role.ADMIN) {
            resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
            return null;
        }
        return user;
    }
}
