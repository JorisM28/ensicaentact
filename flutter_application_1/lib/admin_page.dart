import 'package:flutter/material.dart';
import 'database_service.dart';
import 'alumnis.dart';
import 'colors.dart'; // Assure-toi que le chemin est bon


// -------------------------------------------------------------------
// GEMINI PAGE TEST A REFAIRE
// -------------------------------------------------------------------



class AdminPage extends StatefulWidget {
  final Map<String, dynamic> user;
  const AdminPage({super.key, required this.user});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  // On récupère le service pour charger les données
  final DatabaseService _dbService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Administration'),
        backgroundColor: Colors.red[800], // Rouge pour différencier de l'app étudiant
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pop(context); // Déconnexion (retour login)
            },
          )
        ],
      ),
      body: FutureBuilder<List<Alumnis>>(
        future: _dbService.getEveryStudent(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Erreur : ${snapshot.error}"));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Aucun élève trouvé."));
          }

          final listeEleves = snapshot.data!;

          return ListView.builder(
            itemCount: listeEleves.length,
            padding: const EdgeInsets.all(10),
            itemBuilder: (context, index) {
              final eleve = listeEleves[index];
              return Card(
                elevation: 2,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppColors.ensiCyan,
                    child: Text(eleve.prenom.isNotEmpty ? eleve.prenom[0] : "?", style: const TextStyle(color: Colors.white)),
                  ),
                  title: Text("${eleve.fullName} (Promo ${eleve.promo})"),
                  subtitle: Text(eleve.job),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      // Ici on pourra ajouter la fonction supprimer plus tard
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Suppression de ${eleve.nom} (À implémenter PHP)")),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}