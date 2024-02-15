<?php
include 'fetch_data.php';

$id = $_POST['id'];
$username = $_POST['username'];

$sql = "UPDATE usuarios SET username='$username' WHERE id=$id";

if ($conn->query($sql) === TRUE) {
    echo "Record updated successfully";
} else {
    echo "Error updating record: " . $conn->error;
}

$conn->close();
?>