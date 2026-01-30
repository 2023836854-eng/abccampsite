<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*, java.util.*" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Available Campsites</title>
<style>
body { font-family: Arial; background: #f0f4f8; padding: 20px; }
footer { text-align: center; padding: 15px; font-size: 13px; color: #777; margin-top: 20px; }
.card { border: 1px solid #ccc; padding: 20px; background: white; border-radius: 10px; max-width: 600px; margin: auto; }
input[type="submit"] { background-color: #0f9d58; color: white; border: none; padding: 10px 20px; border-radius: 5px; cursor: pointer; }
input[type="submit"]:hover { background-color: #0b7a44; }
input[type="number"] { width: 60px; }
</style>

<script>
function checkLoginAndBook(form) {
    var loggedIn = <%= (session.getAttribute("guestName") != null) ? "true" : "false" %>;
    if(!loggedIn){
        alert("You need to login or register first!");
        window.location.href = "login.jsp?redirect=availablerooms.jsp";
        return false;
    }
    return true;
}

function updateNumTents(selectInput, bookedData, quotaInput, quotaDisplayId, submitButton) {
    var date = selectInput.value;
    var booked = bookedData[date] ? bookedData[date] : 0;
    var quota = parseInt(quotaInput.dataset.quota);
    var remaining = quota - booked;

    var quotaDisplay = document.getElementById(quotaDisplayId);

    if(remaining <= 0){
        quotaDisplay.textContent = '0 (Not Available)';
        quotaInput.value = '';
        quotaInput.disabled = true;
        submitButton.disabled = true;
    } else {
        quotaDisplay.textContent = remaining;
        quotaInput.value = 1;
        quotaInput.max = remaining;
        quotaInput.disabled = false;
        submitButton.disabled = false;
    }
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

try {
    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/abccampsite", "root", "");

    PreparedStatement ps = con.prepareStatement("SELECT * FROM available_rooms WHERE campsite_id=?");
    ps.setInt(1, selectedCampsiteId);
    ResultSet rs = ps.executeQuery();

    while(rs.next()) {
        int roomId = rs.getInt("room_id");
        String name = rs.getString("name");
        String location = rs.getString("location");
        String description = rs.getString("description");
        String image = rs.getString("image");
        double price = rs.getDouble("price_per_tent");
        int quota = rs.getInt("quota");

        // Get booked tents
        PreparedStatement psBooked = con.prepareStatement(
            "SELECT booking_date, SUM(num_tents) AS booked FROM bookings WHERE campsite_id=? GROUP BY booking_date");
        psBooked.setInt(1, roomId);
        ResultSet rsBooked = psBooked.executeQuery();

        Map<String,Integer> bookedMap = new HashMap<>();
        while(rsBooked.next()){
            bookedMap.put(rsBooked.getDate("booking_date").toString(), rsBooked.getInt("booked"));
        }
        rsBooked.close();
        psBooked.close();
%>

<div class="card">
    <img src="image/<%=image%>" width="100%" height="250px"
        style="object-fit: cover; border-radius: 10px;">
    <h3><%=name%></h3>
    <p>Location: <%=location%></p>
    <p><%=description%></p>
    <p>Price per Tent: RM <%=price%></p>
    <p>Quota: <%=quota%></p>

    <form id="form-<%=roomId%>" action="booking.jsp" method="get" onsubmit="return checkLoginAndBook(this);">
        <input type="hidden" name="roomId" value="<%=roomId%>">
        <label>Booking Date:</label> 
        <input type="date" name="bookingDate" required min="<%=java.time.LocalDate.now()%>" 
               onchange='updateNumTents(this, <%=bookedMap.toString()%>, this.nextElementSibling, "quota-<%=roomId%>", document.getElementById("submit-<%=roomId%>"))'>
        <br>
        <label>Number of Tents:</label>
        <input type="number" name="numTents" min="1" max="<%=quota%>" required data-quota="<%=quota%>">
        <br><br>
        <input type="submit" id="submit-<%=roomId%>" value="Book Now">
    </form>
</div>
<br>

<%
    }
    rs.close();
    ps.close();
    con.close();
} catch(Exception e) {
    out.println("Error: " + e.getMessage());
}
%>

<footer>&copy; 2025 ABC Campsite</footer>
</body>
</html>
