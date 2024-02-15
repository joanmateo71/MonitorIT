<?php
include 'fetch_data.php';

$id = $_GET['id'];

$sql = "SELECT * FROM usuarios WHERE id=$id";
$result = $conn->query($sql);
$row = $result->fetch_assoc();
?>

<form action="update_user.php" method="post">
    <input type="hidden" name="id" value="<?php echo $row['id']; ?>">
    Username: <input type="text" name="username" value="<?php echo $row['username']; ?>"><br>
    <input type="submit" value="Update">
</form>