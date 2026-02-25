import 'package:flutter/material.dart';
import '/View/widget/custom_app_bar.dart';
import '/View/screens/admin/admin_validate_page.dart';
import '/Model/core/theme/colors.dart';

class PageModeration extends StatelessWidget {
  final Map<String, dynamic> user;

  const PageModeration({super.key, required this.user});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: CustomAppBar(),
     
      body: const AdminValidationPage(),
    );
  }
}