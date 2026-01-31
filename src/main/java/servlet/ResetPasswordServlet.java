package servlet;

import dao.GuestDAO;
import dao.PasswordResetDAO;
import model.PasswordReset;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/ResetPasswordServlet")
public class ResetPasswordServlet extends HttpServlet {

    private GuestDAO guestDAO = new GuestDAO();
    private PasswordResetDAO passwordResetDAO = new PasswordResetDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        
        try {
            String code = request.getParameter("code");
            String newPassword = request.getParameter("newPassword");
            String confirmPassword = request.getParameter("confirmPassword");
            
            // Validate inputs
            if (code == null || code.trim().isEmpty()) {
                request.setAttribute("error", "Verification code is required");
                request.getRequestDispatcher("verify-code.jsp").forward(request, response);
                return;
            }
            
            if (newPassword == null || newPassword.trim().isEmpty()) {
                request.setAttribute("error", "New password is required");
                request.getRequestDispatcher("verify-code.jsp").forward(request, response);
                return;
            }
            
            if (!newPassword.equals(confirmPassword)) {
                request.setAttribute("error", "Passwords do not match");
                request.getRequestDispatcher("verify-code.jsp").forward(request, response);
                return;
            }
            
            if (newPassword.length() < 6) {
                request.setAttribute("error", "Password must be at least 6 characters");
                request.getRequestDispatcher("verify-code.jsp").forward(request, response);
                return;
            }
            
            // Validate TAC code (convert to uppercase for comparison)
            String tacCode = code.trim().toUpperCase();
            boolean isValid = passwordResetDAO.validateToken(tacCode);
            
            if (!isValid) {
                request.setAttribute("error", "The verification code is invalid or has expired. Please request a new code.");
                request.getRequestDispatcher("verify-code.jsp").forward(request, response);
                return;
            }
            
            // Get the password reset record
            PasswordReset reset = passwordResetDAO.getByToken(tacCode);
            
            if (reset == null) {
                request.setAttribute("error", "Invalid verification code");
                request.getRequestDispatcher("verify-code.jsp").forward(request, response);
                return;
            }
            
            // Update password
            boolean passwordUpdated = guestDAO.updatePassword(reset.getGuestId(), newPassword);
            
            if (passwordUpdated) {
                // Mark token as used
                passwordResetDAO.markAsUsed(tacCode);
                
                request.setAttribute("success", "Your password has been successfully reset.");
                request.getRequestDispatcher("verify-code.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Failed to update password. Please try again.");
                request.getRequestDispatcher("verify-code.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred: " + e.getMessage());
            request.getRequestDispatcher("verify-code.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Redirect to verify code page
        response.sendRedirect("verify-code.jsp");
    }
}
