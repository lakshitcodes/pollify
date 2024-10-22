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
        <form class="otp-form" action="verify-otp" method="post" onsubmit="combineOTP()">
            <input type="hidden" name="email" value="${email}"> <!-- Assuming email is stored in session or passed via form -->
            
            <!-- Hidden field to store the combined OTP -->
            <input type="hidden" name="otp" id="otp" value="">
            
            <div class="otp-inputs">
                <!-- Six separate input fields for the OTP -->
                <input type="text" maxlength="1" class="otp-input" id="otp1" required>
                <input type="text" maxlength="1" class="otp-input" id="otp2" required>
                <input type="text" maxlength="1" class="otp-input" id="otp3" required>
                <input type="text" maxlength="1" class="otp-input" id="otp4" required>
                <input type="text" maxlength="1" class="otp-input" id="otp5" required>
                <input type="text" maxlength="1" class="otp-input" id="otp6" required>
            </div>
            
            <button type="submit" class="submit-btn">Validate</button>
        </form>
        
        
        <p class="resend">Resend One-Time Password<br><a href="#">Entered a wrong Email?</a></p>
    </div>
    <script>
        // Function to combine the 6 separate OTP fields into one hidden input field before submission
        function combineOTP() {
            var otp = '';
            for (var i = 1; i <= 6; i++) {
                otp += document.getElementById('otp' + i).value;
            }
            document.getElementById('otp').value = otp;
        }
    </script>
    <script src="js/OTP_script.js"></script>
</body>
</html>
