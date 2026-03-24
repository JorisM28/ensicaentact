import 'package:flutter/material.dart';
import '/View/widget/base_layout.dart';
import '/View/screens/alumni/add_alumni.dart';
class JoinPage extends StatelessWidget {
  const JoinPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseLayout(
      body: AddAlumniForm(
        isAdmin: false, 
        onSuccess: () {

          Navigator.pop(context);
        },
      ),
    );
  }
}