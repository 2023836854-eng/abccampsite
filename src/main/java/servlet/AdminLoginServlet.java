package servlet;

import dao.AdminDAO;
import model.Admin;
import utils.SessionUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/AdminLoginServlet")
public class AdminLoginServlet extends HttpServlet {

    private AdminDAO adminDAO = new AdminDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        
        try {
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            
            // Validate inputs
            if (username == null || username.trim().isEmpty() || 
                password == null || password.trim().isEmpty()) {
                request.setAttribute("error", "Username and password are required");
                request.getRequestDispatcher("admin/login.jsp").forward(request, response);
                return;
            }
            
            // Attempt login
            Admin admin = adminDAO.login(username, password);
            
            if (admin != null) {
                // Set admin session
                SessionUtil.setAdminSession(
                    request.getSession(),
                    admin.getAdminId(),
                    admin.getUsername(),
                    admin.getFullName(),
                    admin.getRole()
                );
                
                // Redirect to admin dashboard
                response.sendRedirect(request.getContextPath() + "/admin/DashboardServlet");
            } else {
                request.setAttribute("error", "Invalid username or password");
                request.getRequestDispatcher("admin/login.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred during login: " + e.getMessage());
            request.getRequestDispatcher("admin/login.jsp").forward(request, response);
        }
    }
}
