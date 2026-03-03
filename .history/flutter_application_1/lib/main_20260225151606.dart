import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'View/screens/home_page.dart';
import '/service_locator.dart';
import '/View/navigation.dart';
import 'ViewModel/alumni/directory_view_model.dart';
import 'Model/data/services/auth_service.dart';


void main() async {
  await dotenv.load(fileName: ".env");
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
      home: HomePage(),
    );
  }
}