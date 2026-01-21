import 'package:flutter/material.dart';
import 'package:flutter_application_ensicaentact/colors.dart';
import 'filtre.dart';
import 'alumnis.dart';
import 'database_service.dart';
import 'api_service.dart';

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
            const SizedBox(width: 20),
            const Text("ENSIcaentact"),
            const Spacer(),
            const Icon(Icons.account_circle, size: 40),
          ],
        ),
        backgroundColor: AppColors.ensiCyan,
        foregroundColor: Colors.white,
      ),

      body: Column(
        children: <Widget>[
          
          Container(
            padding: const EdgeInsets.all(20),
            color: Colors.grey[100],
            child: estGrandEcran
                ? Row(
                    children: [
                      SizedBox(width: 400, child: _champRecherche()),
                      const Spacer(),
                      const FilterChipExample(), 
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Trouver un mentor", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 15),
                      _champRecherche(),
                      const SizedBox(height: 15),
                      const FilterChipExample(),
                    ],
                  ),
          ),

          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: estGrandEcran ? 2 : 1,
                  child: Container(
                    color: Colors.white,
                    child: FutureBuilder<List<Alumnis>>(
                      future: DatabaseService().getTousLesEleves(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError) {
                          return Center(child: Text("Erreur : ${snapshot.error}", style: const TextStyle(color: Colors.red)));
                        }
                        if (snapshot.hasData) {
                          final lesEleves = snapshot.data!;
                          if (lesEleves.isEmpty) return const Center(child: Text("Aucun résultat."));

                          return ListView.builder(
                            itemCount: lesEleves.length,
                            padding: const EdgeInsets.all(10),
                            itemBuilder: (context, index) {
                              return _carteEleve(lesEleves[index]);
                            },
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
                ),

                if (estGrandEcran) ...[
                  const VerticalDivider(width: 1, thickness: 1, color: Colors.grey),
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
                            child: Icon(Icons.person, size: 60, color: Colors.white),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            "Sélectionnez un élève",
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Cliquez sur un profil à gauche pour voir les détails.",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
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
                Text("© 2026 ENSICAEN Alumni", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget _champRecherche() {
    return TextField(
      decoration: InputDecoration(
        hintText: "Rechercher...",
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }

  Widget _carteEleve(Alumnis eleve) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 15),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: AppColors.ensiCyan,
              radius: 30,
              child: Text(
                eleve.prenom.isNotEmpty ? eleve.prenom[0] : "?",
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    eleve.nomComplet,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  if (eleve.promo != null)
                    Text("'${eleve.promo.toString().substring(2)}", style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.bold)),
                  Text("${eleve.job} @ ${eleve.entreprise}", style: TextStyle(color: Colors.grey[800])),
                  const SizedBox(height: 5),
                  Wrap(
                    spacing: 5,
                    children: [
                      Chip(label: Text(eleve.filiere, style: const TextStyle(fontSize: 10)), backgroundColor: Colors.blue[50]),
                      Chip(avatar: const Icon(Icons.location_on, size: 14), label: Text(eleve.ville, style: const TextStyle(fontSize: 10)), backgroundColor: Colors.orange[50]),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send, color: AppColors.ensiCyan),
              onPressed: () { print("Contact ${eleve.nomComplet}"); },
            ),
          ],
        ),
      ),
    );
  }
}