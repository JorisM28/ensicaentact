<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");
header("Content-Type: application/json; charset=UTF-8");

if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
    http_response_code(200);
    exit();
}

require_once "db.php";

// On sélectionne les infos utilisateur + Une colonne spéciale JSON pour les stages
$sql = "SELECT 
            u.id_user AS id,
            u.nom, 
            u.prenom, 
            u.mail AS email,
            u.tel,
            u.autor,
            u.decede,
            u.sexe,
            u.age,
            
            pr.promo,
            pr.filiere,
            pr.formation,
            
            e.majeure,
            e.option_ AS 'option',
            e.ddiplome AS diplome,
            
            t.poste AS job,
            t.description AS job_desc,
            l.entreprise, 
            l.ville,
            l.pays,

            /* SOUS-REQUÊTE POUR LES STAGES */
            (
                SELECT JSON_ARRAYAGG(
                    JSON_OBJECT(
                        'annee', s.annee,
                        'intitule', s.intitule,
                        'descriptionS', IFNULL(s.description, 'Non renseignée'),
                        'entrepriseUniversite', s.entrepriseUniversite,
                        'ville', IFNULL(ls.ville, 'Non renseignée'),
                        'pays', IFNULL(ls.pays, 'Non renseigné'),
                        'entreprise', IFNULL(ls.entreprise, 'Non renseignée')
                    )
                )
                FROM STAGE s
                LEFT JOIN LIEU ls ON s.id_lieu = ls.id_lieu
                WHERE s.id_user = u.id_user
            ) AS stages_list

        FROM UTILISATEUR u
        LEFT JOIN EDUCATION e ON u.id_user = e.id_user
        LEFT JOIN PROMO pr ON e.id_promo = pr.id_promo
        LEFT JOIN TRAVAIL t ON u.id_user = t.id_user
        LEFT JOIN LIEU l ON t.id_lieu = l.id_lieu
        ORDER BY u.nom ASC";

try {
    $stmt = $pdo->query($sql);
    $resultats = $stmt->fetchAll(PDO::FETCH_ASSOC);

    // Petite manipulation PHP pour décoder le JSON des stages proprement
    // car MySQL renvoie une chaîne de caractères pour le JSON
    foreach ($resultats as &$row) {
        if (!empty($row['stages_list'])) {
            $row['stages'] = json_decode($row['stages_list']);
        } else {
            $row['stages'] = [];
        }
        // On supprime la chaîne brute pour ne garder que le tableau propre
        unset($row['stages_list']);
    }

    echo json_encode($resultats, JSON_UNESCAPED_UNICODE);

} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode(["error" => "Erreur SQL : " . $e->getMessage()]);
}
?>
