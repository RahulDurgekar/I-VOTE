package com.ivote.controller;

import com.ivote.dao.CandidateDAO;
import com.ivote.dao.impl.CandidateDAOImpl;
import com.ivote.model.Candidate;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/candidatePhoto")
public class CandidatePhotoServlet extends HttpServlet {

    private final CandidateDAO candidateDAO = new CandidateDAOImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String idParam = req.getParameter("id");
        
        if (idParam == null) { 
        	resp.sendError(404); 
        	return; 
        	}

        Candidate c = candidateDAO.findById(Integer.parseInt(idParam));
        if (c == null || c.getProfilePic() == null || c.getProfilePic().length == 0) {
            resp.sendRedirect(req.getContextPath() + "/css/default-avatar.png");
            return;
        }
        resp.setContentType("image/jpeg");
        resp.getOutputStream().write(c.getProfilePic());
    }
}
