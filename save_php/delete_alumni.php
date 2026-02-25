<?php

header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
    http_response_code(200);
    exit();
}
require_once "db.php"; 

$data = json_decode(file_get_contents("php://input"));

if(!empty($data->nom) && !empty($data->prenom)) {
    // 1. On récupère l'ID
    $stmt = $pdo->prepare("SELECT id_user FROM UTILISATEUR WHERE nom=? AND prenom=?");
    $stmt->execute([$data->nom, $data->prenom]);
    $user = $stmt->fetch(PDO::FETCH_ASSOC);

    if ($user) {
        try {
            $pdo->beginTransaction();
            $id = $user['id_user'];

            // 2. Historique
            $stmtLog = $pdo->prepare("INSERT INTO HISTORIQUE (action, nom_alumni, prenom_alumni) VALUES ('SUPPRESSION', ?, ?)");
            $stmtLog->execute([$data->nom, $data->prenom]);

            // --- NETTOYAGE COMPLET DES DÉPENDANCES ---
            
            // Supprimer le TRAVAIL lié
            $pdo->prepare("DELETE FROM TRAVAIL WHERE id_user=?")->execute([$id]);

            // Supprimer l'EDUCATION liée
            $pdo->prepare("DELETE FROM EDUCATION WHERE id_user=?")->execute([$id]);

            // Supprimer les STAGES liés (C'est la ligne qui manquait !)
            $pdo->prepare("DELETE FROM STAGE WHERE id_user=?")->execute([$id]);

            // -----------------------------------------

            // 3. Suppression de l'utilisateur (Maintenant ça va passer !)
            $del = $pdo->prepare("DELETE FROM UTILISATEUR WHERE id_user=?");
            $del->execute([$id]);

            $pdo->commit();
            echo json_encode(["status" => "success", "message" => "Succès : Utilisateur et toutes ses données supprimés."]);

        } catch (Exception $e) {
            if ($pdo->inTransaction()) {
                $pdo->rollBack();
            }
            echo json_encode(["status" => "error", "message" => "Erreur lors de la suppression : " . $e->getMessage()]);
        }
    } else {
        echo json_encode(["status" => "error", "message" => "Utilisateur introuvable."]);
    }
} else {
    echo json_encode(["status" => "error", "message" => "Nom ou Prénom manquant."]);
}
?>
