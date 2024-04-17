<?php
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "monitoritgrup11";

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

$usuari = $_POST['usuari'];
$pwd = $_POST['pwd'];

// Directly insert user input into the query (NOT RECOMMENDED)
$sql = "SELECT * FROM usuarios WHERE username='$usuari' AND password='$pwd'";
$result = $conn->query($sql);

if ($result->num_rows > 0) {
    // If a match is found, redirect to the welcome page
    header('Location: index.php');
    exit;
} else {
    // If no match is found, redirect back to the login page
    header('Location: login.html');
    exit;
}

$conn->close();
?>