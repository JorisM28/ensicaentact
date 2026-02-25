import 'package:flutter/material.dart';
import 'package:flutter_application_ensicaentact/Model/data/services/auth_service.dart';
import 'package:flutter_application_ensicaentact/View/navigation.dart';
import 'package:flutter_localizations/flutter_localizations.dart';  
import 'View/screens/auth/login.dart';
import 'View/screens/employment/companies_directory_page.dart';
import 'View/screens/alumni/directory_page.dart';
import 'View/screens/alumni/add_alumni_form.dart';
import 'View/screens/employment/employement_page.dart';
import 'service_locator.dart';
import 'ViewModel/alumni/directory_view_model.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  await sl<AuthService>().loadSession();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => sl<DirectoryViewModel>()),
        ],
      child: const MyApp(), 
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isConnected = sl<AuthService>().isLoggedIn;
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
      home: isConnected ?  const PageAccueil() : const Login(),
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
                  MaterialPageRoute(builder: (context) => const DirectoryPage(user: {
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
                AuthService().logout();
              },
              child: const Text('virer moi ce token'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DirectoryPage(user: {
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
                  MaterialPageRoute(builder: (context) => const AddAlumniPage()),
                );
              },
              child: const Text('Formulaire'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CompaniesDirectoryPage(user: {},)),
                );
              },
              child: const Text('Page Annuaire Entreprise'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EmploymentPage(
                    
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