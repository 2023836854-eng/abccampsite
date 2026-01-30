package servlet;

import dao.GuestDAO;
import dao.PasswordResetDAO;
import model.Guest;
import utils.BookingIdGenerator;
import utils.EmailUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Timestamp;

@WebServlet("/PasswordResetServlet")
public class PasswordResetServlet extends HttpServlet {

    private GuestDAO guestDAO = new GuestDAO();
    private PasswordResetDAO passwordResetDAO = new PasswordResetDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        
        try {
            String email = request.getParameter("email");
            
            // Validate email
            if (email == null || email.trim().isEmpty()) {
                request.setAttribute("error", "Email is required");
                request.getRequestDispatcher("forgot-password.jsp").forward(request, response);
                return;
            }
            
            // Get guest by email
            Guest guest = guestDAO.getByEmail(email);
            
            if (guest == null) {
                // Don't reveal if email exists or not for security
                request.setAttribute("success", "If the email exists, a password reset link has been sent.");
                request.getRequestDispatcher("forgot-password.jsp").forward(request, response);
                return;
            }
            
            // Generate reset token
            String token = BookingIdGenerator.generateResetToken();
            
            // Calculate expiry (1 hour from now)
            Timestamp expiresAt = new Timestamp(System.currentTimeMillis() + (60 * 60 * 1000));
            
            // Create token in database
            boolean tokenCreated = passwordResetDAO.createToken(
                guest.getGuestId(), 
                email, 
                token, 
                expiresAt
            );
            
            if (tokenCreated) {
                // Send password reset email
                try {
                    String resetLink = request.getScheme() + "://" + 
                                     request.getServerName() + ":" + 
                                     request.getServerPort() + 
                                     request.getContextPath() + 
                                     "/PasswordResetServlet?token=" + token;
                    
                    EmailUtil.sendPasswordResetEmail(
                        email,
                        guest.getName(),
                        resetLink
                    );
                    
                    request.setAttribute("success", "A password reset link has been sent to your email.");
                } catch (Exception emailException) {
                    emailException.printStackTrace();
                    request.setAttribute("error", "Failed to send reset email. Please try again.");
                }
            } else {
                request.setAttribute("error", "Failed to process password reset request. Please try again.");
            }
            
            request.getRequestDispatcher("forgot-password.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred: " + e.getMessage());
            request.getRequestDispatcher("forgot-password.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        
        try {
            String token = request.getParameter("token");
            
            // Validate token parameter
            if (token == null || token.trim().isEmpty()) {
                request.setAttribute("error", "Invalid reset link");
                request.getRequestDispatcher("forgot-password.jsp").forward(request, response);
                return;
            }
            
            // Validate token
            boolean isValid = passwordResetDAO.validateToken(token);
            
            if (isValid) {
                // Token is valid, show reset password form
                request.setAttribute("token", token);
                request.getRequestDispatcher("reset-password.jsp").forward(request, response);
            } else {
                // Token is invalid or expired
                request.setAttribute("error", "The password reset link is invalid or has expired. Please request a new one.");
                request.getRequestDispatcher("forgot-password.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred: " + e.getMessage());
            request.getRequestDispatcher("forgot-password.jsp").forward(request, response);
        }
    }
}
