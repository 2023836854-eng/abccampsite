package servlet;

import dao.BookingDAO;
import dao.RoomDAO;
import model.AvailableRoom;
import model.Booking;
import utils.BookingIdGenerator;
import utils.SessionUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Date;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;

@WebServlet("/BookingServlet")
public class BookingServlet extends HttpServlet {

    private BookingDAO bookingDAO = new BookingDAO();
    private RoomDAO roomDAO = new RoomDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        
        try {
            // Check if guest is logged in
            if (!SessionUtil.isGuestLoggedIn(request)) {
                response.sendRedirect("login.jsp?redirect=booking.jsp");
                return;
            }
            
            // Get guest ID from session
            Integer guestId = SessionUtil.getGuestId(request);
            if (guestId == null) {
                response.sendRedirect("login.jsp");
                return;
            }
            
            // Get parameters
            String campsiteIdStr = request.getParameter("campsiteId");
            String roomIdStr = request.getParameter("roomId");
            String bookingDateStr = request.getParameter("bookingDate");
            String checkoutDateStr = request.getParameter("checkoutDate");
            String numTentsStr = request.getParameter("numTents");
            
            // Validate inputs
            if (campsiteIdStr == null || roomIdStr == null || 
                bookingDateStr == null || checkoutDateStr == null || numTentsStr == null) {
                request.setAttribute("error", "All fields are required");
                request.getRequestDispatcher("booking.jsp").forward(request, response);
                return;
            }
            
            int campsiteId = Integer.parseInt(campsiteIdStr);
            int roomId = Integer.parseInt(roomIdStr);
            Date bookingDate = Date.valueOf(bookingDateStr);
            Date checkoutDate = Date.valueOf(checkoutDateStr);
            int numTents = Integer.parseInt(numTentsStr);
            
            // Validate dates
            LocalDate bookingLocalDate = LocalDate.parse(bookingDateStr);
            LocalDate checkoutLocalDate = LocalDate.parse(checkoutDateStr);
            
            if (!checkoutLocalDate.isAfter(bookingLocalDate)) {
                request.setAttribute("error", "Checkout date must be after booking date");
                request.getRequestDispatcher("booking.jsp").forward(request, response);
                return;
            }
            
            // Calculate number of days
            long days = ChronoUnit.DAYS.between(bookingLocalDate, checkoutLocalDate);
            
            // Get room details
            AvailableRoom room = roomDAO.getById(roomId);
            if (room == null) {
                request.setAttribute("error", "Room not found");
                request.getRequestDispatcher("booking.jsp").forward(request, response);
                return;
            }
            
            // Check quota
            if (room.getAvailableQuota() < numTents) {
                request.setAttribute("error", "Not enough quota available");
                request.getRequestDispatcher("booking.jsp").forward(request, response);
                return;
            }
            
            // Calculate total price
            BigDecimal totalPrice = room.getPricePerTent()
                .multiply(new BigDecimal(numTents))
                .multiply(new BigDecimal(days));
            
            // Generate booking ID
            String bookingId = BookingIdGenerator.generateBookingId();
            
            // Create Booking object
            Booking booking = new Booking();
            booking.setBookingId(bookingId);
            booking.setGuestId(guestId);
            booking.setCampsiteId(campsiteId);
            booking.setRoomId(roomId);
            booking.setBookingDate(bookingDate);
            booking.setCheckoutDate(checkoutDate);
            booking.setNumTents(numTents);
            booking.setTotalPrice(totalPrice);
            booking.setStatus("Pending");
            booking.setPaymentStatus("Unpaid");
            
            // Create booking
            boolean bookingCreated = bookingDAO.create(booking);
            
            if (bookingCreated) {
                // Update room quota
                boolean quotaUpdated = roomDAO.updateQuota(roomId, -numTents);
                
                if (quotaUpdated) {
                    // Redirect to payment page
                    response.sendRedirect("payment.jsp?bookingId=" + bookingId);
                } else {
                    request.setAttribute("error", "Failed to update room quota");
                    request.getRequestDispatcher("booking.jsp").forward(request, response);
                }
            } else {
                request.setAttribute("error", "Failed to create booking");
                request.getRequestDispatcher("booking.jsp").forward(request, response);
            }
            
        } catch (NumberFormatException e) {
            e.printStackTrace();
            request.setAttribute("error", "Invalid number format");
            request.getRequestDispatcher("booking.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred: " + e.getMessage());
            request.getRequestDispatcher("booking.jsp").forward(request, response);
        }
    }
}
