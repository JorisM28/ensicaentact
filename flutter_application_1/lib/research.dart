import 'package:flutter/material.dart';
import 'package:flutter_application_1/colors.dart';
import 'filtre.dart';

void main() {
  runApp(const MonReseauAlumni());
}

class MonReseauAlumni extends StatelessWidget {
  const MonReseauAlumni({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: AppColors.ensiCyan),
      home: const PageAnnuaire(),
    );
  }
}

class PageAnnuaire extends StatelessWidget {
  const PageAnnuaire({super.key});

  @override
  Widget build(BuildContext context) {
    double largeurEcran = MediaQuery.of(context).size.width;
    bool estGrandEcran = largeurEcran > 800;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset('assets/logo_alumni.png', scale: 20),
            const SizedBox(width: 100),
            const Text("ENSIcaentact"),
            const Spacer(),
            const Icon(Icons.account_circle, size: 40),
          ],
        ),
      backgroundColor: AppColors.ensiCyan,
      foregroundColor: Colors.white,
      
      ),

      // 2. LE CORPS DE LA PAGE (Column)
      body: Column(
        children: <Widget> [
          if (estGrandEcran) ...[
            Container(
              padding: const EdgeInsets.all(20),
              color: Colors.grey[100],
              child: Row(
                children: [
                  Container(
                    width: 500,
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Rechercher...",
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                  const Spacer(),
                  const FilterChipExample(),
                ],
              ),
            ),
          ] else ...[
            Container(
              padding: const EdgeInsets.all(20),
              color: Colors.grey[100],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Trouver un mentor",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),

                  // La Barre de Recherche
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Rechercher...",
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 15),
                  const FilterChipExample(),
                ],
              ),
            ),
          ],

          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    color: Colors.white,
                    child: ListView(
                      padding: const EdgeInsets.all(10),
                      children: [
                        _carteEleve(
                          "Sophie MaBite",
                          "Développeuse",
                          "Informatique",
                        ),
                        _carteEleve(
                          "Thomas Durand",
                          "Chef de projet",
                          "Marketing",
                        ),
                        _carteEleve("Léa Dubreuil", "Designer", "Design"),
                        _carteEleve(
                          "Marc Alibert",
                          "Data Scientist",
                          "Finance",
                        ),
                        _carteEleve(
                          "Sophie MaBite",
                          "Développeuse",
                          "Informatique",
                        ),
                        _carteEleve(
                          "Thomas Durand",
                          "Chef de projet",
                          "Marketing",
                        ),
                        _carteEleve("Léa Dubreuil", "Designer", "Design"),
                        _carteEleve(
                          "Marc Alibert",
                          "Data Scientist",
                          "Finance",
                        ),
                        _carteEleve(
                          "Sophie MaBite",
                          "Développeuse",
                          "Informatique",
                        ),
                        _carteEleve(
                          "Thomas Durand",
                          "Chef de projet",
                          "Marketing",
                        ),
                        _carteEleve("Léa Dubreuil", "Designer", "Design"),
                        _carteEleve(
                          "Marc Alibert",
                          "Data Scientist",
                          "Finance",
                        ),
                        _carteEleve(
                          "Sophie MaBite",
                          "Développeuse",
                          "Informatique",
                        ),
                        _carteEleve(
                          "Thomas Durand",
                          "Chef de projet",
                          "Marketing",
                        ),
                        _carteEleve("Léa Dubreuil", "Designer", "Design"),
                        _carteEleve(
                          "Marc Alibert",
                          "Data Scientist",
                          "Finance",
                        ),
                      ],
                    ),
                  ),
                ),

                const VerticalDivider(
                  width: 1,
                  thickness: 1,
                  color: Colors.grey,
                ),
                if (estGrandEcran) ...[
                  Expanded(
                    flex: 1,
                    child: Container(
                      color: Colors.grey[50],
                      padding: const EdgeInsets.all(40),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const CircleAvatar(
                            radius: 60,
                            backgroundColor: AppColors.ensiCyan,
                            child: Icon(
                              Icons.person,
                              size: 60,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            "Sélectionnez un élève",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Cliquez sur un profil à gauche pour voir les détails.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 30),
                          ElevatedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.mail),
                            label: const Text("Envoyer un message"),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(15),
            color: AppColors.ensiCyan,
            child: const Column(
              children: [
                Text(
                  "© 2026 ENSICAEN Alumni - Tous droits réservés", 
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(
                  "Contact : contact@ensicaen.fr",
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
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
            child: Text(
              nom[0],
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 15),
          // Infos (Nom + Poste)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nom,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(poste, style: TextStyle(color: Colors.grey[600])),
                const SizedBox(height: 5),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    secteur,
                    style: TextStyle(color: Colors.blue[800], fontSize: 10),
                  ),
                ),
              ],
            ),
          ),
          // Bouton de contact
          IconButton(
            icon: const Icon(Icons.send, color: Colors.indigo),
            onPressed: () {
              print("Contact $nom");
            },
          ),
        ],
      ),
    ),
  );
}
