<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Register - Pollify</title>
</head>
<body>
    <h2>Register to Pollify</h2>
    <form action="register" method="post">
        Username: <input type="text" name="username" required /><br>
        Password: <input type="password" name="password" required /><br>
        <input type="submit" value="Register" />
    </form>
    <a href="login.jsp">Login</a>
</body>
</html>
