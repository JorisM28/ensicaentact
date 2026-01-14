# Base de Données

---

## 1. Liste des informations


| Nom                     | Code      | Contrainte supplémentaires | Commentaires    |
|:------------------------|:----------|:---------------------------|:----------------|
| Nom Alumni              | nom       |                            |                 |
| Prénom Alumni           | prenom    |                            |                 |
| Intitullé poste         | poste     |                            |                 |
| Date Début              | debut     |                            |                 |
| Date fin                | fin       |                            |                 |
| Ville                   | ville     |                            |                 |
| Pays                    | pays      |                            |                 |
| Majeur                  | majeur    |                            |                 |
| Option                  | option    |                            |                 |
| Intitulé double diplôme | ddiplome  |                            |                 |
| Intitullé poste         | poste     |                            |                 |
| Promo                   | promo     |                            |                 |
| Filière                 | filiere   |                            |                 |
| Formation               | formation |                            | FISE, FISA, MTS |
| Option                  | option    |                            |                 |
| Option                  | option    |                            |                 |
| Intitullé stage         | stage     |                            |                 |
| Année stage             | annee     |                            |                 |



```mermaid
erDiagram
    UTILISATEUR ||--o{ STAGE : "réalise"
    UTILISATEUR ||--o{ TRAVAIL : "occupe"
    UTILISATEUR ||--o{ EDUCATION : "suit"
    EDUCATION }o--|| PROMO : "appartient à"
    STAGE }o--|| LIEU : "se déroule à"
    TRAVAIL }o--|| LIEU : "se situe à"
    TRAVAIL }o--|| DATE : "durant"
    STAGE }o--|| DATE : "durant"
    
    PROMO {
        int id_promo PK
        string promo
        string filiere
        string fise_fisa_mts
    }

    STAGE {
        int id_stage PK
        string intitule
        int date FK
        int id_lieu FK
        int annee_etude
    }

    UTILISATEUR {
        int id_user PK
        string nom
        string prenom
        int id_education FK 
        int id_travail FK
        int id_stage FK
    }

    TRAVAIL {
        int id_travail PK
        string poste
        int date FK
        int id_lieu FK
    }

    DATE {
        int id_date PK
        int date_debut
        int date_fin
    }
    
    LIEU {
        int id_lieu PK
        string ville
        string pays
    }

    EDUCATION {
        int id_education PK
        int id_promo FK
        string majeur
        string option
        string double_diplome
    }




```

```
