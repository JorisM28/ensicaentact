import 'package:flutter/material.dart';
import 'AdminValidatePage.dart'; 
import 'colors.dart';

class PageModeration extends StatelessWidget {
  final Map<String, dynamic> user;

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