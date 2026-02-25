<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
require_once "../db.php";

// On récupère les offres + le nom de l'auteur
$sql = "SELECT o.*, u.nom AS nom_auteur, u.prenom AS prenom_auteur 
        FROM OFFRES o 
        LEFT JOIN UTILISATEUR u ON o.id_auteur = u.id_user 
        ORDER BY o.date_ajout DESC";

$stmt = $pdo->prepare($sql);
$stmt->execute();
echo json_encode($stmt->fetchAll(PDO::FETCH_ASSOC));
?>
