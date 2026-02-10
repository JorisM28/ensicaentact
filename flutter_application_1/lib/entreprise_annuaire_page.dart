import 'package:flutter/material.dart';
import '../colors.dart';
import 'database_service.dart';
import 'carte_entreprise_widget.dart';

class PageAnnuaireEntreprise extends StatefulWidget {
  const PageAnnuaireEntreprise({super.key});

  @override
  State<PageAnnuaireEntreprise> createState() =>
      _PageAnnuaireEntrepriseState();
}

class _PageAnnuaireEntrepriseState extends State<PageAnnuaireEntreprise> {
  final DatabaseService _dbService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    final isWideScreen = MediaQuery.of(context).size.width > 900;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Annuaire des Entreprises",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.ensiCyan,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _dbService.getEntreprise(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
                child: Text(
                    "Erreur de chargement : ${snapshot.error}"));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Aucune entreprise trouvée"));
          }

          final entreprises = snapshot.data!;

          final listWidget = ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: entreprises.length,
            separatorBuilder: (_, __) =>
            const Divider(height: 30),
            itemBuilder: (context, index) {
              final item = entreprises[index];

              final nom =
                  item['nom_entreprise'] ?? "Inconnu";
              final nb =
                  item['nombre_alumni']?.toString() ?? "0";
              final ville = item['ville'] ?? "";
              final pays = item['pays'] ?? "";

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.business,
                          color: AppColors.ensiCyan),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          nom,
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.ensiCyan),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.ensiCyan.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          "$nb alumni",
                          style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  _buildInfoRow(
                    Icons.location_on,
                    "Localisation",
                    pays.isNotEmpty ? "$ville, $pays" : ville,
                  ),
                ],
              );
            },
          );

          final mapWidget =
          CarteEntrepriseWidget(entreprises: entreprises);

          return isWideScreen
              ? Row(
            children: [
              Expanded(flex: 2, child: listWidget),
              const VerticalDivider(width: 1),
              Expanded(flex: 3, child: mapWidget),
            ],
          )
              : Column(
            children: [
              Expanded(flex: 2, child: listWidget),
              const Divider(height: 1),
              Expanded(flex: 3, child: mapWidget),
            ],
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(
      IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, left: 34),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: Colors.grey),
              const SizedBox(width: 5),
              Text(
                label,
                style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 14),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}