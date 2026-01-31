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
            String ic = request.getParameter("ic");
            String email = request.getParameter("email");
            
            // Validate inputs
            if (ic == null || ic.trim().isEmpty() || email == null || email.trim().isEmpty()) {
                request.setAttribute("error", "IC Number and Email are required");
                request.getRequestDispatcher("forgot-password.jsp").forward(request, response);
                return;
            }
            
            // Get guest by IC and email
            Guest guest = guestDAO.getByIcAndEmail(ic.trim(), email.trim());
            
            if (guest == null) {
                // Don't reveal if account exists for security
                request.setAttribute("success", "If the IC and email match our records, a verification code has been sent.");
                request.getRequestDispatcher("forgot-password.jsp").forward(request, response);
                return;
            }
            
            // Generate 5-character TAC code
            String tacCode = BookingIdGenerator.generateTacCode();
            
            // Calculate expiry (10 minutes from now)
            Timestamp expiresAt = new Timestamp(System.currentTimeMillis() + (10 * 60 * 1000));
            
            // Create token in database
            boolean tokenCreated = passwordResetDAO.createToken(
                guest.getGuestId(), 
                email.trim(), 
                tacCode, 
                expiresAt
            );
            
            if (tokenCreated) {
                // Send TAC code via email
                try {
                    EmailUtil.sendPasswordResetTacCode(email.trim(), tacCode);
                    request.setAttribute("success", "A verification code has been sent to your email. The code will expire in 10 minutes.");
                } catch (Exception emailException) {
                    emailException.printStackTrace();
                    request.setAttribute("error", "Failed to send verification code. Please try again.");
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
        // Redirect to forgot password page
        response.sendRedirect("forgot-password.jsp");
    }
}
