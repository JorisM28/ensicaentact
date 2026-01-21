class Alumni {
  final String nom;
  final String prenom;
  final String? job;
  final String promo;

  Alumni({required this.nom, required this.prenom, this.job, required this.promo});

  factory Alumni.fromJson(Map<String, dynamic> json) {
    return Alumni(
      nom: json['nom'] ?? '',
      prenom: json['prenom'] ?? '',
      job: json['job_actuel'],
      promo: json['annee_promo']?.toString() ?? 'N/A',
    );
  }
}