<?php
// ==========================================
// 1. EN-TÊTES
// ==========================================
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: *");
header("Content-Type: application/json; charset=UTF-8");

// ==========================================
// 2. CONFIGURATION DE LA BASE DE DONNÉES
// ==========================================
$host = "localhost";
$db_name = "alumni_db";
$username = "alumni";
$password_bdd = "LoickPlagiat";

// ==========================================

try {
    $conn = new PDO("mysql:host=$host;dbname=$db_name;charset=utf8", $username, $password_bdd);
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch(PDOException $e) {
    // Si la connexion échoue (Identifiants faux), on renvoie l'erreur
    echo json_encode(["status" => "error", "message" => "Erreur BDD: " . $e->getMessage()]);
    exit();
}

// ==========================================
// 3. RÉCUPÉRATION DES DONNÉES ENVOYÉES
// ==========================================
$email_envoye = $_POST['email'] ?? '';
$pass_envoye  = $_POST['password'] ?? '';

if(empty($email_envoye) || empty($pass_envoye)){
    echo json_encode(["status" => "error", "message" => "Champs vides"]);
    exit();
}

// ==========================================
// 4. REQUÊTE SQL (UTILISATEUR)
// ==========================================

$stmt = $conn->prepare("SELECT * FROM UTILISATEUR WHERE mail = :email LIMIT 1");
$stmt->execute(['email' => $email_envoye]);
$user = $stmt->fetch(PDO::FETCH_ASSOC);

if ($user) {
    // ==========================================
    // 5. VÉRIFICATION DU MOT DE PASSE
    // ==========================================
    // Note: Utilise password_verify() si tu as haché les mots de passe.
    // Pour l'instant, on compare en clair comme tu le faisais :
    if (isset($user['password']) && $pass_envoye === $user['password']) {
        // --- LOGIQUE DU RÔLE ---
        // On essaie de lire la colonne 'role'. Si elle n'existe pas, on met 'student' par défaut.
        // Si tu utilises la colonne 'autortinyint' (admin = 1), tu peux décommenter la ligne dessous :
        // $role = ($user['autortinyint'] == 1) ? 'admin' : 'student';
        $role = $user['role'] ?? 'student';

        // ==========================================
        // 6. RÉPONSE JSON (LE MAPPING DEMANDÉ)
        // ==========================================
        echo json_encode([
            "status"      => "success",
           //À GAUCHE : Clés pour Flutter  <==>  À DROITE : Colonnes de ta BDD
            "role"        => $user['role'],            // Mappé sur $user['role'] (ou défaut)
            "name"        => $user['prenom'],  // Mappé sur 'prenom'
            "family_name" => $user['nom'],     // Mappé sur 'nom'
            "email"       => $user['mail'],    // Mappé sur 'mail'
            "phone"       => $user['tel']      // Mappé sur 'tel'
        ]);

    } else {
        echo json_encode(["status" => "error", "message" => "Mot de passe incorrect"]);
    }
} else {
    echo json_encode(["status" => "error", "message" => "Email introuvable"]);
}
?>
