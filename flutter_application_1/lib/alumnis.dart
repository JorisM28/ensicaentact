class Alumnis {
  final String nom;
  final String prenom;
  final int age;
  final String job;
  final String entreprise;
  final String ville;
  final int? promo;
  final String filiere;

  Alumnis({
    required this.nom,
    required this.prenom,
    required this.age,
    required this.job,
    required this.entreprise,
    required this.ville,
    this.promo,
    required this.filiere,
  });

  factory Alumnis.fromMap(Map<String, dynamic> data) {
    return Alumnis(
      nom: data['nom'] ?? '',
      prenom: data['prenom'] ?? '',
      
      age: int.tryParse(data['age'].toString()) ?? 0,
      
      job: data['job_actuel'] ?? 'En recherche / Études', 
      entreprise: data['entreprise_job'] ?? 'Non renseigné',
      ville: data['ville_job'] ?? 'Localisation inconnue',
      
      promo: int.tryParse(data['annee_promo'].toString()),
      
      filiere: data['filière'] ?? 'Généraliste',
    );
  }
  
  String get nomComplet => "$prenom $nom";
}