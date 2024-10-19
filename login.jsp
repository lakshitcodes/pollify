<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Register - Pollify</title>
    <link rel="stylesheet" href="css/style.css">

</head>
<body>

<nav>
    <div class="logo">Pollify</div>
    <div class="menu">
        <a href="home.jsp">Home</a>
        <a href="register.jsp">Register</a>
        <a href="login.jsp">Login</a>
    </div>
</nav>

<div class="container">
    <h2>Login to Pollify</h2>
    <form action="login" method="post">
        Username: <input type="text" name="username" required /><br>
        Password: <input type="password" name="password" required /><br>
        <input type="submit" value="Login" />
    </form>
    <div class="link">

        <a href="register.jsp">Register</a>
    </div>
    
    
</div>

</body>
</html>
