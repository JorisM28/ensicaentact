<?php
// -------------------------------------------------------------------
// CONFIGURATION ET HEADERS
// -------------------------------------------------------------------
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

// ON VÉRIFIE L'ID EN PRIORITÉ
if(!empty($data->id)) {
    try {
        $pdo->beginTransaction();
        $idUser = $data->id;

        // ---------------------------------------------------------
        // 1. RÉCUPÉRER LES ANCIENNES DONNÉES (Ajout de autor et decede)
        // ---------------------------------------------------------
        $sqlOld = "SELECT 
                    u.nom, u.prenom, u.mail, u.tel, u.autor, u.decede,
                    t.poste AS ancien_poste,
                    l.entreprise AS ancienne_entreprise,
                    l.ville AS ancienne_ville,
                    p.filiere AS ancienne_filiere,
                    p.promo AS ancienne_promo
                   FROM UTILISATEUR u
                   LEFT JOIN TRAVAIL t ON u.id_user = t.id_user
                   LEFT JOIN LIEU l ON t.id_lieu = l.id_lieu
                   LEFT JOIN EDUCATION e ON u.id_user = e.id_user
                   LEFT JOIN PROMO p ON e.id_promo = p.id_promo
                   WHERE u.id_user = ?";
        
        $stmtUser = $pdo->prepare($sqlOld);
        $stmtUser->execute([$idUser]);
        $oldData = $stmtUser->fetch(PDO::FETCH_ASSOC);

        if($oldData) {
            
            // Préparation des nouvelles données
            $nouveauNom = $data->nom ?? $oldData['nom'];
            $nouveauPrenom = $data->prenom ?? $oldData['prenom'];
            $nouveauPoste = $data->poste ?? $oldData['ancien_poste'] ?? 'En recherche';
            $nouvelleEntreprise = $data->entreprise ?? $oldData['ancienne_entreprise'] ?? 'Non renseigné';
            $nouvelleVille = $data->ville ?? $oldData['ancienne_ville'] ?? 'Inconnue';
            $nouvelleFiliere = $data->filiere ?? $oldData['ancienne_filiere'] ?? 'Non renseignée';
            $nouvellePromo = !empty($data->promo) ? $data->promo : ($oldData['ancienne_promo'] ?? date('Y'));
            
            // --- NOUVEAUX CHAMPS ---
            // On vérifie si 'autor' est présent dans le JSON, sinon on garde l'ancien
            $nouveauAutor = isset($data->autor) ? $data->autor : ($oldData['autor'] ?? 0);
            $nouveauDecede = isset($data->decede) ? $data->decede : ($oldData['decede'] ?? 0);


            // ---------------------------------------------------------
            // 2. CRÉATION DU MESSAGE D'HISTORIQUE
            // ---------------------------------------------------------
            $changements = [];

            if ($oldData['ancien_poste'] != $nouveauPoste) $changements[] = "Poste";
            if ($oldData['ancienne_entreprise'] != $nouvelleEntreprise) $changements[] = "Entreprise";
            if ($oldData['ancienne_ville'] != $nouvelleVille) $changements[] = "Ville";
            if ($oldData['nom'] != $nouveauNom) $changements[] = "Nom";
            
            // Ajout historique pour les nouveaux champs
            if ($oldData['autor'] != $nouveauAutor) $changements[] = "Autorisation";
            if ($oldData['decede'] != $nouveauDecede) $changements[] = "Statut Décès";
            
            // Message d'action
            if (count($changements) > 0) {
                $actionMessage = "MODIF : " . implode(', ', $changements);
            } else {
                $actionMessage = "MODIFICATION (Infos identiques)";
            }

            // ---------------------------------------------------------
            // 3. MISE À JOUR DES TABLES
            // ---------------------------------------------------------

            // A. UPDATE UTILISATEUR (Ajout de autor et decede ici)
            $stmtUpdUser = $pdo->prepare("UPDATE UTILISATEUR SET nom=?, prenom=?, mail=?, tel=?, autor=?, decede=? WHERE id_user=?");
            $stmtUpdUser->execute([
                $nouveauNom,
                $nouveauPrenom,
                $data->email ?? $oldData['mail'],
                $data->tel ?? $oldData['tel'],
                $nouveauAutor,  // Nouveau champ
                $nouveauDecede, // Nouveau champ
                $idUser
            ]);

            // B. UPDATE TRAVAIL & LIEU
            $stmtTravailInfo = $pdo->prepare("SELECT id_lieu FROM TRAVAIL WHERE id_user = ?");
            $stmtTravailInfo->execute([$idUser]);
            $travail = $stmtTravailInfo->fetch(PDO::FETCH_ASSOC);

            if ($travail) {
                $idLieu = $travail['id_lieu'];
                $pdo->prepare("UPDATE TRAVAIL SET poste = ? WHERE id_user = ?")->execute([$nouveauPoste, $idUser]);
                $pdo->prepare("UPDATE LIEU SET entreprise = ?, ville = ? WHERE id_lieu = ?")->execute([$nouvelleEntreprise, $nouvelleVille, $idLieu]);
            } else {
                $pdo->prepare("INSERT INTO LIEU (entreprise, ville) VALUES (?, ?)")->execute([$nouvelleEntreprise, $nouvelleVille]);
                $idLieu = $pdo->lastInsertId();
                $pdo->prepare("INSERT INTO TRAVAIL (poste, id_user, id_lieu) VALUES (?, ?, ?)")->execute([$nouveauPoste, $idUser, $idLieu]);
            }

            // C. UPDATE PROMO
            $stmtPromo = $pdo->prepare("SELECT id_promo FROM PROMO WHERE promo = ? AND filiere = ? LIMIT 1");
            $stmtPromo->execute([$nouvellePromo, $nouvelleFiliere]);
            $promoRow = $stmtPromo->fetch(PDO::FETCH_ASSOC);
            
            if ($promoRow) {
                $idPromo = $promoRow['id_promo'];
            } else {
                $stmtNewPromo = $pdo->prepare("INSERT INTO PROMO (promo, filiere) VALUES (?, ?)");
                $stmtNewPromo->execute([$nouvellePromo, $nouvelleFiliere]);
                $idPromo = $pdo->lastInsertId();
            }
            
            $checkEdu = $pdo->prepare("SELECT id_education FROM EDUCATION WHERE id_user = ?");
            $checkEdu->execute([$idUser]);
            if ($checkEdu->fetch()) {
                 $pdo->prepare("UPDATE EDUCATION SET id_promo = ? WHERE id_user = ?")->execute([$idPromo, $idUser]);
            } else {
                 $pdo->prepare("INSERT INTO EDUCATION (id_user, id_promo, majeure) VALUES (?, ?, 'Non renseignée')")->execute([$idUser, $idPromo]);
            }

            // ---------------------------------------------------------
            // 4. HISTORIQUE
            // ---------------------------------------------------------
            $stmtLog = $pdo->prepare("INSERT INTO HISTORIQUE (action, nom_alumni, prenom_alumni, date_action) VALUES (?, ?, ?, NOW())");
            $stmtLog->execute([$actionMessage, $nouveauNom, $nouveauPrenom]);

            $pdo->commit();
            echo json_encode(["status" => "success", "message" => "Mis à jour : $actionMessage"]);

        } else {
            echo json_encode(["status" => "error", "message" => "Utilisateur introuvable avec cet ID."]);
        }
    } catch (Exception $e) {
        if ($pdo->inTransaction()) $pdo->rollBack();
        echo json_encode(["status" => "error", "message" => "Erreur SQL : " . $e->getMessage()]);
    }
} else {
    echo json_encode(["status" => "error", "message" => "ID manquant pour la modification"]);
}
?>
