package com.student.controller;

import com.student.dao.UserDAO;
import com.student.model.User;
import org.mindrot.jbcrypt.BCrypt;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/change-password")
public class ChangePasswordController extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login");
            return;
        }
        request.getRequestDispatcher("views/change-password.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login");
            return;
        }

        User user = (User) session.getAttribute("user");

        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        String errorMessage = null;

        if (currentPassword == null || newPassword == null || confirmPassword == null) {
            errorMessage = "All fields are required";
        } else if (newPassword.length() < 8) {
            errorMessage = "New password must be at least 8 characters";
        } else if (!newPassword.equals(confirmPassword)) {
            errorMessage = "New password and confirmation do not match";
        } else if (!BCrypt.checkpw(currentPassword, user.getPassword())) {
            errorMessage = "Current password is incorrect";
        }

        if (errorMessage != null) {
            request.setAttribute("error", errorMessage);
            request.getRequestDispatcher("views/change-password.jsp").forward(request, response);
            return;
        }

        String hashedNewPassword = BCrypt.hashpw(newPassword, BCrypt.gensalt());

        if (userDAO.updatePassword(user.getId(), hashedNewPassword)) {
            user.setPassword(hashedNewPassword);
            session.setAttribute("user", user);
            request.setAttribute("success", "Password changed successfully!");
        } else {
            request.setAttribute("error", "Database error occurred, please try again.");
        }

        request.getRequestDispatcher("views/change-password.jsp").forward(request, response);
    }
}