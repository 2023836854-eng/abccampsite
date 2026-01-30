<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*"%>
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

input[type="text"], input[type="password"] {
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
}

.msg.success {
	color: green;
}

.msg.error {
	color: red;
}

a {
	text-decoration: none;
	color: #2196F3;
	font-weight: bold;
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
		if (request.getMethod().equalsIgnoreCase("POST")) {
			String ic = request.getParameter("ic");
			String newPassword = request.getParameter("newPassword");
			try {
				Class.forName("com.mysql.cj.jdbc.Driver");
				Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/abccampsite", "root", "");

				// Check if IC exists
				PreparedStatement psCheck = con.prepareStatement("SELECT * FROM guests WHERE ic=?");
				psCheck.setString(1, ic);
				ResultSet rs = psCheck.executeQuery();

				if (rs.next()) {
			PreparedStatement psUpdate = con.prepareStatement("UPDATE guests SET password=? WHERE ic=?");
			psUpdate.setString(1, newPassword);
			psUpdate.setString(2, ic);
			int updated = psUpdate.executeUpdate();

			if (updated > 0) {
				out.println(
						"<p class='msg success'>Password updated successfully! <a href='login.jsp'>Login here</a>.</p>");
			} else {
				out.println("<p class='msg error'>Failed to update password. Please try again.</p>");
			}
			psUpdate.close();
				} else {
			out.println("<p class='msg error'>IC Number not found!</p>");
				}
				rs.close();
				psCheck.close();
				con.close();
			} catch (Exception e) {
				out.println("<p class='msg error'>Error: " + e.getMessage() + "</p>");
			}
		}
		%>

		<form action="forgotpassword.jsp" method="post">
			IC Number: <input type="text" name="ic" required><br>
			New Password: <input type="password" name="newPassword" required><br>
			<input type="submit" value="Reset Password">
		</form>

		<p>
			<a href="login.jsp">Back to Login</a>
		</p>
	</div>
</body>
</html>
