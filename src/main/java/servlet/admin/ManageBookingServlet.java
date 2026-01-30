package servlet.admin;

import dao.BookingDAO;
import utils.SessionUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

/**
 * Manage Booking Servlet
 * Handles viewing, filtering, and managing all bookings
 */
@WebServlet("/admin/ManageBookingServlet")
public class ManageBookingServlet extends HttpServlet {
    
    private BookingDAO bookingDAO;
    
    @Override
    public void init() throws ServletException {
        bookingDAO = new BookingDAO();
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
            // Get filter parameters
            String status = request.getParameter("status");
            String campsiteId = request.getParameter("campsiteId");
            String dateFrom = request.getParameter("dateFrom");
            String dateTo = request.getParameter("dateTo");
            String guestName = request.getParameter("guestName");
            
            List<?> bookings;
            
            // Check if any filters are applied
            if (status != null || campsiteId != null || dateFrom != null || 
                dateTo != null || guestName != null) {
                // Get filtered bookings
                bookings = bookingDAO.getFiltered(status, campsiteId, dateFrom, dateTo, guestName);
            } else {
                // Get all bookings
                bookings = bookingDAO.getAll();
            }
            
            // Set bookings list as attribute
            request.setAttribute("bookings", bookings);
            request.setAttribute("status", status);
            request.setAttribute("campsiteId", campsiteId);
            request.setAttribute("dateFrom", dateFrom);
            request.setAttribute("dateTo", dateTo);
            request.setAttribute("guestName", guestName);
            
            // Forward to manage booking page
            request.getRequestDispatcher("/admin/manageBooking.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error loading bookings: " + e.getMessage());
            request.getRequestDispatcher("/admin/manageBooking.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Check admin authentication
        if (!SessionUtil.isAdminLoggedIn(request)) {
            response.sendRedirect("../login.jsp");
            return;
        }
        
        try {
            // Get action and bookingId parameters
            String action = request.getParameter("action");
            String bookingIdStr = request.getParameter("bookingId");
            
            if (bookingIdStr == null || bookingIdStr.trim().isEmpty()) {
                response.sendRedirect("ManageBookingServlet?error=Invalid booking ID");
                return;
            }
            
            int bookingId = Integer.parseInt(bookingIdStr);
            
            String message = "";
            
            // Handle different actions
            switch (action) {
                case "updateStatus":
                    String newStatus = request.getParameter("newStatus");
                    if (newStatus != null && !newStatus.trim().isEmpty()) {
                        boolean updated = bookingDAO.updateStatus(bookingId, newStatus);
                        message = updated ? "Booking status updated successfully" : 
                                           "Failed to update booking status";
                    } else {
                        message = "Invalid status";
                    }
                    break;
                    
                case "cancelBooking":
                    String reason = request.getParameter("reason");
                    if (reason == null || reason.trim().isEmpty()) {
                        reason = "Cancelled by admin";
                    }
                    boolean cancelled = bookingDAO.cancel(bookingId, reason);
                    message = cancelled ? "Booking cancelled successfully" : 
                                         "Failed to cancel booking";
                    break;
                    
                case "viewDetails":
                    // Redirect to booking details page
                    response.sendRedirect("ManageBookingServlet?bookingId=" + bookingId + "&view=details");
                    return;
                    
                default:
                    message = "Invalid action";
            }
            
            // Redirect back with success message
            response.sendRedirect("ManageBookingServlet?message=" + 
                                java.net.URLEncoder.encode(message, "UTF-8"));
            
        } catch (NumberFormatException e) {
            e.printStackTrace();
            response.sendRedirect("ManageBookingServlet?error=" + 
                                java.net.URLEncoder.encode("Invalid booking ID format", "UTF-8"));
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("ManageBookingServlet?error=" + 
                                java.net.URLEncoder.encode("Error processing request: " + e.getMessage(), "UTF-8"));
        }
    }
}
