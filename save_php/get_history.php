<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
require_once "db.php";

$stmt = $pdo->query("SELECT action, nom_alumni, prenom_alumni, date_action FROM HISTORIQUE ORDER BY date_action DESC");
echo json_encode($stmt->fetchAll(PDO::FETCH_ASSOC));
?>
