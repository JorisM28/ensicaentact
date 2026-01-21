import 'package:flutter/material.dart';
import 'colors.dart';
import 'alumnis.dart';
import 'alumni_detail_page.dart'; // Importe la page complète pour la navigation

class AlumniPreview extends StatelessWidget {
  final Alumnis alumni;

  const AlumniPreview({super.key, required this.alumni});

  // Fonction pour aller vers la page complète
  void _ouvrirPageComplete(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AlumniDetailPage(alumni: alumni),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () => _ouvrirPageComplete(context),
      child: Container(
        padding: const EdgeInsets.all(30),
        color: Colors.white,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Hero(
              tag: alumni.email,
              child: CircleAvatar(
                radius: 70,
                backgroundColor: AppColors.ensiCyan,
                child: Text(
                  alumni.prenom.isNotEmpty ? alumni.prenom[0] : "?",
                  style: const TextStyle(fontSize: 60, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 30),

            Text(
              alumni.nomComplet,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              "${alumni.job} chez ${alumni.entreprise}",
              style: TextStyle(fontSize: 18, color: Colors.grey[700]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _infoBulle(Icons.school, alumni.promo.toString(), Colors.orangeAccent),
                _infoBulle(Icons.location_on, alumni.ville, Colors.red),
              ],
            ),

            const Spacer(),

            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.ensiCyan,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                textStyle: const TextStyle(fontSize: 18),
              ),
              onPressed: () => _ouvrirPageComplete(context),
              icon: const Icon(Icons.visibility),
              label: const Text("Voir la fiche complète"),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _infoBulle(IconData icon, String text, Color color) {
    return Column(
      children: [
        Icon(icon, size: 30, color: color),
        const SizedBox(height: 5),
        Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}