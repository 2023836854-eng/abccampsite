<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Booking Confirmed</title>
<style>
body { 
    font-family: Arial; 
    background: #f0f4f8; 
    margin: 0; 
    padding: 0; 
}
.container { 
    width: 600px; 
    margin: 40px auto; 
    background: #fff; 
    padding: 25px; 
    border-radius: 10px; 
    box-shadow: 0 2px 10px rgba(0,0,0,0.1); 
    text-align: center;
}
h2 { 
    color: #08331c; 
    margin-bottom: 20px;
}
.success-icon {
    font-size: 72px;
    color: #4CAF50;
    margin-bottom: 20px;
}
.booking-id {
    background: #e8f5e9;
    padding: 15px;
    border-radius: 8px;
    font-size: 24px;
    font-weight: bold;
    color: #2e7d32;
    margin: 20px 0;
}
.message {
    font-size: 16px;
    color: #555;
    margin-bottom: 30px;
}
.btn {
    display: inline-block;
    padding: 12px 30px;
    margin: 10px;
    border-radius: 6px;
    text-decoration: none;
    font-weight: bold;
    cursor: pointer;
}
.btn-primary {
    background: #4CAF50;
    color: white;
}
.btn-primary:hover {
    background: #45a049;
}
.btn-secondary {
    background: #2196F3;
    color: white;
}
.btn-secondary:hover {
    background: #1976D2;
}
</style>
</head>
<body>

<%
String bookingId = request.getParameter("bookingId");
if (bookingId == null || bookingId.trim().isEmpty()) {
    response.sendRedirect("index.jsp");
    return;
}
%>

<div class="container">
    <div class="success-icon">✓</div>
    <h2>Camp Booked Successfully!</h2>
    <div class="booking-id">Booking ID: <%= bookingId %></div>
    <p class="message">
        Your booking has been confirmed. Please proceed with payment to complete your reservation.
    </p>
    
    <a href="payment.jsp?bookingId=<%= bookingId %>" class="btn btn-primary">Pay Now</a>
    <a href="bookinglist.jsp" class="btn btn-secondary">View Your Bookings</a>
</div>

</body>
</html>
