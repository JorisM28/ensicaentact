import 'package:flutter/material.dart';
import '../../../Model/alumnis.dart';
import '../../../View/screens/alumni/alumni_detail_page.dart';
import 'package:flutter_application_ensicaentact/service_locator.dart';
import 'package:flutter_application_ensicaentact/Model/data/services/auth_service.dart';

class AlumniPreviewViewModel {
  final Alumnis alumni;

  AlumniPreviewViewModel({required this.alumni});
  final currentUser = sl<AuthService>().currentUser;
  bool get isAdmin => currentUser!['role'] == 'admin';

  String get jobAndCompany {
    if (alumni.job.isEmpty && alumni.company.isEmpty) return "";
    String link = (alumni.company.isEmpty || alumni.job.isEmpty) ? "" : " chez ";
    return "${alumni.job}$link${alumni.company}";
  }

  void ouvrirPageComplete(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AlumniDetailPage(alumni: alumni),
      ),
    );
  }
}