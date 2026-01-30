<%@ page import="java.sql.*, java.time.*"%>
<%
String guestName = (String) session.getAttribute("guestName");
if (guestName == null) {
	response.sendRedirect("login.jsp?redirect=bookinglist.jsp");
	return;
}
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

a.view-btn, a.cancel-btn {
	padding: 5px 10px;
	text-decoration: none;
	color: #fff;
	border-radius: 5px;
}

a.view-btn {
	background: #2196F3;
}

a.cancel-btn {
	background: #f44336;
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
</style>
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
				<th>Tent</th>
				<th>Booking Date</th>
				<th>Number of Tents</th>
				<th>Total Price (RM)</th>
				<th>Status</th>
				<th>Action</th>
			</tr>

			<%
			try {
				Class.forName("com.mysql.cj.jdbc.Driver");
				Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/abccampsite", "root", "");

				PreparedStatement ps = con.prepareStatement("SELECT b.booking_id,b.booking_date,b.num_tents,b.total_price,b.status,"
				+ "c.name AS campsite_name,r.name AS room_name " + "FROM bookings b "
				+ "JOIN campsites c ON b.campsite_id=c.campsite_id " + "JOIN available_rooms r ON b.room_id=r.room_id "
				+ "WHERE b.guest_name=? ORDER BY b.booking_date DESC");
				ps.setString(1, guestName);
				ResultSet rs = ps.executeQuery();
				boolean hasBooking = false;
				LocalDate today = LocalDate.now();

				while (rs.next()) {
					hasBooking = true;
					String bid = rs.getString("booking_id");
					String campName = rs.getString("campsite_name");
					String rName = rs.getString("room_name");
					LocalDate bDate = rs.getDate("booking_date").toLocalDate();
					int tents = rs.getInt("num_tents");
					double total = rs.getDouble("total_price");
					String status = rs.getString("status");

					// Allow cancel only if Paid AND more than 3 days before check-in
					boolean canCancel = status.equalsIgnoreCase("Paid") && !bDate.isBefore(today.plusDays(3));
			%>
			<tr>
				<td><%=bid%></td>
				<td><%=campName%></td>
				<td><%=rName%></td>
				<td><%=bDate%></td>
				<td><%=tents%></td>
				<td><%=String.format("%.2f", total)%></td>
				<td><%=status%></td>
				<td><a class="view-btn" href="viewbooking.jsp?id=<%=bid%>">View</a>
					<%
					if (canCancel) {
					%> <a class="cancel-btn"
					href="cancelbooking.jsp?id=<%=bid%>"
					onclick="return confirm('Are you sure you want to cancel this booking?');">Cancel</a>
					<%
					} else {
					%> <span style="color: gray;">Not cancellable</span> <%
 }
 %>
				</td>
			</tr>
			<%
			}
			if (!hasBooking) {
			out.println("<tr><td colspan='8'>No bookings found.</td></tr>");
			}
			rs.close();
			ps.close();
			con.close();
			} catch (Exception e) {
			out.println("<tr><td colspan='8'>Error: " + e.getMessage() + "</td></tr>");
			}
			%>
		</table>
	</div>
</body>
</html>
