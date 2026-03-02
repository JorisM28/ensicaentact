class User {
  final int id;
  final String nom;
  final String prenom;
  final String email;
  final String role;

  User({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.email,
    required this.role,
  });

  // Getter pratique pour vérifier si l'utilisateur est admin
  bool get isAdmin => role == 'admin';

  // Pour créer un User depuis l'API ou le stockage local
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      nom: json['nom'],
      prenom: json['prenom'],
      email: json['email'],
      role: json['role'],
    );
  }

  // Pour sauvegarder l'User dans le stockage (convertir en Map)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'prenom': prenom,
      'email': email,
      'role': role,
    };
  }
}