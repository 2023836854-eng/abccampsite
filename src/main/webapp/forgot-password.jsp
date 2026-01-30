<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Forgot Password</title>
<style>
body {
	font-family: Arial, sans-serif;
	background-color: #f0f4f8;
	display: flex;
	justify-content: center;
	align-items: center;
	min-height: 100vh;
}

.container {
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

input[type="email"] {
	width: 90%;
	padding: 10px;
	margin: 10px 0;
	border-radius: 6px;
	border: 1px solid #ccc;
	font-size: 14px;
}

input[type="submit"] {
	background-color: #4CAF50;
	color: white;
	padding: 12px 20px;
	border: none;
	border-radius: 6px;
	cursor: pointer;
	font-size: 16px;
	width: 95%;
}

input[type="submit"]:hover {
	background-color: #45a049;
}

.msg {
	font-size: 14px;
	margin-bottom: 15px;
	padding: 10px;
	border-radius: 6px;
}

.msg.success {
	color: #2e7d32;
	background-color: #e8f5e9;
	border: 1px solid #4caf50;
}

.msg.error {
	color: #d32f2f;
	background-color: #ffebee;
	border: 1px solid #ef5350;
}

a {
	text-decoration: none;
	color: #2196F3;
	font-weight: bold;
	display: block;
	margin-top: 15px;
}

a:hover {
	color: #1976D2;
}
</style>
</head>
<body>
	<div class="container">
		<h2>Reset Password</h2>

		<%
		String error = (String) request.getAttribute("error");
		String success = (String) request.getAttribute("success");
		
		if (error != null) {
			out.println("<p class='msg error'>" + error + "</p>");
		}
		
		if (success != null) {
			out.println("<p class='msg success'>" + success + "</p>");
		}
		%>

		<form action="PasswordResetServlet" method="post">
			<p style="font-size: 14px; color: #555;">
				Enter your email address and we'll send you a link to reset your password.
			</p>
			Email: <input type="email" name="email" required><br>
			<input type="submit" value="Send Reset Link">
		</form>

		<a href="login.jsp">Back to Login</a>
	</div>
</body>
</html>
