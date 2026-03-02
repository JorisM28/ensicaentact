import 'dart:convert';
import 'package:flutter/material.dart';
import '../../../View/theme/colors.dart';
import '../alumni/add_alumni.dart';
import 'package:flutter_application_ensicaentact/service_locator.dart';
import 'package:flutter_application_ensicaentact/Model/data/services/alumni_repository.dart';

class AdminValidationPage extends StatefulWidget {
  const AdminValidationPage({super.key});

  @override
  State<AdminValidationPage> createState() => _AdminValidationPageState();
}

class _AdminValidationPageState extends State<AdminValidationPage> {
  
  void _refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Demandes en attente"),
        backgroundColor: AppColors.ensiCyan,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: sl<AlumniRepository>().getPendingRequests().then((list) => list.cast<Map<String, dynamic>>()),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Aucune demande en attente."));
          }

          final requests = snapshot.data!;

          return ListView.builder(
            itemCount: requests.length,
            itemBuilder: (context, index) {
              final request = requests[index];
              final date = request['date_demande'] ?? '?';
              
              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  leading: const Icon(Icons.person_add, color: Colors.orange),
                  title: Text("${request['prenom']} ${request['nom']}"),
                  subtitle: Text("Reçu le : $date"),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    try {
                      Map<String, dynamic> dataDecoded = jsonDecode(request['contenu_json']);
                      int idReq = int.parse(request['id_demande'].toString());
                      print("ID de la demande envoyé au formulaire : $idReq");

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Scaffold(
                            appBar: AppBar(title: const Text("Vérification & Validation")),
                            body: AddAlumniForm(
                              isAdmin: true,
                              initialData: dataDecoded,
                              requestId: idReq,
                              onSuccess: () {
                                Navigator.pop(context);
                                _refresh();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Demande traitée avec succès !"))
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    } catch (e) {
                      print("Erreur de parsing JSON: $e");
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Erreur de données corrompues"))
                      );
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