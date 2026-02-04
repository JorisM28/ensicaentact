import 'package:flutter/material.dart';
import '../colors.dart';
import '../database_service.dart';

class PageEvenements extends StatefulWidget {
  final Map<String, dynamic> user;
  const PageEvenements({super.key, required this.user});

  @override
  State<PageEvenements> createState() => _PageEvenementsState();
}

class _PageEvenementsState extends State<PageEvenements> {
  List<Map<String, dynamic>> _evenements = [];
  bool _isLoading = true;
  String _recherche = "";

  @override
  void initState() {
    super.initState();
    _chargerDonnees();
  }

  void _chargerDonnees() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    var data = await DatabaseService().getEvenements();    
    if (mounted) {
      setState(() {
        _evenements = data;
        _isLoading = false;
      });
    }
  }

  // Helper pour extraire jour, mois et heure du format SQL
  Map<String, String> _formatDateTime(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return {"day": "??", "month": "???", "time": ""};
    try {
      DateTime dt = DateTime.parse(dateStr);
      List<String> months = ["JAN", "FEV", "MAR", "AVR", "MAI", "JUN", "JUL", "AOU", "SEP", "OCT", "NOV", "DEC"];
      return {
        "day": dt.day.toString().padLeft(2, '0'),
        "month": months[dt.month - 1],
        "time": "${dt.hour}h${dt.minute.toString().padLeft(2, '0')}",
      };
    } catch (e) {
      return {"day": "??", "month": "???", "time": ""};
    }
  }

  @override
  Widget build(BuildContext context) {
    final evFiltres = _evenements.where((e) => 
      (e['titre'] ?? '').toLowerCase().contains(_recherche.toLowerCase()) ||
      (e['lieu'] ?? '').toLowerCase().contains(_recherche.toLowerCase())
    ).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Agenda ENSICAEN"),
        backgroundColor: AppColors.ensiCyan,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              decoration: InputDecoration(
                labelText: "Rechercher un évènement...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onChanged: (v) => setState(() => _recherche = v),
            ),
          ),

          Expanded(
            child: _isLoading 
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    padding: const EdgeInsets.all(10),
                    itemCount: evFiltres.length,
                    itemBuilder: (context, i) {
                      final ev = evFiltres[i];
                      final dt = _formatDateTime(ev['date_event']); 

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: InkWell(
                          onTap: () => Navigator.push(
                            context, 
                            MaterialPageRoute(builder: (context) => DetailsEvenementPage(item: ev)),
                          ),
                          child: Row(
                            children: [
                              // BLOC DATE (Gris clair comme ton design)
                              Container(
                                width: 80,
                                height: 100,
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(4), bottomLeft: Radius.circular(4)),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(dt['day']!, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFFE30613))),
                                    Text(dt['month']!, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                              // CONTENU
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 15),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(ev['titre'] ?? "", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16), maxLines: 1, overflow: TextOverflow.ellipsis),
                                      const SizedBox(height: 5),
                                      Text("📍 ${ev['lieu'] ?? ''}", style: TextStyle(color: Colors.grey[600], fontSize: 13)), // Colonne lieu
                                      Text("🕒 ${dt['time']}", style: const TextStyle(color: Colors.black54, fontSize: 12)),
                                    ],
                                  ),
                                ),
                              ),
                              const Icon(Icons.chevron_right, color: Colors.grey),
                              const SizedBox(width: 10),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class DetailsEvenementPage extends StatelessWidget {
  final Map<String, dynamic> item;
  const DetailsEvenementPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Détails"), backgroundColor: AppColors.ensiCyan, foregroundColor: Colors.white),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (item['image_url'] != null)
              Image.network(item['image_url'], width: double.infinity, height: 250, fit: BoxFit.cover),
            
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item['titre'] ?? "", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text("Type : ${item['type'] ?? 'Rencontre'}", style: const TextStyle(color: AppColors.ensiCyan, fontWeight: FontWeight.bold)),
                  const Divider(height: 30),
                  
                  Row(children: [const Icon(Icons.event, color: Colors.red), const SizedBox(width: 10), Text(item['date_event'] ?? "")]),
                  const SizedBox(height: 10),
                  Row(children: [const Icon(Icons.location_on, color: Colors.red), const SizedBox(width: 10), Text(item['lieu'] ?? "")]),
                  
                  const SizedBox(height: 30),
                  const Text("Description :", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                  const SizedBox(height: 10),
                  Text(item['description'] ?? "Aucune description.", style: const TextStyle(fontSize: 16, height: 1.5)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}