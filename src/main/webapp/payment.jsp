<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*"%>
<%
String guestName = request.getParameter("guest_name");
String ic = request.getParameter("ic");
String phone = request.getParameter("phone");
String address = request.getParameter("address");
String paymentId = request.getParameter("payment_id");

int campsiteId = Integer.parseInt(request.getParameter("campsiteId"));
String bookingDateStr = request.getParameter("booking_date");
int numTents = Integer.parseInt(request.getParameter("num_tents"));

java.sql.Date bookingDate = java.sql.Date.valueOf(bookingDateStr);

java.util.Date today = new java.util.Date();
if (bookingDate.before(new java.sql.Date(today.getTime()))) {
	out.println("<p style='color:red;'>Booking date cannot be in the past!</p>");
	out.println("<a href='availablecampsite.jsp'>Back</a>");
	return;
}

try {
	Class.forName("com.mysql.cj.jdbc.Driver");
	Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/abccampsite", "root", "");

	// Check quota
	PreparedStatement psQuota = con.prepareStatement("SELECT quota FROM campsites WHERE id=?");
	psQuota.setInt(1, campsiteId);
	ResultSet rsQuota = psQuota.executeQuery();
	int quota = 0;
	if (rsQuota.next())
		quota = rsQuota.getInt("quota");
	rsQuota.close();
	psQuota.close();

	if (numTents > quota) {
		out.println("<p style='color:red;'>Not enough quota available!</p>");
		out.println("<a href='availablecampsite.jsp'>Back</a>");
		return;
	}

	// Insert booking
	PreparedStatement ps = con.prepareStatement(
	"INSERT INTO bookings(guest_name, campsite_id, booking_date, num_tents, total_price, status, phone, ic, address, payment_id) VALUES(?,?,?,?,?,?,?,?,?,?)");
	double price = 0;
	PreparedStatement psPrice = con.prepareStatement("SELECT price_per_tent FROM campsites WHERE id=?");
	psPrice.setInt(1, campsiteId);
	ResultSet rsPrice = psPrice.executeQuery();
	if (rsPrice.next())
		price = rsPrice.getDouble("price_per_tent");
	rsPrice.close();
	psPrice.close();

	double total = price * numTents;

	ps.setString(1, guestName);
	ps.setInt(2, campsiteId);
	ps.setDate(3, bookingDate);
	ps.setInt(4, numTents);
	ps.setDouble(5, total);
	ps.setString(6, "Paid"); // dummy payment
	ps.setString(7, phone);
	ps.setString(8, ic);
	ps.setString(9, address);
	ps.setString(10, paymentId);
	ps.executeUpdate();
	ps.close();

	// Update quota
	PreparedStatement psUpdate = con.prepareStatement("UPDATE campsites SET quota = quota - ? WHERE id=?");
	psUpdate.setInt(1, numTents);
	psUpdate.setInt(2, campsiteId);
	psUpdate.executeUpdate();
	psUpdate.close();

	con.close();
%>
<%
// Generate Booking ID: format BK + YYYYMMDD + random 4 digits
java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyyMMdd");
String datePart = sdf.format(new java.util.Date());
int randomNum = (int) (Math.random() * 9000) + 1000; // 1000 - 9999
String bookingId = "BK" + datePart + "-" + randomNum;
%>
<h2>Booking Confirmed!</h2>
<p>
	Name:
	<%=guestName%></p>
<p>
	IC:
	<%=ic%></p>
<p>
	Phone:
	<%=phone%></p>
<p>
	Address:
	<%=address%></p>
<p>
	Number of Tents:
	<%=numTents%></p>
<p>
	Total Paid: RM
	<%=total%></p>
<p>
	Payment ID:
	<%=paymentId%></p>
<p>Thank you for booking! Your booking is confirmed.</p>
<a href="dashboard.jsp">Back to Dashboard</a>
<%
} catch (Exception e) {
out.println("Error: " + e.getMessage());
}
%>
