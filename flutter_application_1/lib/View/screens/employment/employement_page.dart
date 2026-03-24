import 'package:flutter/material.dart';
import '/View/widget/base_layout.dart';
import '/ViewModel/employment_viewmodel.dart';
import '/l10n/app_localizations.dart';

class EmploymentPage extends StatefulWidget {
  const EmploymentPage({super.key});

  @override
  State<EmploymentPage> createState() => _EmploymentPageState();
}

class _EmploymentPageState extends State<EmploymentPage> {
  late CareerViewModel viewModel;
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    viewModel = CareerViewModel();
    viewModel.loadOffers();
    viewModel.addListener(() => setState(() {}));
  }

  void _confirmDeletion(String id) {
    final traductions = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(traductions.deleteOfferTitle),
        content: Text(traductions.deleteOfferContent),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(traductions.cancel)),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              bool ok = await viewModel.deleteOffer(id);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(ok ? traductions.offerDeletedSuccess : traductions.offerDeletedError))
                );
              }
            },
            child: Text(traductions.deleteBtn, style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final traductions = AppLocalizations.of(context)!;
    return BaseLayout(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: _searchCtrl,
              decoration: InputDecoration(
                labelText: traductions.searchOfferHint,
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                suffixIcon: viewModel.offerSearch.isNotEmpty
                    ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchCtrl.clear();
                      viewModel.updateOfferSearch("");
                    })
                    : null,
              ),
              onChanged: viewModel.updateOfferSearch,
            ),
          ),
          Expanded(
            child: viewModel.isLoadingOffers
                ? const Center(child: CircularProgressIndicator())
                : Row(
              children: [
                Expanded(child: _buildColumn(traductions.jobOffersTitle, Colors.blue[800]!, viewModel.employmentOffers, false)),
                Container(width: 1, color: Colors.grey[300]),
                Expanded(child: _buildColumn(traductions.internshipOffersTitle, Colors.orange[800]!, viewModel.internshipOffers, true)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColumn(String title, Color color, List<Map<String, dynamic>> list, bool isInternship) {
    final traductions = AppLocalizations.of(context)!; 
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(15),
          color: color.withOpacity(0.1),
          child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)
          ),
        ),
        Expanded(
          child: list.isEmpty
              ? Center(child: Text(traductions.noOfferFound, style: TextStyle(color: Colors.grey)))
              : ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: list.length,
            itemBuilder: (context, index) {
              final offre = list[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                elevation: 2,
                child: ListTile(
                  title: Text(offre['titre'] ?? traductions.defaultJobTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("${offre['entreprise']} - ${offre['ville']}"),
                      if (offre['nom_auteur'] != null)
                        Text(
                            "${traductions.byPrefix} ${offre['prenom_auteur']} ${offre['nom_auteur']}",
                            style: TextStyle(fontSize: 10, color: Colors.grey[600], fontStyle: FontStyle.italic)
                        ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                            color: color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(5)
                        ),
                        child: Text(
                            offre['type'] ?? '',
                            style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.bold)
                        ),
                      ),
                      if (viewModel.canUserDeleteOffer(offre)) ...[
                        const SizedBox(width: 10),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                          onPressed: () => _confirmDeletion(offre['id_offre'].toString()),
                        ),
                      ]
                    ],
                  ),
                  onTap: () => _seeDetail(offre),
                ),
              );
            },
          ),
        ),
        if (viewModel.canAddOffer)
          Padding(
            padding: const EdgeInsets.all(15),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    backgroundColor: color,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.all(15)
                ),
                icon: const Icon(Icons.add),
                label: Text(isInternship ? traductions.addInternship : traductions.addJob),
                onPressed: () => _addPopUp(isInternship, color),
              ),
            ),
          ),
      ],
    );
  }

  void _seeDetail(Map<String, dynamic> o) {
    final traductions = AppLocalizations.of(context)!;
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(o['titre'] ?? ""),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("🏢 ${o['entreprise']} ${traductions.atLocation}${o['ville']}", style: const TextStyle(fontWeight: FontWeight.bold)),
                const Divider(height: 30),
                Text(traductions.descriptionLabel, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                Text(o['description'] ?? traductions.noDescription),
                const SizedBox(height: 20),
                Text(traductions.contactLabel, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                SelectableText(o['contact_email'] ?? "", style: const TextStyle(color: Colors.blue)),
              ],
            ),
          ),
          actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: Text(traductions.close))],
        )
    );
  }

  void _addPopUp(bool isStage, Color color) {
    final traductions = AppLocalizations.of(context)!;
    final tCtrl = TextEditingController();
    final cCtrl = TextEditingController();
    final vCtrl = TextEditingController();
    final eCtrl = TextEditingController();
    final dCtrl = TextEditingController();
    String typeSelect = isStage ? 'Stage' : 'CDI';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setStateDialog) => AlertDialog(
          title: Text(isStage ? traductions.newInternship : traductions.newJob),
          content: SizedBox(
            width: 400,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(controller: tCtrl, decoration: InputDecoration(labelText: traductions.jobTitleLabel)),
                  TextField(controller: cCtrl, decoration: InputDecoration(labelText: traductions.companyLabel)),
                  TextField(controller: vCtrl, decoration: InputDecoration(labelText: traductions.cityLabel)),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    initialValue: typeSelect,
                    items: (isStage ? ['Stage'] : ['CDI', 'CDD', 'Alternance', 'Freelance'])
                        .map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                    onChanged: (v) => setStateDialog(() => typeSelect = v!),
                    decoration: InputDecoration(labelText: traductions.typeLabel),
                  ),
                  TextField(controller: eCtrl, decoration: InputDecoration(labelText: traductions.contactEmailLabel)),
                  TextField(controller: dCtrl, decoration: InputDecoration(labelText: traductions.descriptionField), maxLines: 3),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: Text(traductions.cancel)),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: color, foregroundColor: Colors.white),
              onPressed: () async {
                if (tCtrl.text.isNotEmpty && cCtrl.text.isNotEmpty) {
                  bool ok = await viewModel.addOffer({
                    "titre": tCtrl.text,
                    "entreprise": cCtrl.text,
                    "ville": vCtrl.text,
                    "type": typeSelect,
                    "contact_email": eCtrl.text,
                    "description": dCtrl.text,
                  });
                  if (ok && mounted) Navigator.pop(ctx);
                }
              },
              child: Text(traductions.publish),
            ),
          ],
        ),
      ),
    );
  }
}