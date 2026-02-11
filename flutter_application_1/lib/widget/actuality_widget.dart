import 'package:flutter/material.dart';
import '../database_service.dart';
import '../colors.dart';
import '../page_actualités.dart'; 

class ActualityWidget extends StatefulWidget {
  final Map<String, dynamic> user;
  
  // Le constructeur accepte une Key pour le refresh forcé depuis l'accueil
  const ActualityWidget({super.key, required this.user});

  @override
  State<ActualityWidget> createState() => _ActualityWidgetState();
}

class _ActualityWidgetState extends State<ActualityWidget> {
  List<Map<String, dynamic>> _actus = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _chargerDonnees();
  }

  // Charge les données depuis la BDD
  void _chargerDonnees() async {
    if (!mounted) return;
    var data = await DatabaseService().getActualites();
    if (mounted) {
      setState(() {
        _actus = data;
        _isLoading = false;
      });
    }
  }

  // Ta fonction de parsing de couleur
  Color _parseColor(String? hexString) {
    if (hexString == null || hexString.isEmpty) return const Color(0xFF67CBB8);
    try {
      final buffer = StringBuffer();
      if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
      buffer.write(hexString.replaceFirst('#', ''));
      return Color(int.parse(buffer.toString(), radix: 16));
    } catch (e) {
      return const Color(0xFF67CBB8); 
    }
  }

  // Fonction de suppression avec mise à jour instantanée
  void _confirmerSuppression(Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Supprimer ?"),
        content: Text("Voulez-vous vraiment supprimer \"${item['titre']}\" ?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Annuler")),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              int idToDelete = int.parse(item['id_actu'].toString());
              bool success = await DatabaseService().supprimerActualite(idToDelete);

              if (success && mounted) {
                setState(() {
                  // On retire l'élément de la liste locale pour qu'il disparaisse direct
                  _actus.removeWhere((element) => element['id_actu'] == item['id_actu']);
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Actualité supprimée !"))
                );
              }
            },
            child: const Text("Supprimer", style: TextStyle(color: Colors.red)),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Center(child: CircularProgressIndicator());
    if (_actus.isEmpty) return const Center(child: Text("Aucune actualité disponible."));

    // On prend les 3 dernières pour l'accueil
    final displayList = _actus.take(3).toList();
    bool estAdmin = widget.user['role'] == 'admin';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Column(
        children: [
          const Text(
            "ACTUALITÉS",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.ensiCyan),
          ),
          const SizedBox(height: 20),
          
          // On génère la liste des cartes
          ...displayList.map((item) => _buildNewsCard(item, estAdmin)).toList(),

          const SizedBox(height: 20),
          
          OutlinedButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PageActualites(user: widget.user))),
            style: OutlinedButton.styleFrom(side: const BorderSide(color: Color(0xFFE30613))),
            child: const Text("Voir toutes les actualités", style: TextStyle(color: Color(0xFFE30613))),
          ),
        ],
      ),
    );
  }

  Widget _buildNewsCard(Map<String, dynamic> item, bool estAdmin) {
    final String title = item['titre'] ?? "Sans titre";
    final String tag = item['tag'] ?? "NEWS";
    final Color tagColor = _parseColor(item['tag_color']); 
    final String? imageUrl = item['image_url'];

    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      elevation: 3,
      child: ListTile(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => DetailsPageSimple(item: item))),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Container(
            width: 60, height: 60, color: Colors.grey[200],
            child: (imageUrl != null && imageUrl.isNotEmpty)
                ? Image.network(imageUrl, fit: BoxFit.cover)
                : const Icon(Icons.image, color: Colors.grey),
          ),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold), maxLines: 2, overflow: TextOverflow.ellipsis),
        subtitle: Text(tag, style: TextStyle(color: tagColor, fontSize: 12, fontWeight: FontWeight.bold)),
        trailing: estAdmin 
          ? IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () => _confirmerSuppression(item),
            )
          : const Icon(Icons.arrow_forward_ios, size: 14),
      ),
    );
  }
}