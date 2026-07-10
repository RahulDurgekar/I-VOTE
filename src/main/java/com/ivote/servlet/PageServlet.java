package com.ivote.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet({"/about", "/contact"})
public class PageServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String uri = req.getRequestURI();
        if (uri.endsWith("/about")) {
            req.getRequestDispatcher("/about.jsp").forward(req, resp);
        } else {
            req.getRequestDispatcher("/contact.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setAttribute("sent", true);
        req.getRequestDispatcher("/contact.jsp").forward(req, resp);
    }
}
