class Alumnis {
  final int id;
  final String nom;
  final String prenom;
  final String email;
  final String tel;
  final int autor;
  final int promo;
  final int decede;
  final String filiere;
  final String job;
  final String entreprise;
  final String ville;

  Alumnis({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.tel,
    required this.email,
    required this.autor,
    required this.promo,
    required this.filiere,
    required this.job,
    required this.entreprise,
    required this.ville,
    required this.decede,
  });

  String get nomComplet => "${decede == 1 ? "† " : ""}$prenom $nom";

  factory Alumnis.fromMap(Map<String, dynamic> map) {
    return Alumnis(
      id: int.tryParse(map['id'].toString()) ?? 0,

      nom: map['nom']?.toString() ?? '',
      prenom: map['prenom']?.toString() ?? '',
      
      tel: map['tel']?.toString() ?? '', 
      email: map['email']?.toString() ?? '',

      autor: int.tryParse(map['autor'].toString()) ?? 0,
      promo: int.tryParse(map['promo'].toString()) ?? 0,
      decede: int.tryParse(map['decede'].toString()) ?? 0,

      filiere: map['filiere']?.toString() ?? '',
      job: map['job']?.toString() ?? 'En recherche',
      entreprise: map['entreprise']?.toString() ?? 'Non renseigné',
      ville: map['ville']?.toString() ?? '',
    );
  }
  
  factory Alumnis.fromJson(Map<String, dynamic> json) => Alumnis.fromMap(json);
}