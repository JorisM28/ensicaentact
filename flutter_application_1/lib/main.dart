import 'package:flutter/material.dart';
import 'package:flutter_application_ensicaentact/Model/data/services/auth_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';
import 'View/screens/home_page.dart';
import '/service_locator.dart';
import '/View/navigation.dart';
import 'ViewModel/alumni/directory_view_model.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('en'); 

  Locale get locale => _locale;

  void setLocale(Locale locale) {
    if (!AppLocalizations.supportedLocales.contains(locale)) return;
    _locale = locale;
    notifyListeners();
  }
}

void main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  await sl<AuthService>().loadSession();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => sl<DirectoryViewModel>()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()), 
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
    
    final localeProvider = Provider.of<LocaleProvider>(context);

    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Alumni EnsiCaen',

      locale: localeProvider.locale, 

      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('fr'),
        Locale('en'),
      ],
      navigatorObservers: [routeObserver],

      home: const HomePage(),
    );
  }
}