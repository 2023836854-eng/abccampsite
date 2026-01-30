<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Register Guest</title>
<link rel="stylesheet" href="css/style.css">
<style>
body {
	font-family: Arial, sans-serif;
	background-color: #f0f4f8;
	margin: 0;
	padding: 0;
	display: flex;
	justify-content: center;
	align-items: center;
	min-height: 100vh;
}

.register-container {
	background-color: #fff;
	padding: 30px 40px;
	border-radius: 12px;
	box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
	width: 400px;
	text-align: center;
}

h2 {
	margin-bottom: 25px;
	color: #08331c;
}

.msg {
	margin-bottom: 15px;
	font-size: 14px;
	padding: 10px;
	border-radius: 6px;
}

.msg.error {
	color: #d32f2f;
	background-color: #ffebee;
	border: 1px solid #ef5350;
}

form input[type="text"], form input[type="date"], form input[type="password"], form input[type="email"] {
	width: 90%;
	padding: 10px;
	margin: 10px 0;
	border-radius: 6px;
	border: 1px solid #ccc;
	font-size: 14px;
}

form input[type="submit"] {
	background-color: #4CAF50;
	color: white;
	padding: 12px 20px;
	border: none;
	border-radius: 6px;
	cursor: pointer;
	font-size: 16px;
	margin-top: 15px;
	width: 100%;
}

form input[type="submit"]:hover {
	background-color: #45a049;
}

.login-btn {
	display: block;
	margin-top: 15px;
	text-decoration: none;
	background-color: #2196F3;
	color: white;
	padding: 12px 20px;
	border-radius: 6px;
	font-weight: bold;
	font-size: 16px;
	width: 90%;
	text-align: center;
	transition: 0.3s;
}

.login-btn:hover {
	background-color: #1976D2;
}
</style>
<script>
function validateForm() {
	var name = document.forms["registerForm"]["name"].value;
	var ic = document.forms["registerForm"]["ic"].value;
	var email = document.forms["registerForm"]["email"].value;
	var phone = document.forms["registerForm"]["phone"].value;
	var password = document.forms["registerForm"]["password"].value;
	
	if (name.trim() === "") {
		alert("Name is required");
		return false;
	}
	
	if (ic.trim() === "") {
		alert("IC Number is required");
		return false;
	}
	
	if (email.trim() === "") {
		alert("Email is required");
		return false;
	}
	
	var emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
	if (!emailPattern.test(email)) {
		alert("Please enter a valid email address");
		return false;
	}
	
	if (phone.trim() === "") {
		alert("Phone is required");
		return false;
	}
	
	if (password.length < 6) {
		alert("Password must be at least 6 characters");
		return false;
	}
	
	return true;
}
</script>
</head>
<body>

	<div class="register-container">
		<h2>Guest Registration</h2>
		
		<%
		String error = (String) request.getAttribute("error");
		if (error != null) {
			out.println("<p class='msg error'>" + error + "</p>");
		}
		%>
		
		<form name="registerForm" action="RegisterServlet" method="post" onsubmit="return validateForm()">
			Name: <input type="text" name="name" required><br>
			IC Number: <input type="text" name="ic" required><br>
			Email: <input type="email" name="email" required><br>
			Phone: <input type="text" name="phone" required><br>
			Date of Birth: <input type="date" name="dob" required><br>
			Address: <input type="text" name="address" required><br>
			Password: <input type="password" name="password" required minlength="6"><br>
			<input type="submit" value="Register">
		</form>

		<a class="login-btn" href="login.jsp">Already have an account? Login</a>
	</div>

</body>
</html>
