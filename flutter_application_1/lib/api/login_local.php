<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

$host = "localhost";
$db_name = "alumni";
$username = "root";
$password = ""; 

try {
    $conn = new PDO("mysql:host=$host;dbname=$db_name", $username, $password);
} catch(PDOException $e) {
    die(json_encode([
        "status" => "error",
        "message" => "Erreur connexion BDD"
    ]));
}

// Récupération des données envoyées par Flutter dans les champs
$email = $_POST['email'] ?? '';
$pw  = $_POST['password'] ?? '';

// Vérification
if(empty($email) || empty($pw)) {
    echo json_encode([
        "status" => "error",
        "message" => "Email ou mot de passe vide"
    ]);
    exit();
}

// Recherche de l'utilisateur
$stmt = $conn->prepare("SELECT id, role, password_hash, auth_source FROM users WHERE email = :email LIMIT 1");
$stmt->bindParam(":email", $email);
$stmt->execute();
$user = $stmt->fetch(PDO::FETCH_ASSOC);

if ($user && password_verify($pass, $user['password_hash'])) {
    echo json_encode([
        "status" => "success", 
        "role" => $user['role'],
        "family_name" => $user['nom'], 
        "name" => $user['prenom'],
        "email" => $email
    ]);
} else {
    echo json_encode([
        "status" => "error",
        "message" => "Utilisateur inconnu"
    ]);
}
?>