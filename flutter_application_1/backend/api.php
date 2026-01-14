<?php
// Autorise Flutter Web (Chrome) à accéder à ce fichier
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

// VOS IDENTIFIANTS LOCAUX (Ceux que vous avez mis dans DataGrip)
$host = "localhost";
$db_name = "alumni"; // Vérifiez le nom exact dans DataGrip !
$username = "ben";
$password = "ben1234"; // Le mot de passe que vous aviez défini

$conn = new mysqli($host, $username, $password, $db_name);

if ($conn->connect_error) {
    die(json_encode(["error" => "Echec de connexion: " . $conn->connect_error]));
}

$conn->set_charset("utf8");

// VOTRE REQUÊTE SQL COMPLEXE
$sql = "SELECT 
            u.nom, u.prenom, u.age,
            pr.promo AS annee_promo, pr.filière,
            t.poste AS job_actuel,
            l_t.entreprise AS entreprise_job, l_t.ville AS ville_job
        FROM UTILISATEUR u
        LEFT JOIN EDUCATION e ON u.id_user = e.id_user
        LEFT JOIN PROMO pr ON e.id_promo = pr.id_promo
        LEFT JOIN TRAVAIL t ON u.id_user = t.id_user
        LEFT JOIN LIEU l_t ON t.id_lieu = l_t.id_lieu
        WHERE u.decede = 0";

$result = $conn->query($sql);

$outp = [];
if ($result && $result->num_rows > 0) {
    while($row = $result->fetch_assoc()) {
        $outp[] = $row;
    }
}

echo json_encode($outp);
$conn->close();
?>