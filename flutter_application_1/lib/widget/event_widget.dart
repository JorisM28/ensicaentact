import 'package:flutter/material.dart';
import '../database_service.dart';
import '../colors.dart';
import '../page_évènements.dart';

class EventWidget extends StatefulWidget {
  final Map<String, dynamic> user;
  final VoidCallback? onAddPress;

  const EventWidget({super.key, required this.user, this.onAddPress});

  @override
  State<EventWidget> createState() => _EventWidgetState();
}

class _EventWidgetState extends State<EventWidget> {
  List<Map<String, dynamic>> _events = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _chargerDonnees();
  }

  void _chargerDonnees() async {
    if (!mounted) return;
    try {
      var data = await DatabaseService().getEvenements();
      if (mounted) setState(() { _events = data; _isLoading = false; });
    } catch (e) { if (mounted) setState(() => _isLoading = false); }
  }

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
              int idToDelete = int.tryParse(item['id_event'].toString()) ?? 0;
              bool success = await DatabaseService().supprimerEvenement(idToDelete);

              if (success && mounted) {
                setState(() {
                  _events.removeWhere((element) => element['id_event'] == item['id_event']);
                });
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Événement supprimé !"))
                );
              }
            },
            child: const Text("Supprimer", style: TextStyle(color: Colors.red)),
          )
        ],
      ),
    );
  }

  Map<String, String> _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return {"day": "??", "month": "??"};
    try {
      DateTime dt = DateTime.parse(dateString);
      List<String> months = ["JAN", "FÉV", "MAR", "AVR", "MAI", "JUIN", "JUIL", "AOÛT", "SEPT", "OCT", "NOV", "DÉC"];
      return {"day": dt.day.toString().padLeft(2, '0'), "month": months[dt.month - 1]};
    } catch (e) { return {"day": "??", "month": "??"}; }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Center(child: CircularProgressIndicator());

    final displayList = _events.take(3).toList();
    bool estAdmin = widget.user['role'] == 'admin';

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (estAdmin && widget.onAddPress != null) ...const [
              const Spacer(),
            ],
            const Text(
            "ÉVÈNEMENTS",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.ensiCyan),
            ),
            if (estAdmin && widget.onAddPress != null) ...[
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.add_circle, color: AppColors.ensiCyan, size: 24),
              onPressed: widget.onAddPress,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              tooltip: "Ajouter un évènement",
            ),]
          ],),
        ),

        Expanded(
          child: displayList.isEmpty
              ? const Center(child: Text("Aucun événement à venir."))
              : SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: displayList.map((item) => _buildEventCard(item, estAdmin)).toList(),
            ),
          ),
        ),

        const SizedBox(height: 20),

        OutlinedButton(
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PageEvenements(user: widget.user))),
          style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFFE30613)),
              backgroundColor: Colors.white
          ),
          child: const Text("Voir tous les évènements", style: TextStyle(color: Color(0xFFE30613))),
        ),
      ],
    );
  }

  Widget _buildEventCard(Map<String, dynamic> item, bool estAdmin) {
    final String title = item['titre'] ?? "Événement";
    final String location = item['lieu'] ?? "Lieu non précisé";
    final dateMap = _formatDate(item['date_event']);

    return Card(
      color: Colors.grey.shade100,
      margin: const EdgeInsets.only(bottom: 15),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.white60),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailsEvenementPage(item: item),
            ),
          );
        },
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Container(
            width: 50, height: 50,
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(dateMap['day']!, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFFE30613))),
                Text(dateMap['month']!, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black)),
              ],
            ),
          ),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14), maxLines: 2, overflow: TextOverflow.ellipsis),
        subtitle: Text(location, style: TextStyle(color: Colors.grey.shade800, fontSize: 12)),
        trailing: estAdmin
            ? IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
          onPressed: () => _confirmerSuppression(item),
        )
            : const Icon(Icons.arrow_forward_ios, size: 14),
      ),
    );
  }
}