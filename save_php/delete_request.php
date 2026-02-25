<?php
// delete_request.php

// -------------------------------------------------------------------
// GESTION DES HEADERS (CORS) - TRÈS IMPORTANT
// -------------------------------------------------------------------
header("Access-Control-Allow-Origin: *");
// Il est CRUCIAL d'autoriser 'Content-Type' ici pour que le JSON passe
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");
header("Access-Control-Allow-Methods: POST, OPTIONS");

// Si l'app envoie une requête de vérification (OPTIONS), on dit OK tout de suite
if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
    http_response_code(200);
    exit();
}
// -------------------------------------------------------------------

require_once "db.php";

// 1. Récupération des données
$json = file_get_contents("php://input");
$data = json_decode($json);

// 2. Vérification de l'ID
if (!empty($data->id_demande)) {
    try {
        $stmt = $pdo->prepare("DELETE FROM DEMANDE_AJOUT WHERE id_demande = ?");
        $stmt->execute([$data->id_demande]);

        if ($stmt->rowCount() > 0) {
            echo json_encode(["status" => "success", "message" => "Demande supprimée"]);
        } else {
            // Pas d'erreur SQL, mais l'ID n'existait peut-être déjà plus
            echo json_encode(["status" => "success", "message" => "Aucune demande trouvée, mais considérée comme supprimée"]);
        }
    } catch (Exception $e) {
        http_response_code(500);
        echo json_encode(["status" => "error", "message" => "Erreur SQL: " . $e->getMessage()]);
    }
} else {
    http_response_code(400);
    echo json_encode(["status" => "error", "message" => "ID manquant"]);
}
?>
