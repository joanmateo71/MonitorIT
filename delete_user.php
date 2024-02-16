<?php
include 'fetch_data.php';

// Get the id from the URL parameters
$id = $_GET['id'];

// Delete a row
$sql = "DELETE FROM usuarios WHERE id = $id";
if ($conn->query($sql) === TRUE) {
    echo "Record deleted successfully";
} else {
    echo "Error deleting record: " . $conn->error;
}

// Create a new temporary table and copy the data over
$conn->query("CREATE TABLE usuarios_temp LIKE usuarios");
$conn->query("INSERT INTO usuarios_temp (username, password) SELECT username, password FROM usuarios ORDER BY id");

// Delete the old table
$conn->query("DROP TABLE usuarios");

// Rename the new table
$conn->query("RENAME TABLE usuarios_temp TO usuarios");

$conn->close();
header('Location: index.php');
?>