<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Verify Code</title>
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
margin-top: 10px;
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

.password-requirements {
font-size: 12px;
color: #666;
text-align: left;
margin: 10px 20px;
padding: 10px;
background-color: #f5f5f5;
border-radius: 4px;
}

.btn-login {
background-color: #2196F3;
color: white;
padding: 12px 20px;
border: none;
border-radius: 6px;
cursor: pointer;
font-size: 16px;
width: 95%;
margin-top: 10px;
text-decoration: none;
display: inline-block;
}

.btn-login:hover {
background-color: #1976D2;
color: white;
}
</style>
<script>
function validatePasswords() {
var password = document.forms["resetForm"]["newPassword"].value;
var confirmPassword = document.forms["resetForm"]["confirmPassword"].value;

if (password.length < 6) {
alert("Password must be at least 6 characters");
return false;
}

if (password !== confirmPassword) {
alert("Passwords do not match");
return false;
}

return true;
}
</script>
</head>
<body>
<div class="container">
<h2>Verify Code & Reset Password</h2>

<%
String error = (String) request.getAttribute("error");
String success = (String) request.getAttribute("success");

if (error != null) {
out.println("<p class='msg error'>" + error + "</p>");
}

if (success != null) {
out.println("<p class='msg success'>" + success + "</p>");
out.println("<a href='login.jsp' class='btn-login'>Go to Login</a>");
} else {
%>

<div class="password-requirements">
<strong>Instructions:</strong>
<ul style="margin: 5px 0; padding-left: 20px;">
<li>Enter the 5-character code sent to your email</li>
<li>Password must be at least 6 characters</li>
<li>Both passwords must match</li>
</ul>
</div>

<form name="resetForm" action="ResetPasswordServlet" method="post" onsubmit="return validatePasswords()">
Verification Code: <input type="text" name="code" required maxlength="5" style="text-transform: uppercase;"><br>
New Password: <input type="password" name="newPassword" required minlength="6"><br>
Confirm Password: <input type="password" name="confirmPassword" required minlength="6"><br>
<input type="submit" value="Reset Password">
</form>

<%
}
%>

<a href="forgot-password.jsp">Request New Code</a>
<a href="login.jsp">Back to Login</a>
</div>
</body>
</html>
