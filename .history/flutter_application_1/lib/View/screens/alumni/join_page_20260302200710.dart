import 'package:flutter/material.dart';
import '../../../Model/user_model.dart';
import '/View/screens/alumni/add_alumni.dart';
import '/View/widget/custom_app_bar.dart';
class JoinPage extends StatelessWidget {
  const JoinPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(),
      body: AddAlumniForm(
        isAdmin: false, 
        onSuccess: () {

          Navigator.pop(context);
        },
      ),
    );
  }
}