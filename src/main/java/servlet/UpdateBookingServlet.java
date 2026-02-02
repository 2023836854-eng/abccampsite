package servlet;

import dao.BookingDAO;
import dao.RoomDAO;
import model.Booking;
import utils.SessionUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/UpdateBookingServlet")
public class UpdateBookingServlet extends HttpServlet {

    private BookingDAO bookingDAO = new BookingDAO();
    private RoomDAO roomDAO = new RoomDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doPost(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        
        try {
            String action = request.getParameter("action");
            
            if (action == null || action.trim().isEmpty()) {
                request.setAttribute("error", "Action is required");
                response.sendRedirect("bookings.jsp");
                return;
            }
            
            if ("cancel".equals(action)) {
                handleCancellation(request, response);
            } else if ("updateStatus".equals(action)) {
                handleStatusUpdate(request, response);
            } else {
                request.setAttribute("error", "Invalid action");
                response.sendRedirect("bookings.jsp");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred: " + e.getMessage());
            response.sendRedirect("bookings.jsp");
        }
    }
    
    private void handleCancellation(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String bookingId = request.getParameter("bookingId");
        String cancellationReason = request.getParameter("cancellationReason");
        
        // Validate inputs
        if (bookingId == null || bookingId.trim().isEmpty()) {
            request.setAttribute("error", "Booking ID is required");
            response.sendRedirect("bookings.jsp");
            return;
        }
        
        if (cancellationReason == null || cancellationReason.trim().isEmpty()) {
            cancellationReason = "Cancelled by guest";
        }
        
        // Get booking details before cancellation
        Booking booking = bookingDAO.getById(bookingId);
        
        if (booking == null) {
            request.setAttribute("error", "Booking not found");
            response.sendRedirect("bookings.jsp");
            return;
        }
        
        // Check if guest is authorized (for guest users)
        if (SessionUtil.isGuestLoggedIn(request)) {
            Integer guestId = SessionUtil.getGuestId(request);
            if (guestId == null || guestId != booking.getGuestId()) {
                request.setAttribute("error", "Unauthorized to cancel this booking");
                response.sendRedirect("bookings.jsp");
                return;
            }
        }
        
        // Cancel booking
        boolean cancelled = bookingDAO.cancel(bookingId, cancellationReason);
        
        if (cancelled) {
            // Restore room quota (pass negative value to add back quota)
            int numTents = booking.getNumTents();
            int roomId = booking.getRoomId();
            roomDAO.updateQuota(roomId, -numTents);
            
            // Redirect based on user type
            if (SessionUtil.isAdminLoggedIn(request)) {
                response.sendRedirect("admin/ManageBookingServlet?message=Booking cancelled successfully");
            } else {
                response.sendRedirect("bookinglist.jsp?msg=cancelled");
            }
        } else {
            request.setAttribute("error", "Failed to cancel booking");
            if (SessionUtil.isAdminLoggedIn(request)) {
                response.sendRedirect("admin/ManageBookingServlet?error=Failed to cancel booking");
            } else {
                response.sendRedirect("bookinglist.jsp?msg=error");
            }
        }
    }
    
    private void handleStatusUpdate(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Only admin can update status
        if (!SessionUtil.isAdminLoggedIn(request)) {
            request.setAttribute("error", "Unauthorized access");
            response.sendRedirect("login.jsp");
            return;
        }
        
        String bookingId = request.getParameter("bookingId");
        String newStatus = request.getParameter("status");
        
        // Validate inputs
        if (bookingId == null || bookingId.trim().isEmpty()) {
            request.setAttribute("error", "Booking ID is required");
            response.sendRedirect("admin/bookings.jsp");
            return;
        }
        
        if (newStatus == null || newStatus.trim().isEmpty()) {
            request.setAttribute("error", "Status is required");
            response.sendRedirect("admin/bookings.jsp");
            return;
        }
        
        // Validate status values
        if (!isValidStatus(newStatus)) {
            request.setAttribute("error", "Invalid status value");
            response.sendRedirect("admin/bookings.jsp");
            return;
        }
        
        // Update status
        boolean updated = bookingDAO.updateStatus(bookingId, newStatus);
        
        if (updated) {
            response.sendRedirect("admin/bookings.jsp?message=Status updated successfully");
        } else {
            request.setAttribute("error", "Failed to update status");
            response.sendRedirect("admin/bookings.jsp");
        }
    }
    
    private boolean isValidStatus(String status) {
        return "Pending".equals(status) || 
               "Confirmed".equals(status) || 
               "Ongoing".equals(status) || 
               "Completed".equals(status) || 
               "Cancelled".equals(status);
    }
}
