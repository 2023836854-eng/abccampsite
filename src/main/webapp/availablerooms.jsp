<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.util.*, dao.*, model.*, utils.SessionUtil" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Available Rooms</title>
<style>
body { font-family: Arial; background: #f0f4f8; padding: 20px; }
footer { text-align: center; padding: 15px; font-size: 13px; color: #777; margin-top: 20px; }
.card { border: 1px solid #ccc; padding: 20px; background: white; border-radius: 10px; max-width: 600px; margin: 20px auto; }
input[type="submit"] { background-color: #0f9d58; color: white; border: none; padding: 10px 20px; border-radius: 5px; cursor: pointer; }
input[type="submit"]:hover { background-color: #0b7a44; }
input[type="number"], input[type="date"] { padding: 8px; border-radius: 5px; border: 1px solid #ccc; }
.room-info { margin: 10px 0; }
.room-info p { margin: 5px 0; color: #555; }
.price { color: #0f9d58; font-weight: bold; font-size: 16px; }
</style>

<script>
function checkLoginAndBook(form) {
    var loggedIn = <%= (SessionUtil.isGuestLoggedIn(request)) ? "true" : "false" %>;
    if(!loggedIn){
        alert("You need to login or register first!");
        window.location.href = "login.jsp?redirect=availablerooms.jsp";
        return false;
    }
    return true;
}
</script>

</head>
<%@ include file="header.jsp"%>
<body>

<h2 style="text-align: center;">Available Rooms</h2>

<%
int selectedCampsiteId = 0;
if(request.getParameter("campsiteId") != null) {
    selectedCampsiteId = Integer.parseInt(request.getParameter("campsiteId"));
}

RoomDAO roomDAO = new RoomDAO();
CampsiteDAO campsiteDAO = new CampsiteDAO();
List<AvailableRoom> rooms = roomDAO.getActiveByCampsite(selectedCampsiteId);
Campsite campsite = campsiteDAO.getById(selectedCampsiteId);

if (campsite != null) {
%>
    <h3 style="text-align: center; color: #333;"><%=campsite.getName()%> - <%=campsite.getLocation()%></h3>
<%
}

if (rooms.isEmpty()) {
%>
    <div class="card">
        <p style="text-align: center; color: #777;">No rooms available for this campsite.</p>
        <a href="index.jsp" style="display: block; text-align: center; margin-top: 10px;">Back to Home</a>
    </div>
<%
} else {
    for (AvailableRoom room : rooms) {
%>

<div class="card">
    <% if (room.getImage() != null && !room.getImage().isEmpty()) { %>
    <img src="image/<%=room.getImage()%>" width="100%" height="250px"
        style="object-fit: cover; border-radius: 10px;">
    <% } %>
    <h3><%=room.getName()%></h3>
    <div class="room-info">
        <p><strong>Location:</strong> <%=room.getLocation()%></p>
        <p><strong>Description:</strong> <%=room.getDescription()%></p>
        <p class="price">Price per Tent: RM <%=String.format("%.2f", room.getPricePerTent())%></p>
        <p><strong>Available Quota:</strong> <%=room.getAvailableQuota()%> tents</p>
    </div>

    <form action="booking.jsp" method="get" onsubmit="return checkLoginAndBook(this);">
        <input type="hidden" name="roomId" value="<%=room.getRoomId()%>">
        <input type="hidden" name="campsiteId" value="<%=selectedCampsiteId%>">
        <label>Check-in Date:</label> 
        <input type="date" name="checkinDate" required min="<%=java.time.LocalDate.now()%>">
        <br><br>
        <label>Check-out Date:</label> 
        <input type="date" name="checkoutDate" required min="<%=java.time.LocalDate.now().plusDays(1)%>">
        <br><br>
        <label>Number of Tents:</label>
        <input type="number" name="numTents" min="1" max="<%=room.getAvailableQuota()%>" value="1" required>
        <br><br>
        <% if (room.getAvailableQuota() > 0) { %>
            <input type="submit" value="Book Now">
        <% } else { %>
            <input type="submit" value="Fully Booked" disabled>
        <% } %>
    </form>
</div>
<br>

<%
    }
}
%>

<footer>&copy; 2025 ABC Campsite</footer>
</body>
</html>
