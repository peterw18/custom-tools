<?php
    $servername = "";
    $username = "";
    $password = "";
    $dbname = "";

    try {
        $pdo = new PDO("mysql:host=$servername;dbname=$dbname", $username, $password);
        $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    } catch (PDOException $e) {
        die("Connection failed: " . $e->getMessage());
    }

    if ($_SERVER['REQUEST_METHOD'] === 'POST') {
        if (isset($_POST['name'])) {
            $userName = $_POST['name']; 
            
            $sql = "INSERT INTO koth (name, score) VALUES (:name, 1) 
                    ON DUPLICATE KEY UPDATE score = score + 1";
            
            $stmt = $pdo->prepare($sql);
            $stmt->execute(['name' => $userName]);
        }
    } elseif ($_SERVER['REQUEST_METHOD'] === 'GET') {
        $sql = "SELECT name FROM koth ORDER BY score DESC LIMIT 1";
        $stmt = $pdo->prepare($sql);
        $stmt->execute();

        $results = $stmt->fetchAll(PDO::FETCH_ASSOC);

        header('Content-Type: application/json');
        echo json_encode($results);
    }
?>