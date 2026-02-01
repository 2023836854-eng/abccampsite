package servlet.admin;

import dao.BookingDAO;
import dao.CampsiteDAO;
import model.Booking;
import model.Campsite;
import utils.SessionUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Date;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Manage Booking Servlet
 * Handles viewing, filtering, and managing all bookings
 */
@WebServlet("/admin/ManageBookingServlet")
public class ManageBookingServlet extends HttpServlet {
    
    private BookingDAO bookingDAO;
    private CampsiteDAO campsiteDAO;
    
    @Override
    public void init() throws ServletException {
        bookingDAO = new BookingDAO();
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
            String action = request.getParameter("action");
            
            // Handle specific actions
            if ("checkin".equals(action)) {
                handleCheckIn(request, response);
                return;
            } else if ("checkout".equals(action)) {
                handleCheckOut(request, response);
                return;
            } else if ("cancel".equals(action)) {
                handleCancel(request, response);
                return;
            }
            
            // Get filter parameters - fix parameter names to match JSP
            String status = request.getParameter("status");
            String campsite = request.getParameter("campsite");
            String fromDate = request.getParameter("fromDate");
            String toDate = request.getParameter("toDate");
            String guestName = request.getParameter("guestName");
            
            List<Booking> bookings;
            
            // Check if any filters are applied
            if ((status != null && !status.isEmpty()) || 
                (campsite != null && !campsite.isEmpty()) || 
                (fromDate != null && !fromDate.isEmpty()) || 
                (toDate != null && !toDate.isEmpty()) || 
                (guestName != null && !guestName.isEmpty())) {
                // Get filtered bookings
                bookings = bookingDAO.getFiltered(status, campsite, fromDate, toDate, guestName);
            } else {
                // Get all bookings
                bookings = bookingDAO.getAll();
            }
            
            // Get all campsites for the filter dropdown
            List<Campsite> campsiteList = campsiteDAO.getAll();
            List<Map<String, Object>> campsites = new ArrayList<>();
            for (Campsite c : campsiteList) {
                Map<String, Object> map = new HashMap<>();
                map.put("campsiteId", c.getCampsiteId());
                map.put("campsiteName", c.getName());
                campsites.add(map);
            }
            
            // Set bookings list and campsites as attributes
            request.setAttribute("bookings", bookings);
            request.setAttribute("campsites", campsites);
            request.setAttribute("status", status);
            request.setAttribute("campsite", campsite);
            request.setAttribute("fromDate", fromDate);
            request.setAttribute("toDate", toDate);
            request.setAttribute("guestName", guestName);
            
            // Forward to manage booking page
            request.getRequestDispatcher("/admin/manageBooking.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Error loading bookings: " + e.getMessage());
            request.getRequestDispatcher("/admin/manageBooking.jsp").forward(request, response);
        }
    }
    
    private void handleCheckIn(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            String bookingId = request.getParameter("id");
            if (bookingId == null || bookingId.trim().isEmpty()) {
                response.sendRedirect("ManageBookingServlet?error=" + 
                    java.net.URLEncoder.encode("Invalid booking ID", "UTF-8"));
                return;
            }
            
            Booking booking = bookingDAO.getById(bookingId);
            if (booking == null) {
                response.sendRedirect("ManageBookingServlet?error=" + 
                    java.net.URLEncoder.encode("Booking not found", "UTF-8"));
                return;
            }
            
            // Check if current date is within check-in and check-out range
            LocalDate today = LocalDate.now();
            LocalDate checkInDate = booking.getBookingDate().toLocalDate();
            LocalDate checkOutDate = booking.getCheckoutDate().toLocalDate();
            
            if (today.isBefore(checkInDate) || today.isAfter(checkOutDate)) {
                response.sendRedirect("ManageBookingServlet?error=" + 
                    java.net.URLEncoder.encode("Check-in only allowed on booking dates", "UTF-8"));
                return;
            }
            
            // Update status to Ongoing
            boolean updated = bookingDAO.updateStatus(bookingId, "Ongoing");
            String message = updated ? "Check-in successful" : "Failed to check in";
            response.sendRedirect("ManageBookingServlet?success=" + 
                java.net.URLEncoder.encode(message, "UTF-8"));
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("ManageBookingServlet?error=" + 
                java.net.URLEncoder.encode("Error processing check-in: " + e.getMessage(), "UTF-8"));
        }
    }
    
    private void handleCheckOut(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            String bookingId = request.getParameter("id");
            if (bookingId == null || bookingId.trim().isEmpty()) {
                response.sendRedirect("ManageBookingServlet?error=" + 
                    java.net.URLEncoder.encode("Invalid booking ID", "UTF-8"));
                return;
            }
            
            Booking booking = bookingDAO.getById(bookingId);
            if (booking == null) {
                response.sendRedirect("ManageBookingServlet?error=" + 
                    java.net.URLEncoder.encode("Booking not found", "UTF-8"));
                return;
            }
            
            // Check if status is Ongoing
            if (!"Ongoing".equalsIgnoreCase(booking.getStatus())) {
                response.sendRedirect("ManageBookingServlet?error=" + 
                    java.net.URLEncoder.encode("Can only check out ongoing bookings", "UTF-8"));
                return;
            }
            
            // Update status to Completed
            boolean updated = bookingDAO.updateStatus(bookingId, "Completed");
            String message = updated ? "Check-out successful" : "Failed to check out";
            response.sendRedirect("ManageBookingServlet?success=" + 
                java.net.URLEncoder.encode(message, "UTF-8"));
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("ManageBookingServlet?error=" + 
                java.net.URLEncoder.encode("Error processing check-out: " + e.getMessage(), "UTF-8"));
        }
    }
    
    private void handleCancel(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            String bookingId = request.getParameter("id");
            if (bookingId == null || bookingId.trim().isEmpty()) {
                response.sendRedirect("ManageBookingServlet?error=" + 
                    java.net.URLEncoder.encode("Invalid booking ID", "UTF-8"));
                return;
            }
            
            Booking booking = bookingDAO.getById(bookingId);
            if (booking == null) {
                response.sendRedirect("ManageBookingServlet?error=" + 
                    java.net.URLEncoder.encode("Booking not found", "UTF-8"));
                return;
            }
            
            // Check if booking hasn't started yet
            LocalDate today = LocalDate.now();
            LocalDate checkInDate = booking.getBookingDate().toLocalDate();
            
            if (!today.isBefore(checkInDate) && !"Pending".equalsIgnoreCase(booking.getStatus()) 
                && !"Confirmed".equalsIgnoreCase(booking.getStatus())) {
                response.sendRedirect("ManageBookingServlet?error=" + 
                    java.net.URLEncoder.encode("Cannot cancel bookings that have started or completed", "UTF-8"));
                return;
            }
            
            // Cancel booking
            String reason = "Cancelled by admin";
            boolean cancelled = bookingDAO.cancel(bookingId, reason);
            
            if (cancelled) {
                // Check payment status and provide appropriate message
                String refundMsg = "";
                if ("Paid".equalsIgnoreCase(booking.getPaymentStatus())) {
                    refundMsg = " - Refunded";
                } else {
                    refundMsg = " - Unpaid";
                }
                
                response.sendRedirect("ManageBookingServlet?success=" + 
                    java.net.URLEncoder.encode("Booking cancelled successfully" + refundMsg, "UTF-8"));
            } else {
                response.sendRedirect("ManageBookingServlet?error=" + 
                    java.net.URLEncoder.encode("Failed to cancel booking", "UTF-8"));
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("ManageBookingServlet?error=" + 
                java.net.URLEncoder.encode("Error cancelling booking: " + e.getMessage(), "UTF-8"));
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // All actions now handled via GET with action parameter
        doGet(request, response);
    }
}
