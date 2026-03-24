import 'package:flutter/material.dart';
import '/View/widget/base_layout.dart';
import 'add_alumni.dart';
import '/l10n/app_localizations.dart';

void main() {
  runApp(const MyAlumniApp());
}

class MyAlumniApp extends StatelessWidget {
  const MyAlumniApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (context) => AppLocalizations.of(context)!.directoryNewAlumniTitle,      
      debugShowCheckedModeBanner: false,

      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
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
    final traductions = AppLocalizations.of(context)!;
    return BaseLayout(
      body: Column(
        children: [
          const SizedBox(height: 20),

          Text(
            traductions.directoryNewAlumniTitle,
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