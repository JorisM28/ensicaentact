import 'package:flutter/material.dart';
import '../../../Model/core/theme/colors.dart';
import '../../../Model/data/services/database_service.dart';

class EmploymentPage extends StatefulWidget {
  final Map<String, dynamic> user;

  const EmploymentPage({super.key, required this.user});

  @override
  State<EmploymentPage> createState() => _EmploymentPageState();
}

class _EmploymentPageState extends State<EmploymentPage> {
  
  List<Map<String, dynamic>> _allOffers = [];
  bool _isLoading = true;

  String _search = "";
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadTrueOffers();
  }

  void _loadTrueOffers() async {
    setState(() => _isLoading = true);
    
    var data = await DatabaseService().getOffers();
    
    if (mounted) {
      setState(() {
        _allOffers = data;
        _isLoading = false;
      });
    }
  }

  void _deleteComfirm(String idOffre) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Supprimer l'offre ?"),
        content: const Text("Cette action est irréversible."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Annuler")),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              
              bool success = await DatabaseService().deleteOffers(idOffre);
              
              if (success) {
                _loadTrueOffers();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Offre supprimée avec succès."))
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Erreur lors de la suppression."))
                );
              }
            },
            child: const Text("Supprimer", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String role = widget.user['role'] ?? 'guest';
    String myId = widget.user['id'].toString();
    bool isAdmin = (role == 'admin');
    bool canAdd = (isAdmin || role == 'alumni');

    final filteredOffers = _allOffers.where((o) {
      final title = (o['titre'] ?? '').toLowerCase();
      final company = (o['entreprise'] ?? '').toLowerCase();
      final keyWord = _search.toLowerCase();
            return title.contains(keyWord) || company.contains(keyWord);
    }).toList();

    final internshipList = filteredOffers.where((o) => (o['type'] ?? '').toLowerCase() == 'stage').toList();
    final employmentOffers = filteredOffers.where((o) => (o['type'] ?? '').toLowerCase() != 'stage').toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Carrières & Stages"),
        backgroundColor: AppColors.ensiCyan,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh), 
            onPressed: _loadTrueOffers
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: _searchCtrl,
              decoration: InputDecoration(
                labelText: "Rechercher (Poste, Entreprise...)",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                suffixIcon: _search.isNotEmpty 
                  ? IconButton(
                      icon: const Icon(Icons.clear), 
                      onPressed: () {
                        setState(() {
                          _searchCtrl.clear();
                          _search = "";
                        });
                      },
                    ) 
                  : null,
              ),
              onChanged: (val) {
                setState(() {
                  _search = val;
                });
              },
            ),
          ),

          Expanded(
            child: _isLoading 
            ? const Center(child: CircularProgressIndicator())
            : Row(
                children: [
                  Expanded(
                    child: _buildColumn(
                      title: "Offres d'Emploi",
                      color: Colors.blue[800]!,
                      list: employmentOffers,
                      isInternship: false,
                      canAdd: canAdd,
                      myId: myId,
                      isAdmin: isAdmin
                    ),
                  ),

                  Container(width: 1, color: Colors.grey[300]),

                  Expanded(
                    child: _buildColumn(
                      title: "Offres de Stage",
                      color: Colors.orange[800]!,
                      list: internshipList,
                      isInternship: true,
                      canAdd: canAdd,
                      myId: myId,
                      isAdmin: isAdmin
                    ),
                  ),
                ],
              ),
          ),
        ],
      ),
    );
  }

  Widget _buildColumn({
    required String title,
    required Color color,
    required List<Map<String, dynamic>> list,
    required bool isInternship,
    required bool canAdd,
    required String myId,
    required bool isAdmin,
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
              ? const Center(child: Text("Aucune offre trouvée", style: TextStyle(color: Colors.grey)))
              : ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final offre = list[index];
                    print("DÉBUG OFFRE : $offre");
                    
                    String idAutorOffers = (offre['id_auteur'] ?? '').toString();
                    bool isMyOffers = (idAutorOffers == myId);
                    
                    bool canDelete = isMyOffers || isAdmin;

                    return Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      elevation: 2,
                      child: ListTile(
                        title: Text(offre['titre'] ?? 'Poste', style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("${offre['entreprise']} - ${offre['ville']}"),
                            if (offre['nom_auteur'] != null)
                              Text(
                                "Par: ${offre['prenom_auteur']} ${offre['nom_auteur']}",
                                style: TextStyle(fontSize: 10, color: Colors.grey[600], fontStyle: FontStyle.italic)
                              ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(5)),
                              child: Text(offre['type'] ?? '', style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.bold)),
                            ),
                            
                            if (canDelete) ...[
                              const SizedBox(width: 10),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                                onPressed: () => _deleteComfirm(offre['id_offre'].toString()),
                                tooltip: "Supprimer",
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
                label: Text(isInternship ? "Ajouter un Stage" : "Ajouter un Emploi"),
                onPressed: () => _addPopUp(isInternship, color),
              ),
            ),
          ),

        if (!canAdd)
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              "Réservé aux Alumnis",
              style: TextStyle(color: Colors.grey[400], fontSize: 10, fontStyle: FontStyle.italic),
            ),
          ),
      ],
    );
  }

  void _seeDetail(Map<String, dynamic> offre) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(offre['titre'] ?? ""),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("🏢 ${offre['entreprise']} à ${offre['ville']}", style: const TextStyle(fontWeight: FontWeight.bold)),
              const Divider(height: 30),
              const Text("Description :", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
              Text(offre['description'] ?? "Aucune description"),
              const SizedBox(height: 20),
              const Text("Contact :", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
              SelectableText(offre['contact_email'] ?? "", style: const TextStyle(color: Colors.blue)),
            ],
          ),
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("Fermer"))],
      ),
    );
  }

  void _addPopUp(bool isStage, Color couleur) {
    final controllerTitle = TextEditingController();
    final controllerCompany = TextEditingController();
    final controllerCity = TextEditingController();
    final controllerEmail = TextEditingController();
    final controllerDescription = TextEditingController();
    String typeSelect = isStage ? 'Stage' : 'CDI';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) {
          return AlertDialog(
            title: Text(isStage ? "Nouveau Stage" : "Nouvel Emploi"),
            content: SizedBox(
              width: 400,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(controller: controllerTitle, decoration: const InputDecoration(labelText: "Intitulé du poste")),
                    TextField(controller: controllerCompany, decoration: const InputDecoration(labelText: "Entreprise")),
                    TextField(controller: controllerCity, decoration: const InputDecoration(labelText: "Ville")),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: typeSelect,
                      items: (isStage ? ['Stage'] : ['CDI', 'CDD', 'Alternance', 'Freelance'])
                          .map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                      onChanged: (v) => setStateDialog(() => typeSelect = v!),
                      decoration: const InputDecoration(labelText: "Type"),
                    ),
                    TextField(controller: controllerEmail, decoration: const InputDecoration(labelText: "Email contact")),
                    TextField(controller: controllerDescription, decoration: const InputDecoration(labelText: "Description"), maxLines: 3),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text("Annuler")),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: couleur, foregroundColor: Colors.white),
                onPressed: () async { 
                  if (controllerTitle.text.isNotEmpty && controllerCompany.text.isNotEmpty) {
                    
                    String myId = widget.user['id'].toString();

                    bool success = await DatabaseService().addOffers({
                      "titre": controllerTitle.text,
                      "entreprise": controllerCompany.text,
                      "ville": controllerCity.text,
                      "type": typeSelect,
                      "contact_email": controllerEmail.text,
                      "description": controllerDescription.text,
                      "id_auteur": myId
                    });

                    if (success && mounted) {
                      Navigator.pop(context); 
                      _loadTrueOffers();
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Offre enregistrée !")));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Erreur : Impossible de contacter le serveur."),
                          backgroundColor: Colors.red,
                        )
                      );
                    }
                  }
                },
                child: const Text("Publier"),
              ),
            ],
          );
        },
      ),
    );
  }
}