package servlet;

import dao.GuestDAO;
import model.Guest;
import utils.SessionUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    private GuestDAO guestDAO = new GuestDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        
        try {
            String ic = request.getParameter("ic");
            String password = request.getParameter("password");
            
            // Validate inputs
            if (ic == null || ic.trim().isEmpty() || password == null || password.trim().isEmpty()) {
                request.setAttribute("error", "IC and password are required");
                request.getRequestDispatcher("login.jsp").forward(request, response);
                return;
            }
            
            // Attempt login
            Guest guest = guestDAO.login(ic, password);
            
            if (guest != null) {
                // Set session
                SessionUtil.setGuestSession(
                    request.getSession(),
                    guest.getGuestId(),
                    guest.getName(),
                    guest.getEmail(),
                    guest.getIc(),
                    guest.getPhone(),
                    guest.getAddress()
                );
                
                // Redirect to intended page or default
                String redirectUrl = SessionUtil.getRedirectUrl(request, "index.jsp");
                response.sendRedirect(redirectUrl);
            } else {
                request.setAttribute("error", "Invalid IC or password");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred during login: " + e.getMessage());
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}
