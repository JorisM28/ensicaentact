<?php
// request_alumni.php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
    http_response_code(200);
    exit();
}

require_once "db.php";

$jsonRaw = file_get_contents("php://input");
$data = json_decode($jsonRaw);

if(!empty($data->nom) && !empty($data->prenom)) {
    try {
        // On insère dans la table temporaire
        $stmt = $pdo->prepare("INSERT INTO DEMANDE_AJOUT (nom, prenom, email, contenu_json) VALUES (?, ?, ?, ?)");
        
        $stmt->execute([
            $data->nom,
            $data->prenom,
            $data->email ?? '',
            $jsonRaw // On sauvegarde TOUT le JSON envoyé par Flutter pour le traiter plus tard
        ]);

        echo json_encode([
            "status" => "success", 
            "message" => "Demande envoyée pour validation."
        ]);

    } catch (Exception $e) {
        http_response_code(500);
        echo json_encode(["status" => "error", "message" => "Erreur : " . $e->getMessage()]);
    }
} else {
    http_response_code(400);
    echo json_encode(["status" => "error", "message" => "Données incomplètes"]);
}
?>
