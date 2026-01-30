<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Book Campsite</title>
<style>
body { font-family: Arial; background: #f0f4f8; margin: 0; padding: 0; }
.container { width: 600px; margin: 40px auto; background: #fff; padding: 25px; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
footer { text-align: center; padding: 15px; font-size: 13px; color: #777; margin-top: 20px; }
h2 { text-align: center; color: #08331c; }
form input, form select, form textarea { width: 100%; padding: 10px; margin: 10px 0; border-radius: 6px; border: 1px solid #ccc; }
form input[type="submit"] { background: #4CAF50; color: #fff; border: none; cursor: pointer; }
form input[type="submit"]:hover { background: #45a049; }
.payment-box { background: #f7f7f7; padding: 15px; border-radius: 8px; }
</style>
</head>
<body>

<%
String guestName = (String) session.getAttribute("guestName");
if (guestName == null || guestName.isEmpty()) {
    response.sendRedirect("login.jsp");
    return;
}

String roomId = request.getParameter("roomId");
String bookingDate = request.getParameter("bookingDate");
String numTentsStr = request.getParameter("numTents");
int numTents = (numTentsStr != null) ? Integer.parseInt(numTentsStr) : 1;

String campsiteName = "";
String roomName = "";

if (roomId != null) {
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/abccampsite", "root", "");

        // Get room info
        PreparedStatement psRoom = con.prepareStatement("SELECT name, campsite_id FROM available_rooms WHERE room_id=?");
        psRoom.setInt(1, Integer.parseInt(roomId));
        ResultSet rsRoom = psRoom.executeQuery();
        int campsiteId = 0;
        if (rsRoom.next()) {
            roomName = rsRoom.getString("name");
            campsiteId = rsRoom.getInt("campsite_id");
        }
        rsRoom.close();
        psRoom.close();

        // Get campsite name
        PreparedStatement psCamp = con.prepareStatement("SELECT name FROM campsites WHERE campsite_id=?");
        psCamp.setInt(1, campsiteId);
        ResultSet rsCamp = psCamp.executeQuery();
        if (rsCamp.next()) {
            campsiteName = rsCamp.getString("name");
        }
        rsCamp.close();
        psCamp.close();

        con.close();
    } catch (Exception e) {
        e.printStackTrace(); // logs error to server console
        out.println("Error loading data: " + e.getMessage());
    }
}

// Handle form submission
if ("POST".equalsIgnoreCase(request.getMethod())) {
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/abccampsite", "root", "");

        int rId = Integer.parseInt(request.getParameter("roomId"));
        String bDate = request.getParameter("bookingDate");
        int tents = Integer.parseInt(request.getParameter("numTents"));
        String phone = request.getParameter("phone");
        String ic = request.getParameter("ic");
        String address = request.getParameter("address");
        String paymentMethod = request.getParameter("paymentMethod");

        // Get room info for quota and campsite_id
        PreparedStatement psQuota = con.prepareStatement("SELECT campsite_id, quota, price_per_tent FROM available_rooms WHERE room_id=?");
        psQuota.setInt(1, rId);
        ResultSet rsQuota = psQuota.executeQuery();
        int quota = 0, campsiteId = 0;
        double pricePerTent = 0;
        if (rsQuota.next()) {
            quota = rsQuota.getInt("quota");
            campsiteId = rsQuota.getInt("campsite_id");
            pricePerTent = rsQuota.getDouble("price_per_tent");
        }
        rsQuota.close();
        psQuota.close();

        // Check existing bookings
        PreparedStatement psCheck = con.prepareStatement("SELECT SUM(num_tents) AS booked FROM bookings WHERE campsite_id=? AND booking_date=?");
        psCheck.setInt(1, campsiteId);
        psCheck.setDate(2, java.sql.Date.valueOf(bDate));
        ResultSet rsCheck = psCheck.executeQuery();
        int booked = 0;
        if (rsCheck.next()) booked = rsCheck.getInt("booked");
        rsCheck.close();
        psCheck.close();

        if (booked + tents > quota) {
%>
<script>
alert("Booking failed! Only <%= (quota - booked) > 0 ? (quota - booked) : 0 %> tents are available for <%= bDate %>.");
window.history.back();
</script>
<%
        } else {
            // Generate booking ID
            String lastId = null;
            PreparedStatement ps0 = con.prepareStatement("SELECT booking_id FROM bookings ORDER BY booking_id DESC LIMIT 1");
            ResultSet rs0 = ps0.executeQuery();
            if (rs0.next()) lastId = rs0.getString("booking_id");
            rs0.close();
            ps0.close();
            String bookingId = (lastId == null) ? "B001" : String.format("B%03d", Integer.parseInt(lastId.substring(1)) + 1);

            // Calculate total price
            double total = tents * pricePerTent;

            // Insert booking
            PreparedStatement psInsert = con.prepareStatement(
                "INSERT INTO bookings (booking_id, guest_name, campsite_id, room_id, booking_date, num_tents, total_price, status, phone, ic, address, payment_method, created_at, updated_at) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,NOW(),NOW())");
            psInsert.setString(1, bookingId);
            psInsert.setString(2, guestName);
            psInsert.setInt(3, campsiteId);
            psInsert.setInt(4, rId);
            psInsert.setDate(5, java.sql.Date.valueOf(bDate));
            psInsert.setInt(6, tents);
            psInsert.setDouble(7, total);
            psInsert.setString(8, "Paid");
            psInsert.setString(9, phone);
            psInsert.setString(10, ic);
            psInsert.setString(11, address);
            psInsert.setString(12, paymentMethod);
            psInsert.executeUpdate();
            psInsert.close();

            con.close();

            response.sendRedirect("bookinglist.jsp");
            return;
        }
    } catch(Exception e) {
        e.printStackTrace(); // logs error
        out.println("<script>alert('Error: " + e.getMessage() + "'); history.back();</script>");
        return;
    }
}
%>

<div class="container">
<h2>Confirm Your Booking</h2>
<form action="booking.jsp" method="post">
    <label>Campsite Name</label> 
    <input type="text" name="campsiteName" value="<%=campsiteName%>" readonly>
    
    <label>Room Name</label> 
    <input type="text" name="roomName" value="<%=roomName%>" readonly>
    <input type="hidden" name="roomId" value="<%=roomId%>">
    
    <label>Booking Date</label> 
    <input type="text" name="bookingDate" value="<%=bookingDate%>" readonly>
    
    <label>Number of Tents</label> 
    <input type="text" name="numTents" value="<%=numTents%>" readonly>
    
    <label>Your Name</label> 
    <input type="text" name="guestName" value="<%=guestName%>" readonly>
    
    <label>Phone Number</label> 
    <input type="text" name="phone" placeholder="Enter phone number" required>
    
    <label>IC Number</label> 
    <input type="text" name="ic" placeholder="Enter IC number" required>
    
    <label>Address</label>
    <textarea name="address" placeholder="Enter your address" required></textarea>
    
    <label>Payment Method</label>
    <select name="paymentMethod" id="paymentMethod" onchange="showPaymentFields()" required>
        <option value="">-- Select Payment Method --</option>
        <option value="Debit Card">Debit Card</option>
        <option value="Online Banking">Online Banking</option>
    </select>
    
    <div id="paymentDetails" class="payment-box" style="display: none;">
        <div id="debitBox" style="display: none;">
            <label>Card Number</label> 
            <input type="text" name="cardNumber" placeholder="XXXX-XXXX-XXXX-XXXX">
        </div>
        <div id="bankBox" style="display: none;">
            <label>Bank Name</label> 
            <select name="bankName">
                <option value="">--Choose Bank--</option>
                <option value="Maybank">Maybank</option>
                <option value="CIMB">CIMB</option>
                <option value="RHB">RHB</option>
                <option value="Public Bank">Public Bank</option>
            </select>
            <p style="color: green;">Dummy: Payment simulated successfully</p>
        </div>
    </div>
    
    <input type="submit" value="Confirm Booking">
</form>
</div>

<script>
function showPaymentFields() {
    var method = document.getElementById("paymentMethod").value;
    document.getElementById("paymentDetails").style.display = method ? "block" : "none";
    document.getElementById("debitBox").style.display = (method === "Debit Card") ? "block" : "none";
    document.getElementById("bankBox").style.display = (method === "Online Banking") ? "block" : "none";
}
</script>

<footer>&copy; 2025 ABC Campsite | Booking Campsite System</footer>
</body>
</html>
