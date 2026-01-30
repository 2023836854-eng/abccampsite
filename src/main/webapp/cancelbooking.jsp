<%@ page import="java.sql.*" %>
<%
String guestName = (String) session.getAttribute("guestName");
if(guestName == null){
    response.sendRedirect("login.jsp?redirect=bookinglist.jsp");
    return;
}

String bookingId = request.getParameter("id");
if(bookingId == null || bookingId.trim().equals("")){
    response.sendRedirect("bookinglist.jsp?msg=error");
    return;
}

try{
    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/abccampsite","root","");

    // Update booking status to 'Cancelled'
    PreparedStatement ps = con.prepareStatement("UPDATE bookings SET status='Cancelled' WHERE booking_id=? AND guest_name=?");
    ps.setString(1, bookingId);
    ps.setString(2, guestName);
    int rows = ps.executeUpdate();

    ps.close();
    con.close();

    if(rows > 0){
        response.sendRedirect("bookinglist.jsp?msg=cancelled");
    }else{
        response.sendRedirect("bookinglist.jsp?msg=error");
    }

}catch(Exception e){
    e.printStackTrace();
    response.sendRedirect("bookinglist.jsp?msg=error");
}
%>
