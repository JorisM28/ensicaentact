import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tableau de Bord')),
      body: Center(
        child: Text('Bienvenue ! Vous êtes connecté.'),
      ),
    );
  }
}