import 'package:flutter/material.dart';
import 'colors.dart';
import 'alumnis.dart';

class AlumniDetailPage extends StatelessWidget {
  final Alumnis alumni;

  const AlumniDetailPage({super.key, required this.alumni});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(alumni.nomComplet),
        backgroundColor: AppColors.ensiCyan,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 60,
              backgroundColor: AppColors.ensiCyan,
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
            
            // --- C'EST ICI QUE CA CHANGE ---
            Row(
              crossAxisAlignment: CrossAxisAlignment.start, // Aligne les cartes en haut
              children: [
                
                // COLONNE DE GAUCHE (Expanded force la largeur à 50%)
                Expanded(
                  child: Card(
                    elevation: 2,
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("Informations Pro", style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
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
                      ],
                    ),
                  ),
                ),

                const SizedBox(width: 10), // Espace entre les deux colonnes

                // COLONNE DE DROITE
                Expanded(
                  child: Card(
                    elevation: 2,
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("Coordonnées", style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
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
                ),
                
              ],
            )      
          ],
        ),
      ),
    );
  }
}