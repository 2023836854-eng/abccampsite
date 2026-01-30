<%@ page import="java.sql.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Booking Details</title>
<style>
body {
	font-family: Arial;
	background: #f4f6f8;
	margin: 0;
	padding: 0;
}

.container {
	width: 500px;
	margin: 40px auto;
	background: #fff;
	padding: 20px;
	border-radius: 10px;
	box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
}

h2 {
	text-align: center;
	color: #08331c;
}

table {
	width: 100%;
	border-collapse: collapse;
}

td {
	padding: 8px;
	border-bottom: 1px solid #ddd;
}

.back-btn {
	display: block;
	text-align: center;
	margin-top: 15px;
	background: #4CAF50;
	color: white;
	padding: 10px;
	border-radius: 5px;
	text-decoration: none;
}

.back-btn:hover {
	background: #45a049;
}
</style>
</head>
<body>
	<div class="container">
		<h2>Booking Details</h2>
		<table>
			<%
			String id = request.getParameter("id");
			try {
				Class.forName("com.mysql.cj.jdbc.Driver");
				Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/abccampsite", "root", "");

				// ✅ Join bookings with campsites and available_rooms to get readable names
				String sql = "SELECT b.*, c.name AS campsite_name, r.name AS room_name "
						+ "FROM bookings b "
						+ "JOIN campsites c ON b.campsite_id = c.campsite_id "
						+ "JOIN available_rooms r ON b.room_id = r.room_id "
						+ "WHERE b.booking_id = ?";
				PreparedStatement ps = con.prepareStatement(sql);
				ps.setString(1, id);
				ResultSet rs = ps.executeQuery();

				if (rs.next()) {
			%>
			<tr>
				<td><b>Booking ID:</b></td>
				<td><%=rs.getString("booking_id")%></td>
			</tr>
			<tr>
				<td><b>Guest Name:</b></td>
				<td><%=rs.getString("guest_name")%></td>
			</tr>
			<tr>
				<td><b>Campsite:</b></td>
				<td><%=rs.getString("campsite_name")%></td>
			</tr>
			<tr>
				<td><b>Room:</b></td>
				<td><%=rs.getString("room_name")%></td>
			</tr>
			<tr>
				<td><b>Booking Date:</b></td>
				<td><%=rs.getDate("booking_date")%></td>
			</tr>
			<tr>
				<td><b>Number of Tents:</b></td>
				<td><%=rs.getInt("num_tents")%></td>
			</tr>
			<tr>
				<td><b>Total Price (RM):</b></td>
				<td><%=String.format("%.2f", rs.getDouble("total_price"))%></td>
			</tr>
			<tr>
				<td><b>Status:</b></td>
				<td><%=rs.getString("status")%></td>
			</tr>
			<tr>
				<td><b>Payment Method:</b></td>
				<td><%=rs.getString("payment_method")%></td>
			</tr>
			<%
				} else {
					out.println("<tr><td colspan='2'>No booking found.</td></tr>");
				}
				rs.close();
				ps.close();
				con.close();
			} catch (Exception e) {
				out.println("<tr><td colspan='2'>Error: " + e.getMessage() + "</td></tr>");
			}
			%>
		</table>
		<a href="bookinglist.jsp" class="back-btn">Back to List</a>
	</div>
</body>
</html>
