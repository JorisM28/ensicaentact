import 'package:flutter/material.dart';
import 'package:flutter_application_ensicaentact/Model/user_model.dart';
import '../../../View/theme/colors.dart';
import '/View/widget/custom_app_bar.dart';
import 'add_alumni.dart';

void main() {
  runApp(const MyAlumniApp());
}

class MyAlumniApp extends StatelessWidget {
  const MyAlumniApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ajout Alumni',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.cyan,
        useMaterial3: true,
      ),
      home: const AddAlumniPage(),
    );
  }
}

class AddAlumniPage extends StatelessWidget {
  const AddAlumniPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(user: GuestUser(),),
      body: AddAlumniForm(),
    );
  }
}