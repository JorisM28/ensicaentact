abstract class User {
  String get id;
  String get nom;
  String get prenom;
  String get email;
  String get phone;
  String get role;
  bool get isAdmin;
  bool get canEdit;

  factory User.fromJson(Map<String, dynamic> json) {
    String role = json['role'] ?? 'guest';
    String phone = json['phone']?.toString() ?? '';

    switch (role) {
      case 'admin':
        return AdminUser(
          id: (json['id_user'] ?? json['id'] ?? '0').toString(),
          nom: json['family_name'] ?? json['nom'] ?? 'Inconnu',
          prenom: json['name'] ?? json['prenom'] ?? 'Inconnu',
          email: json['email'] ?? 'Inconnu',
          phone: phone,
        );
      case 'student':
        return StudentUser(
            id: (json['id_user'] ?? json['id'] ?? '0').toString(),
            nom: json['family_name'] ?? json['nom'] ?? 'Inconnu',
            prenom: json['name'] ?? json['prenom'] ?? 'Inconnu',
            email: json['email'] ?? 'Inconnu',
            role: role,
            phone: phone,
        );
      case 'alumni':
        return AlumniUser(
          id: (json['id_user'] ?? json['id'] ?? '0').toString(),
          nom: json['family_name'] ?? json['nom'] ?? 'Inconnu',
          prenom: json['name'] ?? json['prenom'] ?? 'Inconnu',
          email: json['email'] ?? 'Inconnu',
          role: role,
          phone: phone,
        );
      default:
        return GuestUser();
    }
  }
}

class AdminUser implements User {
  @override final String id;
  @override final String nom;
  @override final String prenom;
  @override final String email;
  @override final String phone;
  @override final String role = 'admin';
  @override final bool isAdmin = true;
  @override final bool canEdit = true;

  AdminUser({required this.id, required this.nom, required this.prenom, required this.email, required this.phone});
}

class AlumniUser implements User {
  @override final String id;
  @override final String nom;
  @override final String prenom;
  @override final String email;
  @override final String phone;
  @override final String role;
  @override final bool isAdmin = false;
  @override final bool canEdit = true;

  AlumniUser({required this.id, required this.nom, required this.prenom, required this.email, required this.phone, required this.role});
}

class StudentUser implements User {
  @override final String id;
  @override final String nom;
  @override final String prenom;
  @override final String email;
  @override final String phone;
  @override final String role;
  @override final bool isAdmin = false;
  @override final bool canEdit = false;

  StudentUser({required this.id, required this.nom, required this.prenom, required this.email, required this.role, required this.phone});
}

class GuestUser implements User {
  @override final String id = "0";
  @override final String nom = "Visitor";
  @override final String prenom = "";
  @override final String email = "";
  @override final String phone = "";
  @override final String role = "guest";
  @override final bool isAdmin = false;
  @override final bool canEdit = false;
}