import 'package:flutter/material.dart';
import '/View/theme/colors.dart';
import '/service_locator.dart';
import '/View/widget/custom_app_bar.dart';
import '/ViewModel/event/event_viewmodel.dart';
import '/l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class EventPage extends StatefulWidget {
  const EventPage({super.key});

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  late final EventViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = sl<EventViewModel>();
    _viewModel.loadData();
    _viewModel.addListener(_onViewModelChanged);
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChanged);
    _viewModel.dispose();
    super.dispose();
  }

  void _onViewModelChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  Map<String, String> _formatDateTime(String? dateStr, BuildContext context) {
    if (dateStr == null || dateStr.isEmpty) return {"day": "??", "month": "???", "time": ""};
    try {
      DateTime dt = DateTime.parse(dateStr);
      String langCode = Localizations.localeOf(context).languageCode;
      return {
        "day": dt.day.toString().padLeft(2, '0'),
        "month": DateFormat('MMM', langCode).format(dt).toUpperCase(),
        "time": "${dt.hour}h${dt.minute.toString().padLeft(2, '0')}",
      };
    } catch (e) {
      return {"day": "??", "month": "???", "time": ""};
    }
  }


  void _confirmDeletion(Map<String, dynamic> ev) {
    final traductions = AppLocalizations.of(context)!; 
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(traductions.directoryDeleteConfirmTitle),
        content: Text(traductions.directoryDeleteConfirmContent(ev['titre'] ?? traductions.untitled)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(traductions.cancel)),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              int id = int.parse(ev['id_event'].toString());
              bool success = await _viewModel.deleteEvent(id);
              if (success && mounted) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(traductions.eventDeletedSuccess)));
              }
            },
            child: Text(traductions.deleteBtn, style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _openFormEvent([Map<String, dynamic>? ev]) {
    final traductions = AppLocalizations.of(context)!;
    final bool isEdit = ev != null;
    final titleCtrl = TextEditingController(text: isEdit ? ev['titre'] : "");
    final lieuCtrl = TextEditingController(text: isEdit ? ev['lieu'] : "");
    final descCtrl = TextEditingController(text: isEdit ? ev['description'] : "");
    final dateCtrl = TextEditingController(text: isEdit ? ev['date_event'] : "2026-06-15 18:00:00");

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(isEdit ? traductions.editEvent : traductions.addEvent),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: titleCtrl, decoration: InputDecoration(labelText: traductions.dialogTitleLabel)),
              TextField(controller: dateCtrl, decoration: InputDecoration(labelText: "${traductions.dateLabel} (AAAA-MM-JJ HH:MM:SS)")),
              TextField(controller: lieuCtrl, decoration: InputDecoration(labelText: traductions.dialogLocationLabel)),
              TextField(controller: descCtrl, decoration: InputDecoration(labelText: traductions.descriptionField), maxLines: 3),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(traductions.cancel)),
          ElevatedButton(
            onPressed: () async {
              if (titleCtrl.text.isEmpty) return;
              
              final data = {
                "titre": titleCtrl.text,
                "lieu": lieuCtrl.text,
                "description": descCtrl.text,
                "date_event": dateCtrl.text,
                "id_auteur": _viewModel.currentUser?.id,
              };

              if (isEdit) {
                data["id_event"] = ev['id_event'].toString();
              }

              bool success = await _viewModel.saveEvent(data, isEdit);

              if (success && mounted) {
                Navigator.pop(ctx);
              }
            },
            child: Text(traductions.validate),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final traductions = AppLocalizations.of(context)!; 
    final isAdmin = _viewModel.isAdmin;
    final evFiltres = _viewModel.filteredEvents;

    return Scaffold(
        appBar: const CustomAppBar(),
      body: Column(
        children: [
          
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              decoration: InputDecoration(
                labelText: traductions.searchEvent,
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onChanged: _viewModel.setSearchQuery,
            ),
          ),

          Expanded(
            child: _viewModel.isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    padding: const EdgeInsets.all(10),
                    itemCount: evFiltres.length,
                    itemBuilder: (context, i) {
                      final ev = evFiltres[i];
                      final dt = _formatDateTime(ev['date_event'], context);

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
    
    final traductions = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(traductions.details), backgroundColor: AppColors.ensiCyan, foregroundColor: Colors.white),
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

                  Text("${traductions.typeLabel}${item['type'] ?? traductions.eventTypeMeeting}", style: const TextStyle(color: AppColors.ensiCyan, fontWeight: FontWeight.bold)),
                  const Divider(height: 30),
                  
                  Row(children: [const Icon(Icons.event, color: Colors.red), const SizedBox(width: 10), Text(item['date_event'] ?? "")]),
                  const SizedBox(height: 10),
                  Row(children: [const Icon(Icons.location_on, color: Colors.red), const SizedBox(width: 10), Text(item['lieu'] ?? "")]),
                  
                  const SizedBox(height: 30),
      
                  Text(traductions.descriptionLabel, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                  const SizedBox(height: 10),

                  Text(item['description'] ?? traductions.noDescription, style: const TextStyle(fontSize: 16, height: 1.5)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}