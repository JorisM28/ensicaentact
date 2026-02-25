<?php
$host = "localhost";
$db_name = "alumni_db"; 
$username = "alumni";    
$password = "LoickPlagiat"; 

try {
    $pdo = new PDO("mysql:host=$host;dbname=$db_name;charset=utf8", $username, $password);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (PDOException $e) {
    die(json_encode(["error" => "Erreur : " . $e->getMessage()]));
}
?>
