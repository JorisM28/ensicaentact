import 'package:flutter/material.dart';
import '../../../Model/user_model.dart';
import '/View/screens/alumni/add_alumni.dart';
import '../../theme/colors.dart';

import '/View/widget/custom_app_bar.dart';
class JoinPage extends StatelessWidget {
  final User user;

  const JoinPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(user: user),
      body: AddAlumniForm(
        isAdmin: false, 
        onSuccess: () {

          Navigator.pop(context);
        },
      ),
    );
  }
}