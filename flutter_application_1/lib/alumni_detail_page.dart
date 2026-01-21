import 'package:flutter/material.dart';
import 'colors.dart'; // Vérifie que ce fichier existe aussi, sinon remplace par Colors.cyan
import 'alumnis.dart'; // Important : Importe ton modèle

class AlumniDetailPage extends StatelessWidget {
  final Alumnis alumni;

  const AlumniDetailPage({super.key, required this.alumni});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(alumni.nomComplet),
        backgroundColor: AppColors.ensiCyan, // Ou Colors.cyan si erreur
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView( // Ajouté pour éviter que ça dépasse sur petits écrans
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 60,
              backgroundColor: AppColors.ensiCyan, // Ou Colors.cyan
              child: Text(
                alumni.prenom.isNotEmpty ? alumni.prenom[0] : "?",
                style: const TextStyle(fontSize: 50, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              alumni.nomComplet, 
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)
            ),
            Text(
              "Promo ${alumni.promo}", 
              style: const TextStyle(fontSize: 20, color: Colors.grey)
            ),
            const Divider(height: 40),
            
            // Carte d'infos
            Card(
              elevation: 2,
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.work, color: Colors.blue),
                    title: const Text("Poste actuel"),
                    subtitle: Text("${alumni.job} chez ${alumni.entreprise}"),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.school, color: Colors.orange),
                    title: const Text("Filière"),
                    subtitle: Text(alumni.filiere),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.location_on, color: Colors.red),
                    title: const Text("Ville"),
                    subtitle: Text(alumni.ville),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.email, color: Colors.green),
                    title: const Text("Email"),
                    subtitle: Text("email"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}