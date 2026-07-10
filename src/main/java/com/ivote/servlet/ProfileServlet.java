package com.ivote.servlet;

import com.ivote.dao.UserDAO;
import com.ivote.dao.impl.UserDAOImpl;
import com.ivote.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet({"/profile", "/profile/*"})
@MultipartConfig(maxFileSize = 2 * 1024 * 1024)
public class ProfileServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAOImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        User user = requireLogin(req, resp);
        if (user == null) return;

        String path = req.getPathInfo();
        if ("/photo".equals(path)) {
            servePhoto(resp, user);
        } else {
            req.getRequestDispatcher("/profile.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        User user = requireLogin(req, resp);
        if (user == null) return;

        String action = req.getParameter("action");
        if (action == null) action = "";

        switch (action) {
            case "updateInfo":       handleUpdateInfo(req, resp, user);       break;
            case "updatePhone":      handleUpdatePhone(req, resp, user);      break;
            case "updateUniversity": handleUpdateUniversity(req, resp, user); break;
            case "uploadPic":        handleUploadPic(req, resp, user);        break;
            default:                 resp.sendRedirect(req.getContextPath() + "/profile");
        }
    }

    private void handleUpdateInfo(HttpServletRequest req, HttpServletResponse resp, User user)
            throws IOException, ServletException {
        String name  = req.getParameter("name");
        String email = req.getParameter("email");

        if (name == null || email == null || name.isBlank() || email.isBlank()) {
            req.setAttribute("error", "Name and email are required.");
            req.getRequestDispatcher("/profile.jsp").forward(req, resp);
            return;
        }
        if (!email.equalsIgnoreCase(user.getEmail()) && userDAO.emailExists(email.trim())) {
            req.setAttribute("error", "That email is already in use by another account.");
            req.getRequestDispatcher("/profile.jsp").forward(req, resp);
            return;
        }
        userDAO.updateProfile(user.getId(), name.trim(), email.trim());
        refreshSession(req, user.getId());
        resp.sendRedirect(req.getContextPath() + "/profile?updated=true");
    }

    private void handleUpdatePhone(HttpServletRequest req, HttpServletResponse resp, User user)
            throws IOException, ServletException {
        String phone = req.getParameter("phone");

        if (phone == null || phone.isBlank()) {
            req.setAttribute("error", "Phone number is required.");
            req.getRequestDispatcher("/profile.jsp").forward(req, resp);
            return;
        }
        phone = phone.trim();
        if (!phone.matches("[0-9]{10,15}")) {
            req.setAttribute("error", "Enter a valid phone number (10 to 15 digits).");
            req.getRequestDispatcher("/profile.jsp").forward(req, resp);
            return;
        }
        if (userDAO.phoneExistsForOther(phone, user.getId())) {
            req.setAttribute("error", "That phone number is already registered to another account.");
            req.getRequestDispatcher("/profile.jsp").forward(req, resp);
            return;
        }
        userDAO.updatePhone(user.getId(), phone);
        refreshSession(req, user.getId());
        resp.sendRedirect(req.getContextPath() + "/profile?updated=true");
    }

    private void handleUpdateUniversity(HttpServletRequest req, HttpServletResponse resp, User user)
            throws IOException, ServletException {
        String uniName     = req.getParameter("universityName");
        String uniLocation = req.getParameter("universityLocation");

        if (uniName == null || uniName.isBlank()) {
            req.setAttribute("error", "University name cannot be empty.");
            req.getRequestDispatcher("/profile.jsp").forward(req, resp);
            return;
        }
        userDAO.updateUniversity(user.getId(), uniName.trim(),
                uniLocation != null ? uniLocation.trim() : "");
        refreshSession(req, user.getId());
        resp.sendRedirect(req.getContextPath() + "/profile?updated=true");
    }

    private void handleUploadPic(HttpServletRequest req, HttpServletResponse resp, User user)
            throws IOException, ServletException {
        Part part = req.getPart("photo");
        if (part != null && part.getSize() > 0) {
            byte[] bytes = part.getInputStream().readAllBytes();
            userDAO.updateProfilePic(user.getId(), bytes);
            refreshSession(req, user.getId());
        }
        resp.sendRedirect(req.getContextPath() + "/profile?updated=true");
    }

    private void servePhoto(HttpServletResponse resp, User user) throws IOException {
        byte[] pic = user.getProfilePic();
        if (pic == null || pic.length == 0) {
            resp.sendError(404);
            return;
        }
        resp.setContentType("image/jpeg");
        resp.getOutputStream().write(pic);
    }

    private void refreshSession(HttpServletRequest req, int userId) {
        User updated = userDAO.findById(userId);
        if (updated != null) req.getSession().setAttribute("user", updated);
    }

    private User requireLogin(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return null;
        }
        return (User) session.getAttribute("user");
    }
}
