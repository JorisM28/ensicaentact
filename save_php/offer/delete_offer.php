<?php
// On affiche les erreurs pour le debug (à retirer en prod)
ini_set('display_errors', 1);
error_reporting(E_ALL);

header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type");

// ==========================================
// 1. CONNEXION DIRECTE (On n'utilise plus db.php pour éviter l'erreur de nom)
// ==========================================
$host = "localhost";
$db_name = "alumni_db";
$username = "alumni";
$password_bdd = "LoickPlagiat";

try {
    $conn = new PDO("mysql:host=$host;dbname=$db_name;charset=utf8", $username, $password_bdd);
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch(PDOException $e) {
    echo json_encode(["status" => "error", "message" => "Erreur de connexion BDD : " . $e->getMessage()]);
    exit();
}

// ==========================================
// 2. RÉCUPÉRATION
// ==========================================
$input = file_get_contents("php://input");
$data = json_decode($input);

// ==========================================
// 3. TRAITEMENT
// ==========================================
// On vérifie que l'ID est là
if(!empty($data->id_offre)) {
    
    try {
        $sql = "DELETE FROM OFFRES WHERE id_offre = :id";
        $stmt = $conn->prepare($sql);
        
        if($stmt->execute([':id' => $data->id_offre])) {
            echo json_encode(["status" => "success", "message" => "Offre supprimée"]);
        } else {
            echo json_encode(["status" => "error", "message" => "Echec suppression SQL"]);
        }
    } catch (Exception $e) {
        echo json_encode(["status" => "error", "message" => "Exception SQL : " . $e->getMessage()]);
    }

} else {
    echo json_encode([
        "status" => "error", 
        "message" => "ID manquant",
        "recu" => $input
    ]);
}
?>
