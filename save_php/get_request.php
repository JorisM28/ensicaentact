<?php
// get_requests.php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
require_once "db.php";

try {
    // On récupère tout ce qui est en attente
    $stmt = $pdo->query("SELECT id_demande, nom, prenom, date_demande, contenu_json FROM DEMANDE_AJOUT ORDER BY date_demande DESC");
    $result = $stmt->fetchAll(PDO::FETCH_ASSOC);
    
    echo json_encode($result);
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(["error" => $e->getMessage()]);
}
?>
