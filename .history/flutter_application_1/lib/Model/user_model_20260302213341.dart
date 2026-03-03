abstract class User {
  final String id;
  final String lastname;
  final String firstname;
  final String email;
  final String phone;
  final String role;

  bool get isAdmin;
  bool get canEdit;

  User({
    required this.id,
    required this.lastname,
    required this.firstname,
    required this.email,
    required this.phone,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    final role = json['role']?.toString() ?? 'guest';

    final id = (json['id_user'] ?? json['id'] ?? '0').toString();
    final lastname = json['family_name'] ?? json['nom'] ?? 'Inconnu';
    final firstname = json['name'] ?? json['prenom'] ?? 'Inconnu';
    final email = json['email'] ?? 'Inconnu';
    final phone = json['phone']?.toString() ?? '';

    switch (role) {
      case 'admin':
        return AdminUser(id: id, lastname: lastname, firstname: firstname, email: email, phone: phone);
      case 'student':
        return StudentUser(id: id, lastname: lastname, firstname: firstname, email: email, phone: phone);
      case 'alumni':
        return AlumniUser(id: id, lastname: lastname, firstname: firstname, email: email, phone: phone);
      default:
        return GuestUser();
    }
  }
}

class AdminUser extends User {
  AdminUser({required super.id, required super.lastname, required super.firstname, required super.email, required super.phone})
      : super(role: 'admin');

  @override bool get isAdmin => true;
  @override bool get canEdit => true;
}

class AlumniUser extends User {
  AlumniUser({required super.id, required super.lastname, required super.firstname, required super.email, required super.phone})
      : super(role: 'alumni');

  @override bool get isAdmin => false;
  @override bool get canEdit => true;
}

class StudentUser extends User {
  StudentUser({required super.id, required super.lastname, required super.firstname, required super.email, required super.phone})
      : super(role: 'student');

  @override bool get isAdmin => false;
  @override bool get canEdit => false;
}

class GuestUser extends User {
  GuestUser() : super(
          id: '0',
          lastname: 'Visitor',
          firstname: '',
          email: '',
          phone: '',
          role: 'guest',
        );

  @override bool get isAdmin => false;
  @override bool get canEdit => false;
}