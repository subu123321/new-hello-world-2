
<!DOCTYPE html>
<html>
<head>
    <title>Welcome to Class</title>
</head>
<body style="background-color:#eaf4ff; text-align:center; font-family:Arial;">

    <marquee style="background:#1565c0; color:white; padding:12px; font-size:22px;">
        Welcome to Our Class! 🎉 Learn, Practice and Grow!
    </marquee>

    <h1 style="color:#1565c0;">Welcome, Students! 👋</h1>

    <h2 style="color:#e65100;">DevOps Practical Demo</h2>

    <p style="font-size:20px; color:#2e7d32;">
        Learn Something New Today!
    </p>

    <hr>

    <h3 style="color:#6a1b9a;">Today's Date & Day</h3>

    <h2 id="date" style="color:#c62828;"></h2>

    <script>
        document.getElementById("date").innerHTML =
            new Date().toLocaleDateString("en-GB", {
                weekday: "long",
                day: "2-digit",
                month: "long",
                year: "numeric"
            });
    </script>

    <p style="color:#555;">Powered by Jenkins | Docker | Tomcat</p>

</body>
</html>
