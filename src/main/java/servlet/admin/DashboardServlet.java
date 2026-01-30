package servlet.admin;

import dao.BookingDAO;
import dao.GuestDAO;
import dao.CampsiteDAO;
import utils.SessionUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Map;

/**
 * Admin Dashboard Servlet
 * Displays statistics and overview of the campsite system
 */
@WebServlet("/admin/DashboardServlet")
public class DashboardServlet extends HttpServlet {
    
    private BookingDAO bookingDAO;
    private GuestDAO guestDAO;
    private CampsiteDAO campsiteDAO;
    
    @Override
    public void init() throws ServletException {
        bookingDAO = new BookingDAO();
        guestDAO = new GuestDAO();
        campsiteDAO = new CampsiteDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Check admin authentication
        if (!SessionUtil.isAdminLoggedIn(request)) {
            response.sendRedirect("../login.jsp");
            return;
        }
        
        try {
            // Get booking statistics
            Map<String, Object> statistics = bookingDAO.getStatistics();
            request.setAttribute("statistics", statistics);
            
            // Get total guests count
            int totalGuests = guestDAO.getCount();
            request.setAttribute("totalGuests", totalGuests);
            
            // Get upcoming bookings
            var upcomingBookings = bookingDAO.getUpcoming();
            request.setAttribute("upcomingBookings", upcomingBookings);
            
            // Get active campsites count
            int activeCampsites = campsiteDAO.getActiveCount();
            request.setAttribute("activeCampsites", activeCampsites);
            
            // Forward to dashboard page
            request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error loading dashboard: " + e.getMessage());
            request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
        }
    }
}
