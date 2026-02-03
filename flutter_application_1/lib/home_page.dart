import 'package:flutter/material.dart';
import 'header_homepage.dart';
import 'actuality_widget.dart';
import 'event_widget.dart';
import 'joboffert_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // 1. AJOUT DU WIDGET DE SCROLL
      body: SingleChildScrollView(
        // 2. La Column est maintenant l'enfant du ScrollView
        child: Column(
          children: [
            const HeaderHomePage(),

            const ActualityWidget(),

            const Divider(height: 1, thickness: 1, color: Colors.grey),

            const EventWidget(),

            const JobOfferWidget(),

            Container(
                height: 100,
                color: const Color(0xFF333333),
                child: const Center(child: Text("Footer", style: TextStyle(color: Colors.white)))
            ),
          ],
        ),
      ),
    );
  }
}