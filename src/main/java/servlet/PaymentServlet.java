package servlet;

import dao.BookingDAO;
import dao.PaymentDAO;
import model.Booking;
import model.Payment;
import utils.BookingIdGenerator;
import utils.EmailUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Timestamp;

@WebServlet("/PaymentServlet")
public class PaymentServlet extends HttpServlet {

    private PaymentDAO paymentDAO = new PaymentDAO();
    private BookingDAO bookingDAO = new BookingDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        
        try {
            // Get parameters
            String bookingId = request.getParameter("bookingId");
            String paymentMethod = request.getParameter("paymentMethod");
            
            // Validate inputs
            if (bookingId == null || bookingId.trim().isEmpty()) {
                request.setAttribute("error", "Booking ID is required");
                request.getRequestDispatcher("payment.jsp").forward(request, response);
                return;
            }
            
            if (paymentMethod == null || paymentMethod.trim().isEmpty()) {
                request.setAttribute("error", "Payment method is required");
                request.getRequestDispatcher("payment.jsp?bookingId=" + bookingId).forward(request, response);
                return;
            }
            
            // Get booking details
            Booking booking = bookingDAO.getById(bookingId);
            
            if (booking == null) {
                request.setAttribute("error", "Booking not found");
                request.getRequestDispatcher("payment.jsp").forward(request, response);
                return;
            }
            
            // Check if already paid
            if ("Paid".equals(booking.getPaymentStatus())) {
                request.setAttribute("error", "Booking has already been paid");
                response.sendRedirect("receipt.jsp?bookingId=" + bookingId);
                return;
            }
            
            // Generate transaction ID
            String transactionId = BookingIdGenerator.generateTransactionId(paymentMethod);
            
            // Create Payment object
            Payment payment = new Payment();
            payment.setBookingId(bookingId);
            payment.setPaymentMethod(paymentMethod);
            payment.setPaymentDate(new Timestamp(System.currentTimeMillis()));
            payment.setAmount(booking.getTotalPrice());
            payment.setTransactionId(transactionId);
            payment.setStatus("Completed");
            
            // Create payment record
            boolean paymentCreated = paymentDAO.create(payment);
            
            if (paymentCreated) {
                // Update booking payment status
                boolean statusUpdated = bookingDAO.updatePaymentStatus(bookingId, "Paid");
                
                if (statusUpdated) {
                    // Update booking status to Confirmed
                    bookingDAO.updateStatus(bookingId, "Confirmed");
                    
                    // Send confirmation email
                    try {
                        EmailUtil.sendBookingConfirmation(
                            booking.getGuestEmail() != null ? booking.getGuestEmail() : "",
                            bookingId,
                            booking.getGuestName() != null ? booking.getGuestName() : "",
                            booking.getCampsiteName() != null ? booking.getCampsiteName() : "",
                            booking.getBookingDate().toString(),
                            booking.getCheckoutDate().toString(),
                            booking.getTotalPrice().toString()
                        );
                    } catch (Exception emailException) {
                        // Log email error but don't fail the payment
                        emailException.printStackTrace();
                    }
                    
                    // Redirect to receipt page
                    response.sendRedirect("receipt.jsp?bookingId=" + bookingId);
                } else {
                    request.setAttribute("error", "Payment processed but failed to update booking status");
                    request.getRequestDispatcher("payment.jsp?bookingId=" + bookingId).forward(request, response);
                }
            } else {
                request.setAttribute("error", "Failed to process payment");
                request.getRequestDispatcher("payment.jsp?bookingId=" + bookingId).forward(request, response);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred during payment: " + e.getMessage());
            request.getRequestDispatcher("payment.jsp").forward(request, response);
        }
    }
}
