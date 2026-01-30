<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>ABC Campsite</title>
<style>
/* Reset & Base */
* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}

body {
    font-family: 'Poppins', sans-serif;
    background-color: #eef2f5;
}

/* Header */
header {
    background: linear-gradient(90deg, #0b3b26, #116d37);
    color: #fff;
    padding: 25px 30px;
    border-radius: 0 0 15px 15px;
    box-shadow: 0 4px 12px rgba(0,0,0,0.1);
}

/* Top Bar: Logo + Welcome */
header .top-bar {
    display: flex;
    flex-direction: column;
    align-items: center;
    margin-bottom: 15px;
}

header h1 {
    font-size: 28px;
    letter-spacing: 1px;
    margin-bottom: 5px;
}

.welcome-msg {
    font-size: 15px;
    font-weight: 500;
    color: #d8f0d8;
    font-style: italic;
}

/* Navigation */
nav {
    display: flex;
    justify-content: center;
    gap: 25px;
    background-color: rgba(255,255,255,0.1);
    padding: 10px 0;
    border-radius: 8px;
    box-shadow: 0 2px 6px rgba(0,0,0,0.1);
}

nav a {
    color: #fff;
    text-decoration: none;
    font-weight: 600;
    padding: 8px 16px;
    border-radius: 6px;
    transition: all 0.3s;
}

nav a:hover {
    background-color: rgba(255,255,255,0.25);
    transform: translateY(-2px);
    box-shadow: 0 2px 8px rgba(0,0,0,0.2);
}

nav a.active {
    background-color: rgba(255,255,255,0.35);
    box-shadow: 0 3px 10px rgba(0,0,0,0.2);
}

/* Responsive */
@media(max-width:768px){
    header h1 { font-size: 22px; }
    nav { flex-wrap: wrap; gap: 12px; }
}
</style>
</head>
<body>

<%
    Object guestObj = session.getAttribute("guestName");

    // Get current page name
    String currentPage = request.getRequestURI(); // e.g., /YourProject/bookinglist.jsp
    currentPage = currentPage.substring(currentPage.lastIndexOf("/") + 1); // bookinglist.jsp
%>

<header>
    <div class="top-bar">
        <h1>ABC Campsite</h1>
        <% if(guestObj != null) { %>
            <span class="welcome-msg">Welcome back, <b><%= guestObj %></b>!</span>
        <% } %>
    </div>
    <nav>
        <a href="index.jsp" class="<%= currentPage.equals("index.jsp") ? "active" : "" %>">Home</a>
        <a href="register.jsp" class="<%= currentPage.equals("register.jsp") ? "active" : "" %>">Sign Up</a>
        <a href="bookinglist.jsp" class="<%= currentPage.equals("bookinglist.jsp") ? "active" : "" %>">Booking</a>
        <a href="dashboard.jsp" class="<%= currentPage.equals("dashboard.jsp") ? "active" : "" %>">Dashboard</a>
    </nav>
</header>

</body>
</html>
