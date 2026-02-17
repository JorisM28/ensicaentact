import 'package:flutter/material.dart';
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
    return MaterialApp(
      navigatorKey: navigatorKey,
      navigatorObservers: [routeObserver],
      
      debugShowCheckedModeBanner: false,
      title: 'Alumni EnsiCaen',
      home: PageAccueil(),
    );
  }
}