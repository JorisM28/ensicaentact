import 'package:flutter/material.dart';
import '/View/screens/admin/admin_validate_page.dart';

import '/Model/data/services/user_model.dart';
class PageModeration extends StatelessWidget {
  final User user;

  const PageModeration({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
     
      body: const AdminValidationPage(),
    );
  }
}