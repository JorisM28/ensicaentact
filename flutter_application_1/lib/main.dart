import 'package:flutter/material.dart';
import 'package:flutter_application_ensicaentact/navigation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';  
import 'login.dart';
import 'login_check.dart';
import 'page_annuaire.dart';
import 'formulaire_ajout_alumni.dart';
import 'page_emploi.dart';
import 'entreprise_annuaire_page.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('fr', 'FR'),
        Locale('en', 'US'),
      ],
      title: 'Réseau Alumni',
      navigatorObservers: [routeObserver],
      home: const PageAccueil(),
    );
  }
}

class PageAccueil extends StatelessWidget {
  const PageAccueil({super.key});

  @override
  Widget build(BuildContext context) {
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
                  MaterialPageRoute(builder: (context) => const PageAnnuaire(user: {
                      'prenom': 'Admin',
                      'nom': '',
                      'email': '',
                      'role': 'admin'
                    },
                  )),
                );
              },
              child: const Text('Version Admin'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PageAjoutAlumni()),
                );
              },
              child: const Text('Formulaire'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PageAnnuaireEntreprise()),
                );
              },
              child: const Text('Page Annuaire Entreprise'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PageEmploi(
                    
                      user: {
                        'id': '24',
                        'prenom': 'Benoît',
                        'nom': 'Michel',
                        'role': 'student'
                      },
                    ), 
                  ),
                );
              },
              child: const Text('Recherche/Dépôt Offres de Stage/Emploi'),
            )
          ],
        ),
      ),
    );
  }
}