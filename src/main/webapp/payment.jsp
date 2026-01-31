<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.BookingDAO, model.Booking, utils.SessionUtil" %>
<%
// Check if guest is logged in
Integer guestId = SessionUtil.getGuestId(request);
if (guestId == null) {
    response.sendRedirect("login.jsp");
    return;
}

// Get booking ID from parameter
String bookingId = request.getParameter("bookingId");
if (bookingId == null || bookingId.trim().isEmpty()) {
    response.sendRedirect("bookinglist.jsp");
    return;
}

// Get booking details
BookingDAO bookingDAO = new BookingDAO();
Booking booking = bookingDAO.getById(bookingId);

if (booking == null) {
    response.sendRedirect("bookinglist.jsp");
    return;
}

// Check if this booking belongs to the logged-in guest
if (booking.getGuestId() != guestId) {
    response.sendRedirect("bookinglist.jsp");
    return;
}

// Check if already paid
if ("Paid".equals(booking.getPaymentStatus())) {
    response.sendRedirect("receipt.jsp?bookingId=" + bookingId);
    return;
}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Payment - ABC Campsite</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
<style>
body {
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    min-height: 100vh;
    padding: 20px;
}

.payment-container {
    max-width: 700px;
    margin: 0 auto;
    background: white;
    border-radius: 15px;
    box-shadow: 0 10px 40px rgba(0,0,0,0.2);
    overflow: hidden;
}

.payment-header {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    color: white;
    padding: 30px;
    text-align: center;
}

.payment-header h2 {
    margin: 0;
    font-size: 28px;
}

.payment-header p {
    margin: 10px 0 0;
    opacity: 0.9;
}

.payment-body {
    padding: 40px;
}

.booking-summary {
    background: #f8f9fa;
    border-radius: 10px;
    padding: 20px;
    margin-bottom: 30px;
}

.summary-row {
    display: flex;
    justify-content: space-between;
    padding: 10px 0;
    border-bottom: 1px solid #dee2e6;
}

.summary-row:last-child {
    border-bottom: none;
}

.summary-label {
    font-weight: 600;
    color: #555;
}

.summary-value {
    color: #333;
}

.total-amount {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    color: white;
    border-radius: 8px;
    padding: 15px 20px;
    margin-top: 15px;
    display: flex;
    justify-content: space-between;
    align-items: center;
    font-size: 20px;
    font-weight: bold;
}

.payment-method-section {
    margin: 30px 0;
}

.section-title {
    font-size: 18px;
    font-weight: 600;
    color: #333;
    margin-bottom: 20px;
    display: flex;
    align-items: center;
}

.section-title i {
    margin-right: 10px;
    color: #667eea;
}

.payment-method-option {
    border: 2px solid #e0e0e0;
    border-radius: 10px;
    padding: 15px 20px;
    margin-bottom: 15px;
    cursor: pointer;
    transition: all 0.3s;
    display: flex;
    align-items: center;
}

.payment-method-option:hover {
    border-color: #667eea;
    background: #f8f9ff;
}

.payment-method-option input[type="radio"] {
    margin-right: 15px;
    width: 20px;
    height: 20px;
    cursor: pointer;
}

.payment-method-option.selected {
    border-color: #667eea;
    background: #f8f9ff;
}

.payment-method-icon {
    font-size: 24px;
    margin-right: 15px;
    width: 40px;
    text-align: center;
}

.payment-method-details {
    flex-grow: 1;
}

.payment-method-name {
    font-weight: 600;
    color: #333;
    margin-bottom: 3px;
}

.payment-method-desc {
    font-size: 13px;
    color: #777;
}

.btn-submit-payment {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    border: none;
    padding: 15px 40px;
    border-radius: 8px;
    color: white;
    font-weight: 600;
    font-size: 16px;
    width: 100%;
    transition: transform 0.2s;
    cursor: pointer;
}

.btn-submit-payment:hover {
    transform: translateY(-2px);
    box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
}

.btn-back {
    background: #6c757d;
    border: none;
    padding: 12px 30px;
    border-radius: 8px;
    color: white;
    font-weight: 600;
    text-decoration: none;
    display: inline-block;
    margin-top: 15px;
    transition: background 0.3s;
}

.btn-back:hover {
    background: #5a6268;
    color: white;
}

.alert {
    border-radius: 8px;
    margin-bottom: 20px;
}
</style>
</head>
<body>

<div class="payment-container">
    <div class="payment-header">
        <i class="fas fa-credit-card" style="font-size: 48px; margin-bottom: 10px;"></i>
        <h2>Complete Payment</h2>
        <p>Secure payment for your booking</p>
    </div>
    
    <div class="payment-body">
        <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-danger">
                <i class="fas fa-exclamation-circle"></i>
                <%= request.getAttribute("error") %>
            </div>
        <% } %>
        
        <!-- Booking Summary -->
        <div class="booking-summary">
            <h5 style="margin-bottom: 15px; color: #333;">
                <i class="fas fa-file-invoice"></i> Booking Summary
            </h5>
            <div class="summary-row">
                <span class="summary-label">Booking ID:</span>
                <span class="summary-value"><strong><%= booking.getBookingId() %></strong></span>
            </div>
            <div class="summary-row">
                <span class="summary-label">Campsite:</span>
                <span class="summary-value"><%= booking.getCampsiteName() != null ? booking.getCampsiteName() : "N/A" %></span>
            </div>
            <div class="summary-row">
                <span class="summary-label">Room:</span>
                <span class="summary-value"><%= booking.getRoomName() != null ? booking.getRoomName() : "N/A" %></span>
            </div>
            <div class="summary-row">
                <span class="summary-label">Check-in Date:</span>
                <span class="summary-value"><%= booking.getBookingDate() %></span>
            </div>
            <div class="summary-row">
                <span class="summary-label">Check-out Date:</span>
                <span class="summary-value"><%= booking.getCheckoutDate() %></span>
            </div>
            <div class="summary-row">
                <span class="summary-label">Number of Tents:</span>
                <span class="summary-value"><%= booking.getNumTents() %></span>
            </div>
            
            <div class="total-amount">
                <span>Total Amount:</span>
                <span>RM <%= String.format("%.2f", booking.getTotalPrice()) %></span>
            </div>
        </div>
        
        <!-- Payment Method Selection -->
        <form action="PaymentServlet" method="post" id="paymentForm">
            <input type="hidden" name="bookingId" value="<%= bookingId %>">
            
            <div class="payment-method-section">
                <div class="section-title">
                    <i class="fas fa-wallet"></i>
                    Select Payment Method
                </div>
                
                <label class="payment-method-option" onclick="selectPaymentMethod(this, 'Credit Card')">
                    <input type="radio" name="paymentMethod" value="Credit Card" required>
                    <div class="payment-method-icon">
                        <i class="fas fa-credit-card" style="color: #667eea;"></i>
                    </div>
                    <div class="payment-method-details">
                        <div class="payment-method-name">Credit Card</div>
                        <div class="payment-method-desc">Pay securely with your credit card</div>
                    </div>
                </label>
                
                <label class="payment-method-option" onclick="selectPaymentMethod(this, 'Debit Card')">
                    <input type="radio" name="paymentMethod" value="Debit Card" required>
                    <div class="payment-method-icon">
                        <i class="fas fa-money-check" style="color: #28a745;"></i>
                    </div>
                    <div class="payment-method-details">
                        <div class="payment-method-name">Debit Card</div>
                        <div class="payment-method-desc">Pay using your debit card</div>
                    </div>
                </label>
                
                <label class="payment-method-option" onclick="selectPaymentMethod(this, 'Online Banking')">
                    <input type="radio" name="paymentMethod" value="Online Banking" required>
                    <div class="payment-method-icon">
                        <i class="fas fa-university" style="color: #17a2b8;"></i>
                    </div>
                    <div class="payment-method-details">
                        <div class="payment-method-name">Online Banking</div>
                        <div class="payment-method-desc">FPX / Internet Banking</div>
                    </div>
                </label>
                
                <label class="payment-method-option" onclick="selectPaymentMethod(this, 'E-Wallet')">
                    <input type="radio" name="paymentMethod" value="E-Wallet" required>
                    <div class="payment-method-icon">
                        <i class="fas fa-mobile-alt" style="color: #fd7e14;"></i>
                    </div>
                    <div class="payment-method-details">
                        <div class="payment-method-name">E-Wallet</div>
                        <div class="payment-method-desc">Touch 'n Go, GrabPay, Boost</div>
                    </div>
                </label>
            </div>
            
            <button type="submit" class="btn-submit-payment">
                <i class="fas fa-lock"></i> Proceed to Payment
            </button>
        </form>
        
        <div style="text-align: center;">
            <a href="bookinglist.jsp" class="btn-back">
                <i class="fas fa-arrow-left"></i> Back to Bookings
            </a>
        </div>
    </div>
</div>

<script>
function selectPaymentMethod(element, method) {
    // Remove selected class from all options
    document.querySelectorAll('.payment-method-option').forEach(option => {
        option.classList.remove('selected');
    });
    // Add selected class to clicked option
    element.classList.add('selected');
}

// Form validation
document.getElementById('paymentForm').addEventListener('submit', function(e) {
    const selectedMethod = document.querySelector('input[name="paymentMethod"]:checked');
    if (!selectedMethod) {
        e.preventDefault();
        alert('Please select a payment method');
    }
});
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
