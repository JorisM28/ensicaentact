import 'package:flutter/material.dart';
import '/Model/core/theme/colors.dart';
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
      appBar: CustomAppBar(),
      body: Column(
        children: [
          const SizedBox(height: 20),

          const Text(
            "Formulaire d'ajout d'alumni",
            style: TextStyle(
              fontSize: 22, 
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 20),

          Expanded(
            child: AddAlumniForm(),
          ),
        ]

      )
    );
  }
}