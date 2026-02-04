
## Objectifs techniques fixés (découpage des tâches)

* **Avoir une connexion sécurisée**
  * Garantir l’accès aux données uniquement aux utilisateurs autorisés (authentification).
* **Pouvoir lire l’annuaire en ligne**
  * Permettre la consultation simple et rapide des profils alumni via une interface web.
* **Faire un lien entre les stages et les alumni**
  * Rendre visibles les alumni pouvant proposer ou relayer des opportunités de stage.
* **Avoir une base de données claire et accessible pour les mainteneurs**
  * Structurer les données pour faciliter la maintenance, l’évolution et la conformité RGPD.



---

## Planning prévisionnel : répartition et estimation de charge

**Benoît**

* Création de la page principale :
  * Filtres basiques.
  * Aperçu du profil et page détaillée.
* Correction et résolution des problèmes rencontrés.

**Théo**

* Vérification des boutons.
* Lien de récupération de mot de passe.
* Gestion de la page de login.
* Modification de la page de profil.

**Joris**

* Gestion de la base de données pour la coordination avec l'interface.
* Concaténation de la base alumni et de la base des stages en une nouvelle base exploitable.
* Finalisation de la connexion du compte administrateur.

**Robin**

* Gestion du GitLab :
  * Branches, merges, pipelines, déploiement.
* Gestion des mails.
* Organisation des réunions.
* Support sur les problématiques techniques transverses (BDD, sécurité, RGPD).

---

## MVP1 (définition) et éventuels autres cycles

* Avoir une application accessible avec une **recherche d’alumni** (basée sur une **base de données fictive**).
* Avoir des filtres basiques de recherche fonctionnels.
* Finaliser les **questions liées au RGPD** (quelles données, pourquoi, visibilité).
* Avoir **défini la base de données** (structure, champs, relations).
* Page admin

---

## Pépite / Caillou

|  | Appris | Utilisé | Fier | Blocage |
| --- | --- | --- | --- | --- |
| **Benoît** | Nouveau langage | Dart | Le rendu visuel | BDD manquante, blocage avec le langage |
| **Théo** | Fonctionnement authentification Microsoft | Dart | Le rendu visuel | Vérification de l'authentification d'un utilisateur fictif |
| **Joris** | Le langage Flutter, gestion de BDD | MySQL, Flutter, phpMyAdmin | Gestion du backend | Mise en lien entre la BDD et l'interface |
| **Robin** | Les pipelines sur GitLab | DataGrip, MySQL, phpMyAdmin | Déploiement continu | Gestion des BDD entre enjeux RSSI et RGPD |


## MVP 2 
- enrollemetn des alumni 
- stage universitaire/poerationnel
- description des stage/emploi

est ec que enroelement des alumni =, comment faire pour daller vers quelque part proposer un stage
formueelaire modificzaoitn et ajout

carte