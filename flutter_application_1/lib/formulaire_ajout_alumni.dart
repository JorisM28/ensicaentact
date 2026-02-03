import 'package:flutter/material.dart';
import 'colors.dart'; // Assure-toi d'importer tes couleurs si besoin
import 'add_alumni.dart'; // Assure-toi que le fichier de ton formulaire est bien importé

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
        primarySwatch: Colors.cyan, // Ou ta couleur personnalisée
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