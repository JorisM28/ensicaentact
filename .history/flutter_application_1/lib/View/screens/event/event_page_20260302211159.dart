import 'package:flutter/material.dart';
import '../../../Model/user_model.dart';
import '../../theme/colors.dart';
import '/service_locator.dart';
import '/Model/data/services/alumni_repository.dart';
import '/View/widget/custom_app_bar.dart';
import '/Model/data/services/auth_service.dart';

class EventPage extends StatefulWidget {
  const EventPage({super.key});

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  List<Map<String, dynamic>> _event = [];
  bool _isLoading = true;
  String _search = "";

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  
  void _loadData() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    var data = await sl<AlumniRepository>().getEvents();
    if (mounted) {
      setState(() {
        _event = data;
        _isLoading = false;
      });
    }
  }

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


  void _confirmDeletion(Map<String, dynamic> ev) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Supprimer l'évènement ?"),
        content: Text("Voulez-vous supprimer : \"${ev['titre']}\" ?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Annuler")),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              int id = int.parse(ev['id_event'].toString());
              bool success = await sl<AlumniRepository>().deleteEvent(id);
              if (success) {
                _loadData();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Évènement supprimé")));
              }
            },
            child: const Text("Supprimer", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _openFormEvent([Map<String, dynamic>? ev]) {
    final currentUser = sl<AuthService>().currentUser;
    final bool isEdit = ev != null;
    final titleCtrl = TextEditingController(text: isEdit ? ev['titre'] : "");
    final lieuCtrl = TextEditingController(text: isEdit ? ev['lieu'] : "");
    final descCtrl = TextEditingController(text: isEdit ? ev['description'] : "");
    final dateCtrl = TextEditingController(text: isEdit ? ev['date_event'] : "2026-06-15 18:00:00");

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(isEdit ? "Modifier l'évènement" : "Ajouter un évènement"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: "Titre")),
              TextField(controller: dateCtrl, decoration: const InputDecoration(labelText: "Date (AAAA-MM-JJ HH:MM:SS)")),
              TextField(controller: lieuCtrl, decoration: const InputDecoration(labelText: "Lieu")),
              TextField(controller: descCtrl, decoration: const InputDecoration(labelText: "Description"), maxLines: 3),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Annuler")),
          ElevatedButton(
            onPressed: () async {
              if (titleCtrl.text.isEmpty) return;
              
              final data = {
                "titre": titleCtrl.text,
                "lieu": lieuCtrl.text,
                "description": descCtrl.text,
                "date_event": dateCtrl.text,
<<<<<<< HEAD
                "id_auteur": currentUser?['id_user'] ?? "0",
=======
                "id_auteur": widget.user.id,
>>>>>>> 3ed3c121283449efcd82b1039d7f9736fe0ed6fd
              };

              bool success;
              if (isEdit) {
                data["id_event"] = ev['id_event'].toString();
                success = await sl<AlumniRepository>().editEvent(data);
              } else {
                success = await sl<AlumniRepository>().addEvent(data);
              }

              if (success) {
                Navigator.pop(ctx);
                _loadData();
              }
            },
            child: const Text("Enregistrer"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    final currentUser = sl<AuthService>().currentUser;
    bool isAdmin = currentUser?['role'] == 'admin';
=======
    bool isAdmin = widget.user.isAdmin;
>>>>>>> 3ed3c121283449efcd82b1039d7f9736fe0ed6fd
    final evFiltres = _event.where((e) => 
      (e['titre'] ?? '').toLowerCase().contains(_search.toLowerCase()) ||
      (e['lieu'] ?? '').toLowerCase().contains(_search.toLowerCase())
    ).toList();

    return Scaffold(
        appBar: CustomAppBar(),
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
              onChanged: (v) => setState(() => _search = v),
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
                            MaterialPageRoute(builder: (context) => DetailEventPage(item: ev)),
                          ),
                          child: Row(
                            children: [
                              
                              Container(
                                width: 80, height: 100,
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
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 15),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(ev['titre'] ?? "", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16), maxLines: 1, overflow: TextOverflow.ellipsis),
                                      const SizedBox(height: 5),
                                      Text("📍 ${ev['lieu'] ?? ''}", style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                                      Text("🕒 ${dt['time']}", style: const TextStyle(color: Colors.black54, fontSize: 12)),
                                    ],
                                  ),
                                ),
                              ),
                              
                              
                              if (isAdmin) ...[
                                IconButton(
                                  icon: const Icon(Icons.edit_outlined, color: Colors.blue, size: 20),
                                  onPressed: () => _openFormEvent(ev),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                                  onPressed: () => _confirmDeletion(ev),
                                ),
                              ] else 
                                const Icon(Icons.chevron_right, color: Colors.grey),
                              
                              const SizedBox(width: 5),
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

class DetailEventPage extends StatelessWidget {
  final Map<String, dynamic> item;
  const DetailEventPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Détails"), backgroundColor: AppColors.ensiCyan, foregroundColor: Colors.white),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (item['image_url'] != null && item['image_url'].toString().isNotEmpty)
              Image.network(item['image_url'], width: double.infinity, height: 250, fit: BoxFit.cover,
                errorBuilder: (c, e, s) => Container(height: 100, color: Colors.grey[200], child: const Icon(Icons.image_not_supported))),
            
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