abstract class User {
  String get nom;
  String get prenom;
  bool get isAdmin;
  bool get canEdit;

  factory User.fromJson(Map<String, dynamic> json) {
    String role = json['role'] ?? 'guest';
    
    switch (role) {
      case 'admin':
        return AdminUser(json);
      case 'student':
      case 'alumni':
        return AlumniUser(json);
      default:
        return GuestUser();
    }
  }
}

class AdminUser implements User {
  final Map<String, dynamic> data;
  AdminUser(this.data);

  @override String get nom => data['nom'];
  @override String get prenom => data['prenom'];
  @override bool get isAdmin => true;
  @override bool get canEdit => true;
}

class AlumniUser implements User {
  final Map<String, dynamic> data;
  AlumniUser(this.data);
  
  @override String get nom => data['nom'];
  @override String get prenom => data['prenom'];
  @override bool get isAdmin => false;
  @override bool get canEdit => false;
}

class GuestUser implements User {
  @override String get nom => "Visiteur";
  @override String get prenom => "";
  @override bool get isAdmin => false;
  @override bool get canEdit => false;
}