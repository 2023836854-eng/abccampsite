<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="dao.BookingDAO, dao.PaymentDAO, model.Booking, model.Payment" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Booking Receipt</title>
<style>
body {
	font-family: Arial, sans-serif;
	background-color: #f4f6f8;
	margin: 0;
	padding: 20px;
}

.receipt-container {
	max-width: 800px;
	margin: 20px auto;
	background: #fff;
	border-radius: 10px;
	box-shadow: 0 2px 15px rgba(0, 0, 0, 0.1);
	overflow: hidden;
}

.receipt-header {
	background: linear-gradient(90deg, #0b3b26, #116d37);
	color: #fff;
	padding: 30px;
	text-align: center;
}

.receipt-header h1 {
	margin: 0;
	font-size: 28px;
	letter-spacing: 1px;
}

.receipt-header p {
	margin: 5px 0 0;
	font-size: 14px;
	opacity: 0.9;
}

.receipt-body {
	padding: 30px;
}

.section {
	margin-bottom: 25px;
}

.section-title {
	font-size: 18px;
	font-weight: bold;
	color: #08331c;
	border-bottom: 2px solid #e0e0e0;
	padding-bottom: 8px;
	margin-bottom: 15px;
}

.info-row {
	display: flex;
	justify-content: space-between;
	padding: 8px 0;
	border-bottom: 1px solid #f0f0f0;
}

.info-label {
	font-weight: 600;
	color: #555;
}

.info-value {
	color: #333;
	text-align: right;
}

.status-badge {
	display: inline-block;
	padding: 5px 15px;
	border-radius: 20px;
	font-size: 13px;
	font-weight: bold;
	text-transform: uppercase;
}

.status-confirmed {
	background-color: #e8f5e9;
	color: #2e7d32;
}

.status-pending {
	background-color: #fff3e0;
	color: #f57c00;
}

.status-ongoing {
	background-color: #e3f2fd;
	color: #1976d2;
}

.status-completed {
	background-color: #f3e5f5;
	color: #7b1fa2;
}

.status-cancelled {
	background-color: #ffebee;
	color: #c62828;
}

.payment-paid {
	background-color: #e8f5e9;
	color: #2e7d32;
}

.payment-unpaid {
	background-color: #ffebee;
	color: #c62828;
}

.total-section {
	background-color: #f8f9fa;
	padding: 20px;
	border-radius: 8px;
	margin-top: 20px;
}

.total-row {
	display: flex;
	justify-content: space-between;
	font-size: 20px;
	font-weight: bold;
	color: #08331c;
}

.action-buttons {
	display: flex;
	gap: 15px;
	margin-top: 30px;
	justify-content: center;
}

.btn {
	padding: 12px 30px;
	border: none;
	border-radius: 6px;
	font-size: 16px;
	cursor: pointer;
	text-decoration: none;
	display: inline-block;
	transition: 0.3s;
}

.btn-primary {
	background-color: #4CAF50;
	color: white;
}

.btn-primary:hover {
	background-color: #45a049;
}

.btn-secondary {
	background-color: #2196F3;
	color: white;
}

.btn-secondary:hover {
	background-color: #1976D2;
}

.error-message {
	text-align: center;
	padding: 40px;
	color: #d32f2f;
	font-size: 16px;
}

@media print {
	body {
		background: white;
	}
	.action-buttons {
		display: none;
	}
	.receipt-container {
		box-shadow: none;
	}
}
</style>
<script>
function printReceipt() {
	window.print();
}
</script>
</head>
<body>

<%
String bookingId = request.getParameter("bookingId");
if (bookingId == null || bookingId.trim().isEmpty()) {
	bookingId = (String) session.getAttribute("lastBookingId");
}

if (bookingId == null || bookingId.trim().isEmpty()) {
	out.println("<div class='receipt-container'><div class='error-message'>No booking ID provided.</div></div>");
	return;
}

BookingDAO bookingDAO = new BookingDAO();
PaymentDAO paymentDAO = new PaymentDAO();

Booking booking = bookingDAO.getById(bookingId);
if (booking == null) {
	out.println("<div class='receipt-container'><div class='error-message'>Booking not found.</div></div>");
	return;
}

Payment payment = paymentDAO.getByBookingId(bookingId);
%>

<div class="receipt-container">
	<div class="receipt-header">
		<h1>ABC CAMPSITE</h1>
		<p>Booking Receipt</p>
	</div>
	
	<div class="receipt-body">
		<!-- Booking Information -->
		<div class="section">
			<div class="section-title">Booking Information</div>
			<div class="info-row">
				<span class="info-label">Booking ID:</span>
				<span class="info-value"><strong><%=booking.getBookingId()%></strong></span>
			</div>
			<div class="info-row">
				<span class="info-label">Booking Date:</span>
				<span class="info-value"><%=booking.getBookingDate()%></span>
			</div>
			<div class="info-row">
				<span class="info-label">Checkout Date:</span>
				<span class="info-value"><%=booking.getCheckoutDate()%></span>
			</div>
			<div class="info-row">
				<span class="info-label">Status:</span>
				<span class="info-value">
					<span class="status-badge status-<%=booking.getStatus().toLowerCase()%>">
						<%=booking.getStatus()%>
					</span>
				</span>
			</div>
		</div>
		
		<!-- Guest Information -->
		<div class="section">
			<div class="section-title">Guest Information</div>
			<div class="info-row">
				<span class="info-label">Name:</span>
				<span class="info-value"><%=booking.getGuestName() != null ? booking.getGuestName() : "N/A"%></span>
			</div>
			<div class="info-row">
				<span class="info-label">IC Number:</span>
				<span class="info-value"><%=booking.getGuestIc() != null ? booking.getGuestIc().replaceAll("-", "") : "N/A"%></span>
			</div>
			<div class="info-row">
				<span class="info-label">Phone:</span>
				<span class="info-value"><%=booking.getGuestPhone() != null ? booking.getGuestPhone().replaceAll("-", "") : "N/A"%></span>
			</div>
			<div class="info-row">
				<span class="info-label">Email:</span>
				<span class="info-value"><%=booking.getGuestEmail() != null ? booking.getGuestEmail() : "N/A"%></span>
			</div>
		</div>
		
		<!-- Campsite Information -->
		<div class="section">
			<div class="section-title">Campsite Details</div>
			<div class="info-row">
				<span class="info-label">Campsite:</span>
				<span class="info-value"><%=booking.getCampsiteName() != null ? booking.getCampsiteName() : "N/A"%></span>
			</div>
			<div class="info-row">
				<span class="info-label">Room/Area:</span>
				<span class="info-value"><%=booking.getRoomName() != null ? booking.getRoomName() : "N/A"%></span>
			</div>
			<div class="info-row">
				<span class="info-label">Number of Tents:</span>
				<span class="info-value"><%=booking.getNumTents()%></span>
			</div>
		</div>
		
		<!-- Payment Information -->
		<div class="section">
			<div class="section-title">Payment Information</div>
			<div class="info-row">
				<span class="info-label">Payment Status:</span>
				<span class="info-value">
					<span class="status-badge payment-<%=booking.getPaymentStatus().toLowerCase()%>">
						<%=booking.getPaymentStatus()%>
					</span>
				</span>
			</div>
			<% if (payment != null) { %>
			<div class="info-row">
				<span class="info-label">Payment Method:</span>
				<span class="info-value"><%=payment.getPaymentMethod()%></span>
			</div>
			<div class="info-row">
				<span class="info-label">Transaction ID:</span>
				<span class="info-value"><%=payment.getTransactionId()%></span>
			</div>
			<div class="info-row">
				<span class="info-label">Payment Date:</span>
				<span class="info-value"><%=payment.getPaymentDate()%></span>
			</div>
			<% } else { %>
			<div class="info-row">
				<span class="info-label">Payment Method:</span>
				<span class="info-value">Pending</span>
			</div>
			<% } %>
		</div>
		
		<!-- Total -->
		<div class="total-section">
			<div class="total-row">
				<span>Total Amount:</span>
				<span>RM <%=String.format("%.2f", booking.getTotalPrice())%></span>
			</div>
		</div>
		
		<!-- Action Buttons -->
		<div class="action-buttons">
			<button class="btn btn-primary" onclick="printReceipt()">Print Receipt</button>
			<a href="bookinglist.jsp" class="btn btn-secondary">Back to Bookings</a>
		</div>
	</div>
</div>

</body>
</html>
