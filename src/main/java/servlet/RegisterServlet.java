package servlet;

import dao.GuestDAO;
import model.Guest;
import utils.PasswordUtil;
import utils.SessionUtil;
import utils.ValidationUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Date;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {

    private GuestDAO guestDAO = new GuestDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        
        try {
            String name = request.getParameter("name");
            String ic = request.getParameter("ic");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String address = request.getParameter("address");
            String dobStr = request.getParameter("dob");
            String password = request.getParameter("password");
            
            // Validate inputs
            if (!ValidationUtil.isNotEmpty(name)) {
                request.setAttribute("error", "Name is required");
                request.getRequestDispatcher("register.jsp").forward(request, response);
                return;
            }
            
            if (!ValidationUtil.isValidIC(ic)) {
                request.setAttribute("error", "Invalid IC number format (YYMMDD-PB-####)");
                request.getRequestDispatcher("register.jsp").forward(request, response);
                return;
            }
            
            if (!ValidationUtil.isValidEmail(email)) {
                request.setAttribute("error", "Invalid email address");
                request.getRequestDispatcher("register.jsp").forward(request, response);
                return;
            }
            
            if (!ValidationUtil.isValidPhone(phone)) {
                request.setAttribute("error", "Invalid phone number format");
                request.getRequestDispatcher("register.jsp").forward(request, response);
                return;
            }
            
            if (!ValidationUtil.isNotEmpty(address)) {
                request.setAttribute("error", "Address is required");
                request.getRequestDispatcher("register.jsp").forward(request, response);
                return;
            }
            
            if (!ValidationUtil.isValidPassword(password)) {
                request.setAttribute("error", "Password must be at least 6 characters");
                request.getRequestDispatcher("register.jsp").forward(request, response);
                return;
            }
            
            // Hash password
            String hashedPassword = PasswordUtil.hashPassword(password);
            
            // Create Guest object
            Guest guest = new Guest();
            guest.setName(name);
            guest.setIc(ic);
            guest.setEmail(email);
            guest.setPhone(phone);
            guest.setAddress(address);
            
            if (dobStr != null && !dobStr.isEmpty()) {
                guest.setDob(Date.valueOf(dobStr));
            }
            
            guest.setPassword(hashedPassword);
            
            // Register guest
            boolean success = guestDAO.register(guest);
            
            if (success) {
                // Get guest details for session
                Guest registeredGuest = guestDAO.login(ic, password);
                
                if (registeredGuest != null) {
                    // Set session
                    SessionUtil.setGuestSession(
                        request.getSession(), 
                        registeredGuest.getGuestId(),
                        registeredGuest.getName(),
                        registeredGuest.getEmail(),
                        registeredGuest.getIc(),
                        registeredGuest.getPhone(),
                        registeredGuest.getAddress()
                    );
                }
                
                // Redirect to index page
                response.sendRedirect("index.jsp");
            } else {
                request.setAttribute("error", "Registration failed. IC or email may already exist.");
                request.getRequestDispatcher("register.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred during registration: " + e.getMessage());
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
    }
}
