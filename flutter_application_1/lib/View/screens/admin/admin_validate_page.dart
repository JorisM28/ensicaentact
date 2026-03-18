import 'dart:convert';
import 'package:flutter/material.dart';
import '/View/widget/custom_app_bar.dart';
import '/View/screens/alumni/add_alumni.dart';
import '/service_locator.dart';
import '/Model/data/services/alumni_repository.dart';
import '/l10n/app_localizations.dart';

class AdminValidationPage extends StatefulWidget {
  const AdminValidationPage({super.key});

  @override
  State<AdminValidationPage> createState() => _AdminValidationPageState();
}

class _AdminValidationPageState extends State<AdminValidationPage> {
  
  void _refresh() {
    setState(() {});
  }

  // --- NOUVEAU : Fenêtre de validation générique pour les événements, offres, etc. ---
  void _showReviewDialog(BuildContext context, Map<String, dynamic> request, Map<String, dynamic> dataDecoded, String type) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Validation : $type", style: const TextStyle(fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Posté par : ${request['prenom'] ?? ''} ${request['nom'] ?? ''}", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
              Text("Email : ${request['email'] ?? 'Non renseigné'}"),
              const Divider(height: 30),
              // On affiche dynamiquement tout le contenu du JSON
              ...dataDecoded.entries.map((e) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text("${e.key.toUpperCase()} : ${e.value}", style: const TextStyle(fontSize: 14)),
              )),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              // Si on refuse, on supprime juste la demande en attente
              await sl<AlumniRepository>().deletePendingRequest({'id_demande': request['id_demande']});
              _refresh();
              if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Demande refusée/supprimée")));
            },
            child: const Text("Refuser", style: TextStyle(color: Colors.red)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
            onPressed: () async {
              Navigator.pop(ctx);
              
              // ROUTAGE VERS LA BONNE API DE VALIDATION SELON LE TYPE
              if (type == 'EVENEMENT') {
                await sl<AlumniRepository>().validateEvent(int.parse(request['id_demande'].toString()));
              } else if (type == 'OFFRE') {
                // await sl<AlumniRepository>().validateOffer(int.parse(request['id_demande'].toString())); 
              }

              _refresh();
              if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Demande validée avec succès !")));
            },
            child: const Text("Valider et Publier"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final traductions = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: CustomAppBar(),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: sl<AlumniRepository>().getPendingRequests().then((list) => list.cast<Map<String, dynamic>>()),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          if (!snapshot.hasData || snapshot.data!.isEmpty) return Center(child: Text(traductions.adminNoPendingRequests));

          final requests = snapshot.data!;

          return ListView.builder(
            itemCount: requests.length,
            itemBuilder: (context, index) {
              final request = requests[index];
              final date = request['date_demande'] ?? '';
              
              // ON RÉCUPÈRE LE TYPE DE LA BASE DE DONNÉES (Par défaut ALUMNI si vide)
              final type = request['type']?.toString().toUpperCase() ?? 'ALUMNI'; 

              // PERSONNALISATION VISUELLE DU BADGE
              IconData iconType = Icons.person_add;
              Color colorType = Colors.cyan;
              String titlePrefix = "Alumni";

              if (type == 'EVENEMENT') {
                iconType = Icons.event;
                colorType = Colors.orange;
                titlePrefix = "Évènement";
              } else if (type == 'OFFRE' || type == 'EMPLOI') {
                iconType = Icons.work;
                colorType = Colors.blue;
                titlePrefix = "Offre";
              }

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: colorType.withOpacity(0.2),
                    child: Icon(iconType, color: colorType),
                  ),
                  title: Text("[$titlePrefix] ${request['nom'] ?? ''} ${request['prenom'] ?? ''}", style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text("${request['email'] ?? 'Pas d\'email'} - $date"),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    try {
                      final dataDecoded = jsonDecode(request['contenu_json'] ?? '{}');
                      final idReq = int.parse(request['id_demande'].toString());

                      // ROUTAGE DE L'INTERFACE
                      if (type == 'ALUMNI') {
                        // Ancien comportement (Redirection vers le grand formulaire Alumni)
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Scaffold(
                              appBar: AppBar(title: Text(traductions.adminVerifyValidateTitle)),
                              body: AddAlumniForm(
                                isAdmin: true,
                                initialData: dataDecoded,
                                requestId: idReq,
                                onSuccess: () {
                                  Navigator.pop(context);
                                  _refresh();
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(traductions.adminRequestProcessedSuccess)));
                                },
                              ),
                            ),
                          ),
                        );
                      } else {
                        // Nouveau comportement : Pop-up résumé pour les Évènements et Offres
                        _showReviewDialog(context, request, dataDecoded, type);
                      }
                    } catch (e) {
                      print("Erreur de parsing JSON: $e");
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(traductions.adminCorruptedDataError)));
                    }
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}