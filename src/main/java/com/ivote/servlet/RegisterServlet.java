package com.ivote.servlet;

import com.ivote.dao.UserDAO;
import com.ivote.dao.impl.UserDAOImpl;
import com.ivote.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAOImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/register.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String name     = req.getParameter("name");
        String email    = req.getParameter("email");
        String phone    = req.getParameter("phone");
        String password = req.getParameter("password");
        String confirm  = req.getParameter("confirmPassword");
        String roleStr  = req.getParameter("role");

        if (name == null || email == null || phone == null || password == null || roleStr == null
                || name.isBlank() || email.isBlank() || phone.isBlank()
                || password.isBlank() || roleStr.isBlank()) {
            req.setAttribute("error", "All fields are required.");
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
            return;
        }

        if (!password.equals(confirm)) {
            req.setAttribute("error", "Passwords do not match.");
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
            return;
        }

        if (!phone.trim().matches("[0-9]{10,15}")) {
            req.setAttribute("error", "Phone number must be 10 to 15 digits.");
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
            return;
        }

        if (userDAO.emailExists(email.trim())) {
            req.setAttribute("error", "This email is already registered.");
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
            return;
        }

        if (userDAO.phoneExists(phone.trim())) {
            req.setAttribute("error", "This phone number is already registered.");
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
            return;
        }

        User.Role role;
        try {
            role = User.Role.valueOf(roleStr.toUpperCase());
        } catch (IllegalArgumentException ex) {
            req.setAttribute("error", "Invalid role selected.");
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
            return;
        }

        String universityName     = null;
        String universityLocation = null;
        if (role == User.Role.ADMIN) {
            universityName     = req.getParameter("universityName");
            universityLocation = req.getParameter("universityLocation");
            if (universityName == null || universityName.isBlank()) {
                req.setAttribute("error", "University name is required for Admin registration.");
                req.getRequestDispatcher("/register.jsp").forward(req, resp);
                return;
            }
        }

        User user = new User();
        user.setName(name.trim());
        user.setEmail(email.trim());
        user.setPhone(phone.trim());
        user.setPassword(password);
        user.setRole(role);
        user.setUniversityName(universityName != null ? universityName.trim() : null);
        user.setUniversityLocation(universityLocation != null ? universityLocation.trim() : null);

        if (userDAO.register(user)) {
            resp.sendRedirect(req.getContextPath() + "/login?registered=true");
        } else {
            req.setAttribute("error", "Registration failed. Please try again.");
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
        }
    }
}
