<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="dao.*, model.*, utils.SessionUtil, java.math.BigDecimal, java.time.LocalDate, java.time.temporal.ChronoUnit" %>
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
String checkinDate = request.getParameter("checkinDate");
String checkoutDate = request.getParameter("checkoutDate");
String numTentsStr = request.getParameter("numTents");
int numTents = (numTentsStr != null) ? Integer.parseInt(numTentsStr) : 1;

RoomDAO roomDAO = new RoomDAO();
CampsiteDAO campsiteDAO = new CampsiteDAO();

AvailableRoom room = null;
Campsite campsite = null;
BigDecimal totalPrice = BigDecimal.ZERO;
long numDays = 1;

if (roomId != null && campsiteId != null && checkinDate != null && checkoutDate != null) {
    room = roomDAO.getById(Integer.parseInt(roomId));
    campsite = campsiteDAO.getById(Integer.parseInt(campsiteId));
    
    LocalDate checkIn = LocalDate.parse(checkinDate);
    LocalDate checkOut = LocalDate.parse(checkoutDate);
    numDays = ChronoUnit.DAYS.between(checkIn, checkOut);
    
    if (numDays <= 0) {
        numDays = 1;
    }
    
    if (room != null) {
        totalPrice = room.getPricePerTent().multiply(new BigDecimal(numTents)).multiply(new BigDecimal(numDays));
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
form input[type="submit"], form input[type="button"] { background: #4CAF50; color: #fff; border: none; cursor: pointer; width: 48%; display: inline-block; }
form input[type="submit"]:hover, form input[type="button"]:hover { background: #45a049; }
form input[type="button"].cancel-btn { background: #f44336; margin-left: 4%; }
form input[type="button"].cancel-btn:hover { background: #d32f2f; }
.payment-box { background: #f7f7f7; padding: 15px; border-radius: 8px; }
.price-display { background: #e8f5e9; padding: 10px; margin: 10px 0; border-radius: 6px; font-size: 18px; font-weight: bold; color: #2e7d32; }
.button-group { text-align: center; margin-top: 20px; }
</style>
</head>
<body>

<div class="container">
<h2>Confirm Your Booking</h2>
<% if (room != null && campsite != null) { %>
<form action="BookingServlet" method="post" id="bookingForm">
    <input type="hidden" name="campsiteId" value="<%=campsiteId%>">
    <input type="hidden" name="roomId" value="<%=roomId%>">
    <input type="hidden" name="checkinDate" value="<%=checkinDate%>">
    <input type="hidden" name="checkoutDate" value="<%=checkoutDate%>">
    <input type="hidden" name="numTents" value="<%=numTents%>">
    
    <label>Campsite Name</label> 
    <input type="text" value="<%=campsite.getName()%>" readonly>
    
    <label>Room Name</label> 
    <input type="text" value="<%=room.getName()%>" readonly>
    
    <label>Location</label> 
    <input type="text" value="<%=room.getLocation()%>" readonly>
    
    <label>Check-in Date</label> 
    <input type="text" value="<%=checkinDate%>" readonly>
    
    <label>Check-out Date</label> 
    <input type="text" value="<%=checkoutDate%>" readonly>
    
    <label>Number of Days</label> 
    <input type="text" value="<%=numDays%>" readonly>
    
    <label>Number of Tents</label> 
    <input type="text" value="<%=numTents%>" readonly>
    
    <label>Price per Tent per Night</label> 
    <input type="text" value="RM <%=String.format("%.2f", room.getPricePerTent())%>" readonly>
    
    <div class="price-display">
        Total Price: RM <%=String.format("%.2f", totalPrice)%>
    </div>
    
    <div class="button-group">
        <input type="button" value="Cancel" class="cancel-btn" onclick="window.location.href='availablerooms.jsp?campsiteId=<%=campsiteId%>'">
        <input type="submit" value="Confirm Booking">
    </div>
</form>
<% } else { %>
    <p style="color: red; text-align: center;">Invalid booking details. Please try again.</p>
    <a href="index.jsp" style="display: block; text-align: center; margin-top: 10px;">Back to Home</a>
<% } %>
</div>

<footer>&copy; 2025 ABC Campsite | Booking Campsite System</footer>
</body>
</html>
