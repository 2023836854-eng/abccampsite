<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*"%>
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

form input[type="text"], form input[type="date"], form input[type="password"] {
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
	width: 100%; /* ✅ same width as login button */
}

form input[type="submit"]:hover {
	background-color: #45a049;
}

/* ✅ Login button same size and style as Register button */
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
</head>
<body>

	<div class="register-container">
		<h2>Guest Registration</h2>
		<form action="registercustomer.jsp" method="post">
			Name: <input type="text" name="name" required><br>
			IC Number: <input type="text" name="ic" required><br>
			Phone: <input type="text" name="phone" required><br>
			Date of Birth: <input type="date" name="dob" required><br>
			Address: <input type="text" name="address" required><br>
			Password: <input type="password" name="password" required><br>
			<input type="submit" value="Register">
		</form>

		<a class="login-btn" href="login.jsp">Already have an account? Login</a>
	</div>

	<%
	if (request.getMethod().equalsIgnoreCase("POST")) {
		String name = request.getParameter("name");
		String ic = request.getParameter("ic");
		String phone = request.getParameter("phone");
		String dob = request.getParameter("dob");
		String address = request.getParameter("address");
		String password = request.getParameter("password");

		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/abccampsite", "root", "");
			PreparedStatement ps = con.prepareStatement(
				"INSERT INTO guests(name, ic, phone, dob, password, address) VALUES(?,?,?,?,?,?)");
			ps.setString(1, name);
			ps.setString(2, ic);
			ps.setString(3, phone);
			ps.setString(4, dob);
			ps.setString(5, password);
			ps.setString(6, address);
			ps.executeUpdate();
			ps.close();
			con.close();

			response.sendRedirect("login.jsp?msg=registered");
		} catch (Exception e) {
			out.println("Error: " + e.getMessage());
		}
	}
	%>

</body>
</html>
