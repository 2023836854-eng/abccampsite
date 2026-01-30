package servlet;

import dao.GuestDAO;
import dao.PasswordResetDAO;
import model.PasswordReset;
import utils.PasswordUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/ResetPasswordServlet")
public class ResetPasswordServlet extends HttpServlet {

    private PasswordResetDAO passwordResetDAO = new PasswordResetDAO();
    private GuestDAO guestDAO = new GuestDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        
        try {
            String token = request.getParameter("token");
            String password = request.getParameter("password");
            String confirmPassword = request.getParameter("confirmPassword");
            
            // Validate inputs
            if (token == null || token.trim().isEmpty()) {
                request.setAttribute("error", "Invalid reset token");
                request.getRequestDispatcher("forgot-password.jsp").forward(request, response);
                return;
            }
            
            if (password == null || password.trim().isEmpty()) {
                request.setAttribute("error", "Password is required");
                request.setAttribute("token", token);
                request.getRequestDispatcher("reset-password.jsp").forward(request, response);
                return;
            }
            
            if (password.length() < 6) {
                request.setAttribute("error", "Password must be at least 6 characters");
                request.setAttribute("token", token);
                request.getRequestDispatcher("reset-password.jsp").forward(request, response);
                return;
            }
            
            if (!password.equals(confirmPassword)) {
                request.setAttribute("error", "Passwords do not match");
                request.setAttribute("token", token);
                request.getRequestDispatcher("reset-password.jsp").forward(request, response);
                return;
            }
            
            // Validate token
            if (!passwordResetDAO.validateToken(token)) {
                request.setAttribute("error", "The password reset link is invalid or has expired");
                request.getRequestDispatcher("forgot-password.jsp").forward(request, response);
                return;
            }
            
            // Get reset details
            PasswordReset reset = passwordResetDAO.getByToken(token);
            if (reset == null) {
                request.setAttribute("error", "Invalid reset token");
                request.getRequestDispatcher("forgot-password.jsp").forward(request, response);
                return;
            }
            
            // Hash new password
            String hashedPassword = PasswordUtil.hashPassword(password);
            
            // Update password
            boolean updated = guestDAO.updatePassword(reset.getGuestId(), hashedPassword);
            
            if (updated) {
                // Mark token as used
                passwordResetDAO.markAsUsed(token);
                
                request.setAttribute("success", "Password has been reset successfully! You can now login with your new password.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Failed to reset password. Please try again.");
                request.setAttribute("token", token);
                request.getRequestDispatcher("reset-password.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred: " + e.getMessage());
            request.getRequestDispatcher("forgot-password.jsp").forward(request, response);
        }
    }
}
