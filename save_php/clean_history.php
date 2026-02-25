<?php
header("Access-Control-Allow-Origin: *");
require_once "db.php";

try {
    // On vide la table de l'historique
    $pdo->exec("DELETE FROM HISTORIQUE");
    echo "<h1>Historique nettoyé avec succès ! 🧹</h1>";
    echo "<p>Tu peux retourner sur l'application et tester.</p>";
} catch (PDOException $e) {
    echo "Erreur : " . $e->getMessage();
}
?>
