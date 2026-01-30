<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Daftar Pelanggan Baru</title>
<link rel="stylesheet" href="css/style.css">
</head>
<body>
	<%@ include file="header.jsp"%>

	<h2>Daftar Pelanggan Baru</h2>

	<form action="customerservlet" method="post">
		<input type="hidden" name="action" value="insert"> <label>Nama:</label><br>
		<input type="text" name="name" required><br>
		<br> <label>Email:</label><br> <input type="email"
			name="email" required><br>
		<br> <label>Telefon:</label><br> <input type="text"
			name="phone" required><br>
		<br> <label>Kata Laluan:</label><br> <input type="password"
			name="password" required><br>
		<br>

		<button type="submit" class="button">Simpan</button>
	</form>
</body>
</html>