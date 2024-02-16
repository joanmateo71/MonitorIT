<!DOCTYPE html>
<html>

<head>
    <title>MonitorIT</title>
    <style>
        body {
            margin: 20px;
        }

        .top-bar {
            background-color: #333;
            height: 60px;
            color: white;
            display: flex;
            align-items: center;
            padding-left: 20px;
            font-size: 20px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th,
        td {
            padding: 15px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }

        tr:hover {
            background-color: #f5f5f5;
        }

        .edit-button,
        .delete-button,
        #create-button {
            background-color: #4CAF50;
            /* Green */
            color: white;
            padding: 10px 24px;
            text-align: center;
            text-decoration: none;
            display: inline-block;
            font-size: 16px;
            margin: 4px 2px;
            cursor: pointer;
            border-radius: 12px;
            /* Rounded corners */
            transition: background-color 0.3s ease;
            /* Transition effect */
        }

        .edit-button:hover,
        #create-button:hover {
            background-color: #45a049;
            /* Darker green */
        }

        .delete-button {
            background-color: #f44336;
            /* Red */
        }

        .delete-button:hover {
            background-color: #da190b;
            /* Darker red */
        }
    </style>
</head>

<body>
    <div class="top-bar">
        MonitorIT
    </div>
    <?php
    include 'fetch_data.php';
    ?>
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
            while ($row = $result->fetch_assoc()) {
                echo "<tr><td>" . $row["id"] . "</td><td>" . $row["username"] . "</td>";
                echo "<td><button class='edit-button' onclick=\"location.href='edit_user.php?id=" . $row["id"] . "'\">Edit</button></td>";
                echo "<td><button class='delete-button' onclick=\"location.href='delete_user.php?id=" . $row["id"] . "'\">Delete</button></td></tr>";
            }
        } else {
            echo "0 results";
        }
        $conn->close();
        ?>
    </table>
    <button id="create-button" onclick="location.href='insert_user.php'">Create New User</button>
    <button onclick="location.href='export_database.php'">Export Database</button>
</body>

</html>