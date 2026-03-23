import 'package:flutter/material.dart';
import '/View/widget/base_layout.dart';
import '/service_locator.dart';
import '/Model/data/services/auth_service.dart';
import '/l10n/app_localizations.dart';
import '/ViewModel/event/job_viewmodel.dart';

class JobPage extends StatefulWidget {
  const JobPage({super.key});

  @override
  State<JobPage> createState() => _JobPageState();
}

class _JobPageState extends State<JobPage> {
  final JobViewModel viewModel = sl<JobViewModel>();

  String _search = "";
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();

    viewModel.loadOffers();
  }

  void confirmDeletion(String idOffre) {
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

              bool success = await viewModel.deleteOffer(idOffre);
              if (success && mounted) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(traductions.offerDeletedSuccess)));
              }
            },
            child: Text(traductions.deleteBtn, style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void openForm({Map<String, dynamic>? existingOffer, required bool isInternship, required Color color}) {
    final bool isEditing = existingOffer != null;
    final currentUser = sl<AuthService>().currentUser;
    final traductions = AppLocalizations.of(context)!;

    final titleCtrl = TextEditingController(text: isEditing ? existingOffer['titre'] : "");
    final companyCtrl = TextEditingController(text: isEditing ? existingOffer['entreprise'] : "");
    final cityCtrl = TextEditingController(text: isEditing ? existingOffer['ville'] : "");
    final emailCtrl = TextEditingController(text: isEditing ? existingOffer['contact_email'] : "");
    final descCtrl = TextEditingController(text: isEditing ? existingOffer['description'] : "");

    String typeSelect = isEditing ? (existingOffer['type'] ?? 'CDI') : (isInternship ? 'Stage' : 'CDI');

    final List<String> possibleTypes = isInternship
        ? ['Stage en présentiel','Stage hybride','Stage en distanciel']
        : ['CDI', 'CDD', 'Alternance', 'Freelance', 'Intérim'];

    if (!possibleTypes.contains(typeSelect)) {
      typeSelect = possibleTypes.first;
    }

    showDialog(
      context: context,
      builder: (contextDialog) => StatefulBuilder(
        builder: (contextDialog, setStateDialog) {
          return AlertDialog(
            title: Text(isEditing ? traductions.editOffer : (isInternship ? traductions.newInternship : traductions.newJob)),
            content: SizedBox(
              width: 400,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(controller: titleCtrl, decoration: InputDecoration(labelText: traductions.jobTitleLabel)),
                    TextField(controller: companyCtrl, decoration: InputDecoration(labelText: traductions.companyLabel)),
                    TextField(controller: cityCtrl, decoration: InputDecoration(labelText: traductions.cityLabel)),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: typeSelect,
                      items: possibleTypes.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                      onChanged: (v) => setStateDialog(() => typeSelect = v!),
                      decoration: InputDecoration(labelText: traductions.typeLabel),
                    ),
                    TextField(controller: emailCtrl, decoration: InputDecoration(labelText: traductions.contactEmailLabel)),
                    TextField(controller: descCtrl, decoration: InputDecoration(labelText: traductions.descriptionField), maxLines: 4),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(contextDialog), child: Text(traductions.cancel)),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: color, foregroundColor: Colors.white),
                onPressed: () async {
                  if (titleCtrl.text.isNotEmpty && companyCtrl.text.isNotEmpty) {
                    String monId = (currentUser?.id).toString();

                    final Map<String, dynamic> dataToSend = {
                      "titre": titleCtrl.text,
                      "entreprise": companyCtrl.text,
                      "ville": cityCtrl.text,
                      "type": typeSelect,
                      "contact_email": emailCtrl.text,
                      "description": descCtrl.text,
                      "id_auteur": monId
                    };

                    if (isEditing) {
                      dataToSend["id_offre"] = existingOffer['id_offre'].toString();
                    }


                    bool success = await viewModel.saveOffer(dataToSend, isEditing);

                    if (mounted) {
                      Navigator.pop(contextDialog);
                      if (success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(isEditing ? traductions.offerEditedSuccess : traductions.offerPublishedSuccess))
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(traductions.serverError), backgroundColor: Colors.red)
                        );
                      }
                    }
                  }
                },
                child: Text(isEditing ? traductions.validate : traductions.publish),
              ),
            ],
          );
        },
      ),
    );
  }

  void _seeDetail(Map<String, dynamic> offre) {
    final traductions = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(offre['titre'] ?? ""),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("🏢 ${offre['entreprise']} ${traductions.atLocation} ${offre['ville']}", style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(5)),
                child: Text("${traductions.typeLabel} ${offre['type']}"),
              ),
              const Divider(height: 30),
              Text(traductions.descriptionLabel, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
              Text(offre['description'] ?? traductions.noDescription),
              const SizedBox(height: 20),
              Text(traductions.contactLabel, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
              SelectableText(offre['contact_email'] ?? "", style: const TextStyle(color: Colors.blue)),
            ],
          ),
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text(traductions.close))],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final traductions = AppLocalizations.of(context)!;
    final currentUser = sl<AuthService>().currentUser;
    String role = currentUser?.role ?? 'guest';
    String myId = (currentUser?.id ?? '0').toString();

    bool isAdmin = (role == 'admin');
    bool isAlumni = (role == 'alumni');
    bool canAdd = (isAdmin || isAlumni);

    return BaseLayout(
      body: ListenableBuilder(
        listenable: viewModel,
        builder: (context, _) {
          final filteredOffers = viewModel.everyOffer.where((o) {
            final titre = (o['titre'] ?? '').toLowerCase();
            final companies = (o['entreprise'] ?? '').toLowerCase();
            final keyWord = _search.toLowerCase();
            return titre.contains(keyWord) || companies.contains(keyWord);
          }).toList();

          final internshipList = filteredOffers.where((o) => (o['type'] ?? '').toLowerCase() == 'stage').toList();
          final jobList = filteredOffers.where((o) => (o['type'] ?? '').toLowerCase() != 'stage').toList();

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  controller: _searchCtrl,
                  decoration: InputDecoration(
                    labelText: traductions.searchOfferHint,
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    suffixIcon: _search.isNotEmpty
                        ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () => setState(() {
                          _searchCtrl.clear();
                          _search = "";
                        }))
                        : null,
                  ),
                  onChanged: (val) => setState(() => _search = val),
                ),
              ),
              Expanded(
                child: viewModel.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Row(
                  children: [
                    Expanded(
                      child: _buildColumn(
                        title: traductions.jobOffersTitle,
                        color: Colors.blue[800]!,
                        list: jobList,
                        isInternship: false,
                        canAdd: canAdd,
                        id: myId,
                        isAdmin: isAdmin,
                        traductions: traductions,
                      ),
                    ),
                    Container(width: 1, color: Colors.grey[300]),
                    Expanded(
                      child: _buildColumn(
                        title: traductions.internshipOffersTitle,
                        color: Colors.orange[800]!,
                        list: internshipList,
                        isInternship: true,
                        canAdd: canAdd,
                        id: myId,
                        isAdmin: isAdmin,
                        traductions: traductions,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildColumn({
    required String title,
    required Color color,
    required List<Map<String, dynamic>> list,
    required bool isInternship,
    required bool canAdd,
    required String id,
    required bool isAdmin,
    required AppLocalizations traductions,
  }) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(15),
          color: color.withOpacity(0.1),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color),
          ),
        ),

        Expanded(
          child: list.isEmpty
              ? Center(child: Text(traductions.noOfferFound, style: const TextStyle(color: Colors.grey)))
              : ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: list.length,
            itemBuilder: (context, index) {
              final offre = list[index];
              String idOfferAuthor = (offre['id_auteur'] ?? '').toString();
              bool isMyOffer = (idOfferAuthor == id);
              bool can = isAdmin || isMyOffer;

              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                elevation: 2,
                child: ListTile(
                  title: Text(offre['titre'] ?? traductions.defaultJobTitle, style: const TextStyle(fontWeight: FontWeight.bold), maxLines: 2, overflow: TextOverflow.ellipsis),
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
                  onTap: () => _seeDetail(offre),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (!can)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(5)),
                          child: Text(offre['type'] ?? '', style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.bold)),
                        ),

                      if (can) ...[
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue, size: 20),
                          onPressed: () => openForm(existingOffer: offre, isInternship: isInternship, color: color),
                          tooltip: traductions.editBtn,
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                          onPressed: () => confirmDeletion(offre['id_offre'].toString()),
                          tooltip: traductions.deleteBtn,
                        ),
                      ]
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        if (canAdd)
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
                onPressed: () => openForm(isInternship: isInternship, color: color),
              ),
            ),
          ),
      ],
    );
  }
}