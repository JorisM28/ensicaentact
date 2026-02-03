// Petite classe pour gérer un stage individuel
class Stage {
  final String annee;      // "1A", "2A", "3A"
  final String intitule;
  final String description;
  final String type;
  final String ville;
  final String pays;
  final String entreprise;

  Stage({
    required this.annee,
    required this.intitule,
    required this.type,
    required this.description,

    required this.ville,
    required this.pays,
    required this.entreprise,
  });

  factory Stage.fromJson(Map<String, dynamic> json) {
    return Stage(
      annee: json['annee']?.toString() ?? '',
      intitule: json['intitule']?.toString() ?? '',
      ville: json['ville']?.toString() ?? '',
      description: json['descriptionS']?.toString() ?? '',
      type: json['entrepriseUniversite']?.toString() ?? 'I',
      pays: json['pays']?.toString() ?? '',
      entreprise: json['entreprise']?.toString() ?? '',
    );
  }
}

class Alumnis {
  final int id;
  final String nom;
  final String prenom;
  final String email;
  final String tel;
  final int autor;
  final int decede;
  final String sexe;
  final int age;
  final int promo;
  final String filiere;
  final String formation;
  final String majeure;
  final String option;
  final String diplome;
  final String job;
  final String jobDescription;
  final String entreprise;
  final String ville;
  final String pays;


  final List<Stage> stages;

  Alumnis({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.email,
    required this.tel,
    required this.autor,
    required this.decede,
    required this.sexe,
    required this.age,
    required this.promo,
    required this.filiere,
    required this.formation,
    required this.majeure,
    required this.option,
    required this.diplome,
    required this.job,
    required this.jobDescription,
    required this.entreprise,
    required this.ville,
    required this.pays,
    required this.stages,
  });

  String get nomComplet => "${decede == 1 ? "† " : ""}$prenom $nom";

  factory Alumnis.fromMap(Map<String, dynamic> map) {
    // Gestion de la liste des stages reçue du JSON
    var listStages = map['stages'] as List<dynamic>?;
    List<Stage> stagesList = listStages != null 
        ? listStages.map((i) => Stage.fromJson(i)).toList() 
        : [];

    return Alumnis(
      id: int.tryParse(map['id'].toString()) ?? 0,
      nom: map['nom']?.toString() ?? '',
      prenom: map['prenom']?.toString() ?? '',
      email: map['email']?.toString() ?? '',
      tel: map['tel']?.toString() ?? '',
      autor: int.tryParse(map['autor'].toString()) ?? 0,
      decede: int.tryParse(map['decede'].toString()) ?? 0,
      sexe: map['sexe']?.toString() ?? 'I',
      age: int.tryParse(map['age'].toString()) ?? 0,
      promo: int.tryParse(map['promo'].toString()) ?? 0,
      filiere: map['filiere']?.toString() ?? '',
      formation: map['formation']?.toString() ?? '',
      majeure: map['majeure']?.toString() ?? '',
      option: map['option']?.toString() ?? '',
      diplome: map['diplome']?.toString() ?? '',
      job: map['job']?.toString() ?? 'En recherche',
      jobDescription: map['job_desc']?.toString() ?? '',
      entreprise: map['entreprise']?.toString() ?? 'Non renseigné',
      ville: map['ville']?.toString() ?? '',
      pays: map['pays']?.toString() ?? '',
      
      stages: stagesList,
    );
  }

  factory Alumnis.fromJson(Map<String, dynamic> json) => Alumnis.fromMap(json);
}