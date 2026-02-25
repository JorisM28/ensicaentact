import 'dart:convert';
import 'package:flutter/material.dart';
import 'database_service.dart';
import 'add_alumni.dart';
import 'colors.dart';

class AdminValidationPage extends StatefulWidget {
  const AdminValidationPage({super.key});

  @override
  State<AdminValidationPage> createState() => _AdminValidationPageState();
}

class _AdminValidationPageState extends State<AdminValidationPage> {
  final DatabaseService _db = DatabaseService();

  void _refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    return DefaultTabController(
      length: 2, 
      child: Column(
        children: [
          Container(
            color: Colors.grey[100],
            child: const TabBar(
              labelColor: AppColors.ensiCyan,
              unselectedLabelColor: Colors.grey,
              indicatorColor: AppColors.ensiCyan,
              tabs: [
                Tab(icon: Icon(Icons.person_add), text: "Alumni"),
                Tab(icon: Icon(Icons.event_available), text: "Évènements"),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildListeAlumni(),
                _buildListeEvents(),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildListeAlumni() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _db.getDemandesEnAttente(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
        if (!snapshot.hasData || snapshot.data!.isEmpty) return const Center(child: Text("Aucune demande d'inscription."));

        final requests = snapshot.data!;

        return ListView.builder(
          itemCount: requests.length,
          itemBuilder: (context, index) {
            final r = requests[index];
            final date = r['date_demande'] ?? '?';

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: ListTile(
                leading: const CircleAvatar(backgroundColor: Colors.orange, child: Icon(Icons.person_add, color: Colors.white)),
                title: Text("${r['prenom']} ${r['nom']}"),
                subtitle: Text("Reçu le : $date"),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  try {
                    Map<String, dynamic> dataDecoded = jsonDecode(r['contenu_json']);
                    int idReq = int.parse(r['id_demande'].toString());

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Scaffold(
                          appBar: AppBar(title: const Text("Validation Alumni")),
                          body: AddAlumniForm(
                            isAdmin: true,
                            initialData: dataDecoded,
                            requestId: idReq,
                            onSuccess: () {
                              Navigator.pop(context);
                              _refresh();
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Alumni validé !")));
                            },
                          ),
                        ),
                      ),
                    );
                  } catch (e) {
                    print("Erreur JSON: $e");
                  }
                },
              ),
            );
          },
        );
      },
    );
  }

 
  Widget _buildListeEvents() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _db.getDemandesEvenements(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
        if (!snapshot.hasData || snapshot.data!.isEmpty) return const Center(child: Text("Aucune proposition d'évènement."));

        final events = snapshot.data!;

        return ListView.builder(
          itemCount: events.length,
          itemBuilder: (context, index) {
            final req = events[index];

            
            final String titre = req['titre'] ?? "Sans titre";
            final String date = req['date_event'] ?? "Date inconnue";
            final String lieu = req['lieu'] ?? "Lieu non précisé";
            final String auteur = "${req['prenom_auteur'] ?? ''} ${req['nom_auteur'] ?? ''}".trim();
            final String desc = req['description'] ?? "Pas de description";

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              elevation: 2,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.ensiCyan, 
                  child: const Icon(Icons.event, color: Colors.white)
                ),
                title: Text(titre, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("📅 $date  📍 $lieu"),
                    Text("Proposé par : $auteur", style: const TextStyle(fontStyle: FontStyle.italic)),
                  ],
                ),
                isThreeLine: true, 
                
                
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: Text(titre),
                      content: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("Date : $date", style: const TextStyle(fontWeight: FontWeight.bold)),
                            Text("Lieu : $lieu"),
                            const Divider(),
                            const Text("Description :", style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(desc),
                            const SizedBox(height: 10),
                            Text("Auteur : $auteur", style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                          ],
                        ),
                      ),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Fermer")),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                          onPressed: () async {
                            Navigator.pop(ctx);
                            await _validate(req);
                          }, 
                          child: const Text("Valider")
                        )
                      ],
                    ),
                  );
                },

                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.red),
                      tooltip: "Refuser",
                      onPressed: () => _reject(req),
                    ),
                    IconButton(
                      icon: const Icon(Icons.check, color: Colors.green),
                      tooltip: "Valider",
                      onPressed: () => _validate(req),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  
  Future<void> _validate(Map<String, dynamic> req) async {
     await _db.validerEvenement(int.parse(req['id_demande'].toString()));
     _refresh();
     if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Évènement publié !")));
  }

  Future<void> _reject(Map<String, dynamic> req) async {
    
     await _db.supprimerDemande(int.parse(req['id_demande'].toString()));
     _refresh();
     if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Proposition refusée.")));
  }
}