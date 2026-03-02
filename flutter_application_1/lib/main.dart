import 'package:flutter/material.dart';
import 'package:flutter_application_ensicaentact/service_locator.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'Model/data/services/auth_service.dart';
import 'Model/user_model.dart';
import 'View/navigation.dart';
import 'View/screens/home_page.dart';
import 'ViewModel/alumni/directory_view_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
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
    final authService = sl<AuthService>();
    final bool isConnected = authService.isLoggedIn;
    final User homeUser = isConnected && authService.currentUser != null
        ? authService.currentUser!
        : GuestUser();

    return MaterialApp(
      navigatorKey: navigatorKey,
      navigatorObservers: [routeObserver],
      debugShowCheckedModeBanner: false,
      title: 'Alumni EnsiCaen',
      home: HomePage(user: homeUser),
    );
  }
}