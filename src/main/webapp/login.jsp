<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Login Guest</title>
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
}

.msg.success {
	color: green;
}

.msg.error {
	color: red;
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
</head>
<body>
	<div class="login-container">
		<h2>Guest Login</h2>

		<%
		String msg = request.getParameter("msg");
		String redirectPage = request.getParameter("redirect"); // ambil page nak redirect
		if (redirectPage == null || redirectPage.isEmpty()) {
			redirectPage = "index.jsp"; // default ke index
		}

		if ("registered".equals(msg)) {
			out.println("<p class='msg success'>Registration successful! Please login.</p>");
		}

		if (request.getMethod().equalsIgnoreCase("POST")) {
			String ic = request.getParameter("ic");
			String password = request.getParameter("password");
			try {
				Class.forName("com.mysql.cj.jdbc.Driver");
				Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/abccampsite", "root", "");
				PreparedStatement ps = con.prepareStatement("SELECT name FROM guests WHERE ic=? AND password=?");
				ps.setString(1, ic);
				ps.setString(2, password);
				ResultSet rs = ps.executeQuery();
				if (rs.next()) {
			session.setAttribute("guestName", rs.getString("name"));
			response.sendRedirect(redirectPage); 
			out.println("<p class='msg error'>IC Number or Password incorrect!</p>");
				}
				rs.close();
				ps.close();
				con.close();
			} catch (Exception e) {
				out.println("<p class='msg error'>Error: " + e.getMessage() + "</p>");
			}
		}
		%>

		<form action="login.jsp" method="post">
			<input type="hidden" name="redirect" value="<%=redirectPage%>">
			IC Number: <input type="text" name="ic" required><br>
			Password: <input type="password" name="password" required><br>
			<input type="submit" value="Login">
		</form>

		<a class="register-link"
			href="registercustomer.jsp?redirect=<%=redirectPage%>">Don't
			have an account? Register</a> <a class="register-link"
			href="forgotpassword.jsp">Forgot Password?</a>

	</div>
</body>
</html>
