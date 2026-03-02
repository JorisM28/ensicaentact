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

  bool get isAdmin => role == 'admin';

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      nom: json['nom'],
      prenom: json['prenom'],
      email: json['email'],
      role: json['role'],
    );
  }

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