<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Insert user</title>
</head>
<body>
    <form action="insert_user.php" method="post">
        Username: <input type="text" name="username">
        <input type="submit" value="Insert User">
    </form>
</body>
</html>

<?php
include 'fetch_data.php';


if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $username = $_POST['username'];

    $sql = "INSERT INTO usuarios (username) VALUES ('$username')";

    if ($conn->query($sql) === TRUE) {
        echo "New record created successfully";
    } else {
        echo "Error: " . $sql . "<br>" . $conn->error;
    }

    $conn->close();
}
?>