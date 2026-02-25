import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; 
import '/Model/data/services/alumni_repository.dart';
import '/service_locator.dart';
import '/Model/core/theme/colors.dart';
import '/View/screens/event/event_page.dart';
import '/l10n/app_localizations.dart'; 

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
    _loadData();
  }

  void _loadData() async {
    if (!mounted) return;
    try {
      var data = await sl<AlumniRepository>().getEvents();
      if (mounted) setState(() { _events = data; _isLoading = false; });
    } catch (e) { if (mounted) setState(() => _isLoading = false); }
  }

  void _confirmDeletion(Map<String, dynamic> item) {
    final traductions = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(traductions.directoryDeleteConfirmTitle),
        content: Text(traductions.directoryDeleteConfirmContent(item['titre'] ?? traductions.untitled)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(traductions.cancel)),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              int idToDelete = int.tryParse(item['id_event'].toString()) ?? 0;
              bool success = await sl<AlumniRepository>().deleteEvent(idToDelete);

              if (success && mounted) {
                setState(() {
                  _events.removeWhere((element) => element['id_event'] == item['id_event']);
                });
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(traductions.eventDeletedSuccess))
                );
              }
            },
            child: Text(traductions.deleteBtn, style: const TextStyle(color: Colors.red)),
          )
        ],
      ),
    );
  }

  Map<String, String> _formatDate(String? dateString, BuildContext context) {
    if (dateString == null || dateString.isEmpty) return {"day": "??", "month": "??"};
    try {
      DateTime dt = DateTime.parse(dateString);
      String langCode = Localizations.localeOf(context).languageCode;
      return {
        "day": dt.day.toString().padLeft(2, '0'),
        // Utilise intl pour traduire automatiquement le mois ("FEB" en anglais, "FÉV" en français)
        "month": DateFormat('MMM', langCode).format(dt).toUpperCase()
      };
    } catch (e) { return {"day": "??", "month": "??"}; }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Center(child: CircularProgressIndicator());

    final traductions = AppLocalizations.of(context)!;
    final displayList = _events.take(3).toList();
    bool isAdmin = widget.user['role'] == 'admin';

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isAdmin && widget.onAddPress != null) ...const [
              Spacer(),
            ],
            Text(
              traductions.eventsTab.toUpperCase(),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.ensiCyan),
            ),
            if (isAdmin && widget.onAddPress != null) ...[
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.add_circle, color: AppColors.ensiCyan, size: 24),
              onPressed: widget.onAddPress,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              tooltip: traductions.addEventTooltip,
            ),]
          ],),
        ),

        Expanded(
          child: displayList.isEmpty
              ? Center(child: Text(traductions.noUpcomingEvents))
              : SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: displayList.map((item) => _buildEventCard(item, isAdmin, traductions)).toList(),
            ),
          ),
        ),

        const SizedBox(height: 20),

        OutlinedButton(
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => EventPage(user: widget.user))),
          style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFFE30613)),
              backgroundColor: Colors.white
          ),
          child: Text(traductions.seeAllEvents, style: const TextStyle(color: Color(0xFFE30613))),
        ),
      ],
    );
  }

  Widget _buildEventCard(Map<String, dynamic> item, bool estAdmin, AppLocalizations traductions) {
    final String title = item['titre'] ?? traductions.untitled;
    final String location = item['lieu'] ?? traductions.locationNotSpecified;
    final dateMap = _formatDate(item['date_event'], context); 

    return Card(
      color: Colors.grey.shade100,
      margin: const EdgeInsets.only(bottom: 15),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: Colors.white60),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailEventPage(item: item),
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
          onPressed: () => _confirmDeletion(item),
        )
            : const Icon(Icons.arrow_forward_ios, size: 14),
      ),
    );
  }
}