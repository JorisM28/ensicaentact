import 'package:flutter/material.dart';
import 'colors.dart';
import 'add_alumni.dart';

void main() {
  runApp(const MonApplicationAlumni());
}

class MonApplicationAlumni extends StatelessWidget {
  const MonApplicationAlumni({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ajout Alumni',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.cyan,
        useMaterial3: true,
      ),
      home: const PageAjoutAlumni(),
    );
  }
}

class PageAjoutAlumni extends StatelessWidget {
  const PageAjoutAlumni({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ajouter un Alumni"),
        backgroundColor: AppColors.ensiCyan,
        foregroundColor: Colors.white,
      ),
      body: AddAlumniForm(),
    );
  }
}