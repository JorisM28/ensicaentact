<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type");

// 1. Connexion BDD (Copie tes identifiants de login_local.php)
$host = "localhost";
$db_name = "alumni_db";
$username = "alumni";
$password_bdd = "LoickPlagiat"; // Vérifie que c'est le bon mdp

try {
    $conn = new PDO("mysql:host=$host;dbname=$db_name;charset=utf8", $username, $password_bdd);
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch(PDOException $e) {
    echo json_encode(["status" => "error", "message" => "Erreur BDD: " . $e->getMessage()]);
    exit();
}

// 2. Réception des données
$data = json_decode(file_get_contents("php://input"));

if(
    !empty($data->titre) && 
    !empty($data->entreprise) && 
    !empty($data->id_auteur) // <--- Important !
) {
    // 3. La Requête SQL
    // Vérifie bien que les noms ici (titre, entreprise...) sont les mêmes que dans phpMyAdmin
    $sql = "INSERT INTO OFFRES (titre, entreprise, ville, type, description, contact_email, id_auteur) 
            VALUES (:titre, :entreprise, :ville, :type, :desc, :email, :id_auteur)";
    
    $stmt = $conn->prepare($sql);
    
    // 4. Exécution
    try {
        if($stmt->execute([
            ':titre' => $data->titre,
            ':entreprise' => $data->entreprise,
            ':ville' => $data->ville,
            ':type' => $data->type,
            ':desc' => $data->description,
            ':email' => $data->contact_email,
            ':id_auteur' => $data->id_auteur
        ])) {
            echo json_encode(["status" => "success", "message" => "Offre ajoutée"]);
        } else {
            echo json_encode(["status" => "error", "message" => "Echec de l'ajout"]);
        }
    } catch (Exception $e) {
        // Cela t'affichera l'erreur exacte si la clé étrangère ou une colonne bloque
        echo json_encode(["status" => "error", "message" => "Erreur SQL: " . $e->getMessage()]);
    }
} else {
    echo json_encode(["status" => "error", "message" => "Données incomplètes"]);
}
?>
