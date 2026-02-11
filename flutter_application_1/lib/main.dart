import 'package:flutter/material.dart';
import 'package:flutter_application_ensicaentact/navigation.dart';
import 'login.dart';
import 'login_check.dart';
import 'page_annuaire.dart';
import 'formulaire_ajout_alumni.dart';
import 'page_emploi.dart';
import 'entreprise_annuaire_page.dart';
import 'page_accueil.dart'; 
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final RouteObserver<ModalRoute<void>> routeObserver = RouteObserver<ModalRoute<void>>();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    

    final Map<String, dynamic> userTest = {
      'id': '24',
      'prenom': 'Benoît',
      'nom': 'Michel',
      'role': 'admin', 
      'email': 'benoit.michel@ensicaen.fr'
    };

    return MaterialApp(
  
      navigatorKey: navigatorKey, 
      navigatorObservers: [routeObserver],
      
      debugShowCheckedModeBanner: false,
      title: 'Réseau Alumni',
      

      home: PageAccueil(user: userTest), 
    );
  }
}