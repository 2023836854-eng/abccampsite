<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="dao.customerdao,model.customer,java.util.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Senarai Pelanggan</title>
<link rel="stylesheet" href="css/style.css">
</head>
<body>

	<%@ include file="header.jsp"%>

	<h2>Senarai Pelanggan</h2>
	<a href="customer_form.jsp" class="button">+ Tambah Baru</a>
	<br>
	<br>

	<%
	customerdao dao = new customerdao();
	List<customer> list = dao.getAll();
	%>

	<table border="1" cellpadding="6">
		<tr>
			<th>ID</th>
			<th>Nama</th>
			<th>Email</th>
			<th>Telefon</th>
			<th>Tindakan</th>
		</tr>

		<%
		if (list != null && !list.isEmpty()) {
			for (customer c : list) {
		%>
		<tr>
			<td><%=c.getId()%></td>
			<td><%=c.getName()%></td>
			<td><%=c.getEmail()%></td>
			<td><%=c.getPhone() != null ? c.getPhone().replace("-", "") : ""%></td>
			<td>
				<form action="customerservlet" method="post"
					style="display: inline;">
					<input type="hidden" name="action" value="reset"> <input
						type="hidden" name="id" value="<%=c.getId()%>">
					<button type="submit" class="button">Reset Password</button>
				</form> <a href="customerservlet?action=delete&id=<%=c.getId()%>"
				class="button" style="background: red;">Padam</a>
			</td>
		</tr>
		<%
		}
		} else {
		%>
		<tr>
			<td colspan="5" style="text-align: center;">Tiada rekod
				pelanggan.</td>
		</tr>
		<%
		}
		%>
	</table>



</body>
</html>
