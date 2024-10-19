<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Login - Pollify</title>
</head>
<body>
    <h2>Login to Pollify</h2>
    <form action="login" method="post">
        Username: <input type="text" name="username" required /><br>
        Password: <input type="password" name="password" required /><br>
        <input type="submit" value="Login" />
    </form>
    <a href="register.jsp">Register</a>
</body>
</html>
