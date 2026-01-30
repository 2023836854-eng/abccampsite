<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="dao.*, model.*, utils.SessionUtil, java.math.BigDecimal" %>
<%
Integer guestId = SessionUtil.getGuestId(request);
if (guestId == null) {
    response.sendRedirect("login.jsp");
    return;
}

GuestDAO guestDAO = new GuestDAO();
Guest guest = guestDAO.getById(guestId);
if (guest == null) {
    response.sendRedirect("login.jsp");
    return;
}

String roomId = request.getParameter("roomId");
String campsiteId = request.getParameter("campsiteId");
String bookingDate = request.getParameter("bookingDate");
String numTentsStr = request.getParameter("numTents");
int numTents = (numTentsStr != null) ? Integer.parseInt(numTentsStr) : 1;

RoomDAO roomDAO = new RoomDAO();
CampsiteDAO campsiteDAO = new CampsiteDAO();

AvailableRoom room = null;
Campsite campsite = null;
BigDecimal totalPrice = BigDecimal.ZERO;

if (roomId != null && campsiteId != null) {
    room = roomDAO.getById(Integer.parseInt(roomId));
    campsite = campsiteDAO.getById(Integer.parseInt(campsiteId));
    
    if (room != null) {
        totalPrice = room.getPricePerTent().multiply(new BigDecimal(numTents));
    }
}
%>
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
form input, form select, form textarea { width: 100%; padding: 10px; margin: 10px 0; border-radius: 6px; border: 1px solid #ccc; box-sizing: border-box; }
form input[type="submit"] { background: #4CAF50; color: #fff; border: none; cursor: pointer; }
form input[type="submit"]:hover { background: #45a049; }
.payment-box { background: #f7f7f7; padding: 15px; border-radius: 8px; }
.price-display { background: #e8f5e9; padding: 10px; margin: 10px 0; border-radius: 6px; font-size: 18px; font-weight: bold; color: #2e7d32; }
</style>
</head>
<body>

<div class="container">
<h2>Confirm Your Booking</h2>
<% if (room != null && campsite != null) { %>
<form action="BookingServlet" method="post">
    <input type="hidden" name="campsiteId" value="<%=campsiteId%>">
    <input type="hidden" name="roomId" value="<%=roomId%>">
    <input type="hidden" name="bookingDate" value="<%=bookingDate%>">
    <input type="hidden" name="checkoutDate" value="<%=bookingDate%>">
    <input type="hidden" name="numTents" value="<%=numTents%>">
    
    <label>Campsite Name</label> 
    <input type="text" value="<%=campsite.getName()%>" readonly>
    
    <label>Room Name</label> 
    <input type="text" value="<%=room.getName()%>" readonly>
    
    <label>Location</label> 
    <input type="text" value="<%=room.getLocation()%>" readonly>
    
    <label>Booking Date</label> 
    <input type="text" value="<%=bookingDate%>" readonly>
    
    <label>Number of Tents</label> 
    <input type="text" value="<%=numTents%>" readonly>
    
    <label>Price per Tent</label> 
    <input type="text" value="RM <%=String.format("%.2f", room.getPricePerTent())%>" readonly>
    
    <div class="price-display">
        Total Price: RM <%=String.format("%.2f", totalPrice)%>
    </div>
    
    <label>Your Name</label> 
    <input type="text" value="<%=guest.getName()%>" readonly>
    
    <label>IC Number</label> 
    <input type="text" value="<%=guest.getIc()%>" readonly>
    
    <label>Phone Number</label> 
    <input type="text" value="<%=guest.getPhone() != null ? guest.getPhone() : ""%>" readonly>
    
    <label>Email</label> 
    <input type="text" value="<%=guest.getEmail()%>" readonly>
    
    <label>Address</label>
    <textarea readonly><%=guest.getAddress() != null ? guest.getAddress() : ""%></textarea>
    
    <input type="submit" value="Proceed to Payment">
</form>
<% } else { %>
    <p style="color: red; text-align: center;">Invalid booking details. Please try again.</p>
    <a href="index.jsp" style="display: block; text-align: center; margin-top: 10px;">Back to Home</a>
<% } %>
</div>

<footer>&copy; 2025 ABC Campsite | Booking Campsite System</footer>
</body>
</html>
