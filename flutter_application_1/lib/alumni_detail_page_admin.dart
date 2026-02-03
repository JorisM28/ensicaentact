import 'package:flutter/material.dart';
import 'package:flutter_application_ensicaentact/profileBadge.dart';
import 'colors.dart';
import 'alumnis.dart';

class AlumniDetailPage extends StatelessWidget {
  final Alumnis alumni;
  final Map<String, dynamic> user;

  const AlumniDetailPage({
    super.key,
    required this.alumni,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    // 1. On prépare la carte "Informations Pro"
    Widget infoProCard = Card(
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
            subtitle: Text(alumni.job),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.school, color: Colors.orange),
            title: const Text("Filière"),
            subtitle: Text(alumni.filiere),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.business, color: Colors.indigo),
            title: const Text("Entreprise"),
            subtitle: Text(alumni.entreprise),
          ),
        ],
      ),
    );

    // 2. On prépare la carte "Coordonnées"
    Widget coordonneesCard = Card(
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
          if (alumni.autor == 1 && alumni.decede == 0) ...[
            ListTile(
              leading: const Icon(Icons.email, color: Colors.green),
              title: const Text("Email"),
              subtitle: Text(alumni.email),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.phone, color: Colors.amber),
              title: const Text("Téléphone"),
              subtitle: Text(alumni.tel),
            ),
          ],
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(alumni.nomComplet),
        backgroundColor: AppColors.ensiCyan,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfileBadge(user: user),
            const SizedBox(height: 20),
            Center(
              child: Column(
                children: [
                  Text(alumni.nomComplet, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                  Text("Promo ${alumni.promo}", style: const TextStyle(fontSize: 20, color: Colors.grey)),
                ],
              ),
            ),
            const Divider(height: 40),

            // 3. AFFICHAGE RESPONSIVE
            LayoutBuilder(builder: (context, constraints) {
              if (constraints.maxWidth > 800) {
                // Mode Large : Côte à côte
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: infoProCard),
                    const SizedBox(width: 10),
                    Expanded(child: coordonneesCard),
                  ],
                );
              } else {
                // Mode Mobile : L'un sous l'autre
                return Column(
                  children: [
                    infoProCard,
                    const SizedBox(height: 10),
                    coordonneesCard,
                  ],
                );
              }
            }),

            const SizedBox(height: 30),
            const Divider(),
            const Text("Stages", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),

            if (alumni.stages.isEmpty)
              const Text("Aucun stage renseigné"),

            ...alumni.stages.map((stage) {
              return Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppColors.ensiCyan,
                    foregroundColor: Colors.white,
                    child: Text(stage.annee),
                  ),
                  title: Text(stage.intitule),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Entreprise : ${stage.entreprise}"),
                      Text("Lieu : ${stage.ville}, ${stage.pays}"),
                    ],
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}