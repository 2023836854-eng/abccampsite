<%@ page import="java.util.*, dao.*, model.*, utils.SessionUtil, java.time.*"%>
<%
Integer guestId = SessionUtil.getGuestId(request);
if (guestId == null) {
	response.sendRedirect("login.jsp?redirect=bookinglist.jsp");
	return;
}

BookingDAO bookingDAO = new BookingDAO();
List<Booking> bookings = bookingDAO.getByGuestId(guestId);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Your Bookings</title>
<style>
body {
	font-family: Arial;
	background: #eef2f3;
}

.container {
	width: 90%;
	margin: 30px auto;
	background: #fff;
	padding: 20px;
	border-radius: 10px;
	box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
}

table {
	width: 100%;
	border-collapse: collapse;
}

th, td {
	border: 1px solid #ddd;
	padding: 10px;
	text-align: center;
}

th {
	background: #4CAF50;
	color: #fff;
}

tr:nth-child(even) {
	background: #f9f9f9;
}

a.view-btn, a.cancel-btn, a.pay-btn {
	padding: 5px 10px;
	text-decoration: none;
	color: #fff;
	border-radius: 5px;
	display: inline-block;
	margin: 2px;
}

a.view-btn {
	background: #2196F3;
}

a.cancel-btn {
	background: #f44336;
}

a.pay-btn {
	background: #4CAF50;
}

.message {
	color: green;
	font-weight: bold;
	text-align: center;
	margin-bottom: 15px;
}

.error {
	color: red;
	font-weight: bold;
	text-align: center;
	margin-bottom: 15px;
}

.status-badge {
	padding: 4px 8px;
	border-radius: 4px;
	font-weight: bold;
	font-size: 12px;
	display: inline-block;
}

.status-pending { background: #fff59d; color: #000; }
.status-confirmed { background: #64b5f6; color: #fff; }
.status-ongoing { background: #81c784; color: #fff; }
.status-completed { background: #9e9e9e; color: #fff; }
.status-cancelled { background: #e57373; color: #fff; }
</style>
<script>
function cancelBooking(bookingId) {
	if (confirm('Are you sure you want to cancel this booking?')) {
		window.location.href = 'UpdateBookingServlet?action=cancel&bookingId=' + bookingId;
	}
}
</script>
</head>
<body>
	<%@ include file="header.jsp"%>
	<div class="container">
		<h2>Your Bookings</h2>

		<%
		String msg = request.getParameter("msg");
		if (msg != null) {
			if (msg.equals("cancelled"))
				out.println("<div class='message'>Booking cancelled successfully.</div>");
			if (msg.equals("error"))
				out.println("<div class='error'>Failed to cancel booking.</div>");
		}
		%>

		<table>
			<tr>
				<th>Booking ID</th>
				<th>Campsite</th>
				<th>Room</th>
				<th>Check-in Date</th>
				<th>Check-out Date</th>
				<th>Tents</th>
				<th>Total Price (RM)</th>
				<th>Status</th>
				<th>Payment</th>
				<th>Action</th>
			</tr>

			<%
			if (bookings.isEmpty()) {
				out.println("<tr><td colspan='10'>No bookings found.</td></tr>");
			} else {
				for (Booking booking : bookings) {
					String statusClass = "status-pending";
					String status = booking.getStatus();
					if ("Confirmed".equalsIgnoreCase(status)) statusClass = "status-confirmed";
					else if ("Ongoing".equalsIgnoreCase(status)) statusClass = "status-ongoing";
					else if ("Completed".equalsIgnoreCase(status)) statusClass = "status-completed";
					else if ("Cancelled".equalsIgnoreCase(status)) statusClass = "status-cancelled";
					
					boolean canCancel = ("Pending".equalsIgnoreCase(status) || "Confirmed".equalsIgnoreCase(status));
					boolean canPay = "Unpaid".equalsIgnoreCase(booking.getPaymentStatus()) && 
					                 !"Cancelled".equalsIgnoreCase(status);
			%>
			<tr>
				<td><%=booking.getBookingId()%></td>
				<td><%=booking.getCampsiteName()%></td>
				<td><%=booking.getRoomName()%></td>
				<td><%=booking.getBookingDate()%></td>
				<td><%=booking.getCheckoutDate()%></td>
				<td><%=booking.getNumTents()%></td>
				<td><%=String.format("%.2f", booking.getTotalPrice())%></td>
				<td><span class="status-badge <%=statusClass%>"><%=status%></span></td>
				<td><%=booking.getPaymentStatus()%></td>
				<td>
					<a class="view-btn" href="receipt.jsp?bookingId=<%=booking.getBookingId()%>">View Receipt</a>
					<%
					if (canPay) {
					%>
						<a class="pay-btn" href="payment.jsp?bookingId=<%=booking.getBookingId()%>">Pay</a>
					<%
					}
					if (canCancel) {
					%>
						<a class="cancel-btn" href="javascript:void(0);"
						   onclick="cancelBooking('<%=booking.getBookingId()%>')">Cancel</a>
					<%
					}
					%>
				</td>
			</tr>
			<%
				}
			}
			%>
		</table>
	</div>
</body>
</html>
