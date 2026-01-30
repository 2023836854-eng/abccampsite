<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>ABC Campsite - Home</title>
<link rel="stylesheet" href="css/style.css">
<style>
body {
	margin: 0;
	font-family: Arial, sans-serif;
	background-color: #f8f8f8;
}

/* ===== Banner Slider ===== */
.banner-slider {
	position: relative;
	width: 100%;
	height: 400px;
	overflow: hidden;
}

.banner-slider .slides img {
	width: 100%;
	height: 400px;
	position: absolute;
	top: 0;
	left: 0;
	opacity: 0;
	transition: opacity 1s ease-in-out;
	object-fit: cover;
}

.banner-slider .slides img.active {
	opacity: 1;
}

.banner-overlay {
	position: absolute;
	top: 0;
	left: 0;
	width: 100%;
	height: 400px;
	background: rgba(0, 0, 0, 0.4);
}

.banner-text {
	position: absolute;
	top: 50%;
	left: 50%;
	transform: translate(-50%, -50%);
	color: #fff;
	text-align: center;
}

.banner-text h1 {
	font-size: 36px;
	margin-bottom: 10px;
}
.banner-text p {
	font-size: 18px;
}

/* ===== Campsite Cards ===== */
.camp-container {
	display: flex;
	flex-wrap: wrap;
	justify-content: center;
	gap: 20px;
	margin: 30px;
}

.camp-card {
	width: 300px;
	background: white;
	border-radius: 10px;
	overflow: hidden;
	box-shadow: 0 2px 8px rgba(0, 0, 0, 0.15);
	transition: transform 0.2s;
}

.camp-card:hover {
	transform: scale(1.03);
}

.camp-card img {
	width: 100%;
	height: 200px;
	object-fit: cover;
}

.camp-info {
	padding: 15px;
}

.camp-info h3 {
	margin: 0;
	font-size: 18px;
	color: #222;
}

.camp-info p {
	font-size: 14px;
	color: #555;
}

.btn-view {
	display: block;
	width: 100%;
	padding: 10px;
	background: orange;
	color: white;
	text-align: center;
	text-decoration: none;
	font-weight: bold;
	border: none;
	cursor: pointer;
}

.btn-view:hover {
	background: darkorange;
}

footer {
	text-align: center;
	padding: 15px;
	font-size: 13px;
	color: #777;
	margin-top: 20px;
}
</style>
</head>
<body>

<%@ include file="header.jsp"%>

<!-- ===== Banner Section ===== -->
<div class="banner-slider">
	<div class="slides">
		<img src="image/campsite1.jpg" class="active" alt="Campsite 1"> 
		<img src="image/campsite2.jpg" alt="Campsite 2"> 
		<img src="image/campsite3.jpg" alt="Campsite 3">
	</div>
	<div class="banner-overlay"></div>
	<div class="banner-text">
		<h1>Selamat Datang ke ABC Campsite</h1>
		<p>Pengalaman perkhemahan terbaik di seluruh Malaysia</p>
	</div>
</div>

<!-- ===== Campsite Cards Section ===== -->
<div class="camp-container">
<%
try {
    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/abccampsite", "root", "");
    Statement stmt = con.createStatement();
    ResultSet rs = stmt.executeQuery("SELECT * FROM campsites");

    while(rs.next()) {
        int campsiteId = rs.getInt("campsite_id");
        String name = rs.getString("name");
        String location = rs.getString("location");
        String description = rs.getString("description");
        String image = rs.getString("image");
%>
    <div class="camp-card">
        <img src="image/<%=image%>" alt="<%=name%>">
        <div class="camp-info">
            <h3><%=name%></h3>
            <p><%=location%></p>
            <p><%=description%></p>
            <a href="availablerooms.jsp?campsiteId=<%=campsiteId%>" class="btn-view">Lihat Tapak</a>
        </div>
    </div>
<%
    }
    rs.close();
    stmt.close();
    con.close();
} catch(Exception e) {
    out.println("Error: " + e.getMessage());
}
%>
</div>

<footer>&copy; 2025 ABC Campsite</footer>

<!-- ===== Image Slider JavaScript ===== -->
<script>
let currentSlide = 0;
const slides = document.querySelectorAll(".slides img");
const totalSlides = slides.length;

// Function to show the next image
function showNextSlide() {
	slides[currentSlide].classList.remove("active");
	currentSlide = (currentSlide + 1) % totalSlides;
	slides[currentSlide].classList.add("active");
}

// Automatically change image every 4 seconds
setInterval(showNextSlide, 4000);
</script>

</body>
</html>
