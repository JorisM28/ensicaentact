import 'package:flutter/material.dart';
import 'login.dart';
import 'login_check.dart';
import 'page_annuaire.dart';
import 'page_annuaire_admin.dart';

void main() {
  runApp(const MyApp());
}

// 1. LA CONFIGURATION (Le parent)
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Réseau Alumni',
      home: const PageAccueil(), 
    );
  }
}

// 2. L'ÉCRAN D'ACCUEIL (L'enfant qui a le bon context)
class PageAccueil extends StatelessWidget {
  const PageAccueil({super.key});

  @override
  Widget build(BuildContext context) {
    // Ici, ce "context" est SOUS MaterialApp, donc il trouve le Navigator !
    return Scaffold(
      appBar: AppBar(title: const Text('Réseau Alumni')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Bienvenue dans le réseau !', style: TextStyle(fontSize: 20)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PageAnnuaire(user: {
                      'prenom': 'Visiteur',
                      'nom': '',
                      'email': '',
                      'role': 'guest'
                    },
                  )),
                );
              },
              child: const Text('Contacter un ancien élève'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Login()),
                );
              },
              child: const Text('Login'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PageAnnuaireAdmin()),
                );
              },
              child: const Text('Version Admin'),
            ),
          ],
        ),
      ),
    );
  }
}