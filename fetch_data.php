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

$sql = "SELECT id, username FROM usuarios";
$result = $conn->query($sql);
?>