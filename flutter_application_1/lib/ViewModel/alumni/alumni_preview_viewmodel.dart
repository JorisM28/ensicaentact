import 'package:flutter/material.dart';
import 'package:flutter_application_ensicaentact/Model/user_model.dart';
import '../../../Model/alumnis.dart';
import '../../../View/screens/alumni/alumni_detail_page.dart';

class AlumniPreviewViewModel {
  final Alumnis alumni;
  final User user;

  AlumniPreviewViewModel({required this.alumni, required this.user});

  bool get isAdmin => user.isAdmin;

  String get jobAndCompany {
    if (alumni.job.isEmpty && alumni.company.isEmpty) return "";
    String link = (alumni.company.isEmpty || alumni.job.isEmpty) ? "" : " chez ";
    return "${alumni.job}$link${alumni.company}";
  }

  void ouvrirPageComplete(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AlumniDetailPage(alumni: alumni, user: user),
      ),
    );
  }
}