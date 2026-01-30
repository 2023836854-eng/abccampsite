<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Login</title>
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

.login-container {
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

.user-type {
	margin: 20px 0;
	text-align: left;
	padding-left: 20px;
}

.user-type label {
	margin-right: 20px;
	font-size: 14px;
	cursor: pointer;
}

.user-type input[type="radio"] {
	margin-right: 5px;
	cursor: pointer;
}

form input[type="text"], form input[type="password"] {
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
	width: 95%;
}

form input[type="submit"]:hover {
	background-color: #45a049;
}

.msg {
	margin-bottom: 15px;
	font-size: 14px;
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

.register-link {
	display: block;
	margin-top: 20px;
	text-decoration: none;
	color: #2196F3;
	font-weight: bold;
}

.register-link:hover {
	color: #1976D2;
}
</style>
<script>
function updateFormAction() {
	var form = document.getElementById("loginForm");
	var userType = document.querySelector('input[name="userType"]:checked').value;
	
	if (userType === "guest") {
		form.action = "LoginServlet";
	} else {
		form.action = "AdminLoginServlet";
	}
}
</script>
</head>
<body>
	<div class="login-container">
		<h2>Login</h2>

		<%
		String msg = request.getParameter("msg");
		String error = (String) request.getAttribute("error");
		String success = (String) request.getAttribute("success");
		
		if ("registered".equals(msg)) {
			out.println("<p class='msg success'>Registration successful! Please login.</p>");
		}
		
		if (error != null) {
			out.println("<p class='msg error'>" + error + "</p>");
		}
		
		if (success != null) {
			out.println("<p class='msg success'>" + success + "</p>");
		}
		%>

		<form id="loginForm" action="LoginServlet" method="post">
			<div class="user-type">
				<label>
					<input type="radio" name="userType" value="guest" checked onchange="updateFormAction()">
					Guest
				</label>
				<label>
					<input type="radio" name="userType" value="admin" onchange="updateFormAction()">
					Admin
				</label>
			</div>
			
			IC Number: <input type="text" name="ic" required><br>
			Password: <input type="password" name="password" required><br>
			<input type="submit" value="Login">
		</form>

		<a class="register-link" href="register.jsp">Don't have an account? Register</a>
		<a class="register-link" href="forgot-password.jsp">Forgot Password?</a>

	</div>
</body>
</html>
