<?php
// =================================================================
// 1. CONFIGURATION & SÉCURITÉ
// =================================================================
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

// Vérification minimale
if(!empty($data->nom) && !empty($data->prenom)) {
    try {
        $pdo->beginTransaction();

        // =================================================================
        // 2. CRÉATION DE L'UTILISATEUR (CORRIGÉ)
        // =================================================================
        
        // On récupère la valeur autor envoyée par Flutter (true/false) et on la convertit en 1 ou 0
        $autorVal = !empty($data->autor) ? 1 : 0;
        
        // On laisse decede à 0 par défaut pour un nouvel ajout, sauf si spécifié
        $decedeVal = !empty($data->decede) ? 1 : 0;

        // Note les deux derniers '?' à la place de '0, 1'
        $stmtUser = $pdo->prepare("INSERT INTO UTILISATEUR (nom, prenom, age, sexe, mail, tel, decede, autor) VALUES (?, ?, ?, ?, ?, ?, ?, ?)");
        
        $stmtUser->execute([
            $data->nom,
            $data->prenom,
            (int)($data->age ?? 0),
            $data->sexe ?? 'I',       
            $data->email ?? '',
            $data->tel ?? '',
            $decedeVal,  // Insère 0 ou 1
            $autorVal    // Insère la valeur de la checkbox (0 ou 1)
        ]);
        
        $idUser = $pdo->lastInsertId();

        // =================================================================
        // 3. CRÉATION DU LIEU DE TRAVAIL ACTUEL
        // =================================================================
        $stmtLieu = $pdo->prepare("INSERT INTO LIEU (entreprise, ville, pays) VALUES (?, ?, ?)");
        $stmtLieu->execute([
            $data->entreprise ?? 'Non renseigné', 
            $data->ville ?? 'Inconnue',
            $data->pays ?? '' 
        ]);
        $idLieuTravail = $pdo->lastInsertId();

        // =================================================================
        // 4. CRÉATION DU POSTE (TRAVAIL)
        // =================================================================
        $stmtTravail = $pdo->prepare("INSERT INTO TRAVAIL (poste, id_user, id_lieu) VALUES (?, ?, ?)");
        $stmtTravail->execute([
            $data->job ?? $data->poste ?? 'Alumni', 
            $idUser, 
            $idLieuTravail
        ]);

        // =================================================================
        // 5. GESTION DE LA PROMO & FORMATION
        // =================================================================
        $annee = $data->promo ?? date("Y");
        $filiere = $data->filiere ?? 'Général';
        $formation = $data->formation ?? 'FISE'; 

        $stmtPromoCheck = $pdo->prepare("SELECT id_promo FROM PROMO WHERE promo = ? AND filiere = ? AND formation = ? LIMIT 1");
        $stmtPromoCheck->execute([$annee, $filiere, $formation]);
        $promoRow = $stmtPromoCheck->fetch(PDO::FETCH_ASSOC);

        if ($promoRow) {
            $idPromo = $promoRow['id_promo'];
        } else {
            $stmtNewPromo = $pdo->prepare("INSERT INTO PROMO (promo, filiere, formation) VALUES (?, ?, ?)");
            $stmtNewPromo->execute([$annee, $filiere, $formation]);
            $idPromo = $pdo->lastInsertId();
        }

        // =================================================================
        // 6. LIEN EDUCATION 
        // =================================================================
        $stmtEdu = $pdo->prepare("INSERT INTO EDUCATION (id_user, id_promo, majeure) VALUES (?, ?, 'Non spécifiée')");
        $stmtEdu->execute([$idUser, $idPromo]);

        // =================================================================
        // 7. GESTION DES STAGES (BOUCLE)
        // =================================================================
	if (!empty($data->stages) && is_array($data->stages)) {
            
            $stmtLieuStage = $pdo->prepare("INSERT INTO LIEU (entreprise, ville, pays) VALUES (?, ?, ?)");
            
            // MODIFICATION ICI : Ajout de la colonne description
            $stmtStage = $pdo->prepare("INSERT INTO STAGE (intitule, annee, id_user, id_lieu, entrepriseUniversite, description) VALUES (?, ?, ?, ?, 'E', ?)");

            foreach ($data->stages as $stage) {
                $entrepriseStage = $stage->entreprise ?? 'Non renseignée';
                $villeStage = $stage->ville ?? '';
                $paysStage = $stage->pays ?? '';
                
                $stmtLieuStage->execute([$entrepriseStage, $villeStage, $paysStage]);
                $idLieuStage = $pdo->lastInsertId();

                $intitule = $stage->intitule ?? 'Stage';
                $anneeStage = $stage->annee ?? '3A'; 
                // MODIFICATION ICI : Récupération de la description
                $descStage = $stage->description ?? ''; 

                // MODIFICATION ICI : Ajout de $descStage à la fin
                $stmtStage->execute([$intitule, $anneeStage, $idUser, $idLieuStage, $descStage]);
            }
        }
	//8. HISTORIQUE & FIN
        // =================================================================
        $stmtLog = $pdo->prepare("INSERT INTO HISTORIQUE (action, nom_alumni, prenom_alumni, date_action) VALUES ('AJOUT', ?, ?, NOW())");
        $stmtLog->execute([$data->nom, $data->prenom]);

        $pdo->commit();
        echo json_encode(["status" => "success", "message" => "Utilisateur ajouté avec succès."]);

    } catch (Exception $e) {
        if ($pdo->inTransaction()) {
            $pdo->rollBack();
        }
        http_response_code(500); 
        echo json_encode(["status" => "error", "message" => "Erreur SQL : " . $e->getMessage()]);
    }
} else {
    http_response_code(400); 
    echo json_encode(["status" => "error", "message" => "Nom et Prénom sont obligatoires."]);
}
?>
