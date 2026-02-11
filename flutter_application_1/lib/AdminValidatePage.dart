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

        final demandes = snapshot.data!;

        return ListView.builder(
          itemCount: demandes.length,
          itemBuilder: (context, index) {
            final d = demandes[index];
            final date = d['date_demande'] ?? '?';

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: ListTile(
                leading: const CircleAvatar(backgroundColor: Colors.orange, child: Icon(Icons.person_add, color: Colors.white)),
                title: Text("${d['prenom']} ${d['nom']}"),
                subtitle: Text("Reçu le : $date"),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  try {
                    Map<String, dynamic> dataDecoded = jsonDecode(d['contenu_json']);
                    int idReq = int.parse(d['id_demande'].toString());

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
            Map<String, dynamic> eventData = {};
            try {
              eventData = jsonDecode(req['contenu_json']);
            } catch (e) {
              eventData = {"titre": "Erreur données"};
            }

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: ListTile(
                leading: const CircleAvatar(backgroundColor: Colors.purple, child: Icon(Icons.event, color: Colors.white)),
                title: Text(eventData['titre'] ?? "Sans titre"),
                subtitle: Text("Proposé par : ${req['prenom_auteur'] ?? req['prenom']} ${req['nom_auteur'] ?? req['nom']}"),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.red),
                      onPressed: () async {
                        await _db.supprimerDemande(int.parse(req['id_demande'].toString()));
                        _refresh();
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.check, color: Colors.green),
                      onPressed: () async {
                        await _db.validerEvenement(int.parse(req['id_demande'].toString()));
                        _refresh();
                        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Évènement publié !")));
                      },
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
}