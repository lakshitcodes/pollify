<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>OTP Verification</title>
    <link rel="stylesheet" href="css/OTP_style.css">
</head>
<body>
    <!-- Navbar -->
    <nav class="navbar">
        <div class="logo">Pollify</div>
        <div class="menu">
            <div><a href="#">Home</a></div>
            <div><a href="#">Register</a></div>
            <div><a href="#">Contact</a></div>
        </div>
    </nav>

    <!-- OTP Verification Form -->
    <div class="otp-container">
        <h2>Please enter the One-Time Password to verify your account</h2>
        <p>A One-Time Password has been sent to your Email</p>
        <form class="otp-form" action="verify-otp" method="post">
            <div class="otp-inputs">
                <input type="text" maxlength="1" class="otp-input" required>
                <input type="text" maxlength="1" class="otp-input" required>
                <input type="text" maxlength="1" class="otp-input" required>
                <input type="text" maxlength="1" class="otp-input" required>
                <input type="text" maxlength="1" class="otp-input" required>
                <input type="text" maxlength="1" class="otp-input" required>
            </div>
            <button type="submit" class="submit-btn">Validate</button>
        </form>
        <p class="resend">Resend One-Time Password<br><a href="#">Entered a wrong Email?</a></p>
    </div>

    <script src="JS/OTP_script.js"></script>
</body>
</html>
