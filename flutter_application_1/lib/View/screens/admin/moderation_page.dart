import 'package:flutter/material.dart';
import '../../../Model/user_model.dart';
import '/View/screens/admin/admin_validate_page.dart';
import '../../theme/colors.dart';

class PageModeration extends StatelessWidget {
  final User user;

  const PageModeration({super.key, required this.user});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Interface de Modération"),
        backgroundColor: AppColors.ensiCyan,
        foregroundColor: Colors.white,
      ),
     
      body: const AdminValidationPage(),
    );
  }
}