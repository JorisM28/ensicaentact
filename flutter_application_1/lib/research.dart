import 'package:flutter/material.dart';

void main() {
  runApp(const MonReseauAlumni());
}

class MonReseauAlumni extends StatelessWidget {
  const MonReseauAlumni({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Enlève le bandeau "Debug"
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const PageAnnuaire(),
    );
  }
}

class PageAnnuaire extends StatelessWidget {
  const PageAnnuaire({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 1. LA BARRE DU HAUT (AppBar)
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset('assets/logo_alumni.png', scale: 30),
            const SizedBox(width: 10), // Espace
            const Text("ENSICaentact"),
          ],
        ),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      
      // 2. LE CORPS DE LA PAGE (Column)
      body: Column(
        children: [
          // A. SECTION RECHERCHE ET FILTRES (Dans un Container pour la couleur)
          Container(
            padding: const EdgeInsets.all(20),
            color: Colors.grey[100],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Trouver un mentor", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 15),
                
                // La Barre de Recherche
                TextField(
                  decoration: InputDecoration(
                    hintText: "Rechercher un nom, une entreprise...",
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 15),
                
                // Les Filtres (Alignés horizontalement)
                SingleChildScrollView( // Permet de scroller les filtres horizontalement
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _monFiltre("Tous", true),
                      _monFiltre("Informatique", false),
                      _monFiltre("Marketing", false),
                      _monFiltre("Finance", false),
                      _monFiltre("Design", false),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // B. LA LISTE DES ÉLÈVES (Expanded prend toute la place restante)
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _carteEleve("Sophie Martin", "Développeuse @ Google", "Informatique"),
                _carteEleve("Thomas Durand", "Chef de projet @ L'Oréal", "Marketing"),
                _carteEleve("Léa Dubreuil", "Designer @ Freelance", "Design"),
                _carteEleve("Marc Alibert", "Data Scientist @ AXA", "Finance"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // C. MES PETITS COMPOSANTS PERSO (Pour ne pas répéter le code)
  
  // Le design d'un filtre (Chip)
  Widget _monFiltre(String titre, bool estActif) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      child: Chip(
        label: Text(titre),
        backgroundColor: estActif ? Colors.indigo : Colors.white,
        labelStyle: TextStyle(color: estActif ? Colors.white : Colors.black),
      ),
    );
  }

  // Le design d'une carte élève
  Widget _carteEleve(String nom, String poste, String secteur) {
    return Card(
      elevation: 3, // L'ombre sous la carte
      margin: const EdgeInsets.only(bottom: 15),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            // Avatar rond (cercle)
            CircleAvatar(
              backgroundColor: Colors.indigo.shade100,
              radius: 30,
              child: Text(nom[0], style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(width: 15),
            // Infos (Nom + Poste)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(nom, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text(poste, style: TextStyle(color: Colors.grey[600])),
                  const SizedBox(height: 5),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(5)),
                    child: Text(secteur, style: TextStyle(color: Colors.blue[800], fontSize: 10)),
                  )
                ],
              ),
            ),
            // Bouton de contact
            IconButton(
              icon: const Icon(Icons.send, color: Colors.indigo),
              onPressed: () {
                print("Contact $nom");
              },
            )
          ],
        ),
      ),
    );
  }
}