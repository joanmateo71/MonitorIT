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

$sql = "SELECT * FROM usuarios";
$result = $conn->query($sql);

if ($result->num_rows > 0) {
    // Open a text file
    $file = fopen("exportUsuaris.txt", "w");

    // Write data to the text file
    while($row = $result->fetch_assoc()) {
        fwrite($file, "ID: " . $row["id"]. " - Username: " . $row["username"]. "\n");
    }

    // Close the text file
    fclose($file);

    // Set headers to cause the browser to download the file
    header('Content-Type: text/plain');
    header('Content-Disposition: attachment; filename="exportUsuaris.txt"');
    header('Content-Length: ' . filesize("exportUsuaris.txt"));

    // Read the file content and output it to the client
    readfile("exportUsuaris.txt");
} else {
    echo "0 results";
}

$conn->close();
?>