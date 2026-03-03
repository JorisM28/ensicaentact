class User {
  final int id;
  final String firstname;
  final String lastname;
  final String email;
  final String role;
  final String phone;

  User({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.role,
    required this.phone,
  });

  bool get isAdmin => role == 'admin';

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      lastname: json['nom'],
      firstname: json['prenom'],
      email: json['email'],
      role: json['role'],
      phone: json['']
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