<!DOCTYPE html>
<html>
<head>
    <title>User List</title>
</head>
<body>
    <?php
    include 'fetch_data.php';
    ?>
    <button onclick="location.href='insert_user.php'">Insert New User</button>
    <table>
        <tr>
            <th>ID</th>
            <th>Username</th>
            <th>Edit</th>
            <th>Delete</th>
        </tr>
        <?php
        if ($result->num_rows > 0) {
            // Output data of each row
            while($row = $result->fetch_assoc()) {
                echo "<tr><td>" . $row["id"]. "</td><td>" . $row["username"]. "</td>";
                echo "<td><button onclick=\"location.href='edit_user.php?id=".$row["id"]."'\">Edit</button></td>";
                echo "<td><button onclick=\"location.href='delete_user.php?id=".$row["id"]."'\">Delete</button></td></tr>";
            }
        } else {
            echo "0 results";
        }
        $conn->close();
        ?>
    </table>
</body>
</html>