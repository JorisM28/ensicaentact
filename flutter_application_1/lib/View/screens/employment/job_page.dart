import 'package:flutter/material.dart';
import 'package:flutter_application_ensicaentact/Model/user_model.dart';
import '/Model/data/services/alumni_repository.dart';
import '/service_locator.dart';
import '../../theme/colors.dart';

class JobPage extends StatefulWidget {
  final User user;

  const JobPage({super.key, required this.user});

  @override
  State<JobPage> createState() => _JobPageState();
}

class _JobPageState extends State<JobPage> {
  
  List<Map<String, dynamic>> _everyOffer = [];
  bool _isLoading = true;

  String _search = "";
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadRealOffers();
  }

  void _loadRealOffers() async {
    setState(() => _isLoading = true);
    var data = await sl<AlumniRepository>().getOffers();
    if (mounted) {
      setState(() {
        _everyOffer = data;
        _isLoading = false;
      });
    }
  }

  void _confirmDeletion(String idOffre) {
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
              bool success = await sl<AlumniRepository>().deleteOffer(idOffre);
              if (success) {
                _loadRealOffers();
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Offre supprimée.")));
              }
            },
            child: const Text("Supprimer", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _ouvrirFormulaire({Map<String, dynamic>? existingOffer, required bool isInternship, required Color color}) {
    final bool isEditing = existingOffer != null;

    final titreCtrl = TextEditingController(text: isEditing ? existingOffer['titre'] : "");
    final entCtrl = TextEditingController(text: isEditing ? existingOffer['entreprise'] : "");
    final villeCtrl = TextEditingController(text: isEditing ? existingOffer['ville'] : "");
    final emailCtrl = TextEditingController(text: isEditing ? existingOffer['contact_email'] : "");
    final descCtrl = TextEditingController(text: isEditing ? existingOffer['description'] : "");
    
    
    String typeSelect = isEditing ? (existingOffer['type'] ?? 'CDI') : (isInternship ? 'Stage' : 'CDI');
    
    final List<String> possibleTypes = isInternship 
        ? ['Stage'] 
        : ['CDI', 'CDD', 'Alternance', 'Freelance', 'Intérim'];

    if (!possibleTypes.contains(typeSelect)) {
      typeSelect = possibleTypes.first;
    }

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) {
          return AlertDialog(
            title: Text(isEditing ? "Modifier l'offre" : (isInternship ? "Nouveau Stage" : "Nouvel Emploi")),
            content: SizedBox(
              width: 400,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(controller: titreCtrl, decoration: const InputDecoration(labelText: "Intitulé du poste")),
                    TextField(controller: entCtrl, decoration: const InputDecoration(labelText: "Entreprise")),
                    TextField(controller: villeCtrl, decoration: const InputDecoration(labelText: "Ville")),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: typeSelect,
                      items: possibleTypes.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                      onChanged: (v) => setStateDialog(() => typeSelect = v!),
                      decoration: const InputDecoration(labelText: "Type"),
                    ),
                    TextField(controller: emailCtrl, decoration: const InputDecoration(labelText: "Email contact")),
                    TextField(controller: descCtrl, decoration: const InputDecoration(labelText: "Description"), maxLines: 4),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text("Annuler")),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: color, foregroundColor: Colors.white),
                onPressed: () async { 
                  if (titreCtrl.text.isNotEmpty && entCtrl.text.isNotEmpty) {
                    
                    String monId = (widget.user.id).toString();

                    final Map<String, dynamic> dataToSend = {
                      "titre": titreCtrl.text,
                      "entreprise": entCtrl.text,
                      "ville": villeCtrl.text,
                      "type": typeSelect,
                      "contact_email": emailCtrl.text,
                      "description": descCtrl.text,
                      "id_auteur": monId
                    };

                    bool success;
                    if (isEditing) {
                      dataToSend["id_offre"] = existingOffer['id_offre'].toString();
                      success = await sl<AlumniRepository>().addOffer(dataToSend);
                    } else {
                      success = await sl<AlumniRepository>().updateOffer(dataToSend);
                    }

                    if (success && mounted) {
                      Navigator.pop(context); 
                      _loadRealOffers();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(isEditing ? "Offre modifiée !" : "Offre publiée !"))
                      );
                    } else {
                       ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Erreur serveur"), backgroundColor: Colors.red)
                      );
                    }
                  }
                },
                child: Text(isEditing ? "Enregistrer" : "Publier"),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String role = widget.user.role;
    

    String myId = (widget.user.id).toString();
    
    bool isAdmin = (role == 'admin');
    bool isAlumni = (role == 'alumni');
    bool canAdd = (isAdmin || isAlumni);

    final filteredOffers = _everyOffer.where((o) {
      final titre = (o['titre'] ?? '').toLowerCase();
      final companies = (o['entreprise'] ?? '').toLowerCase();
      final keyWord = _search.toLowerCase();
      return titre.contains(keyWord) || companies.contains(keyWord);
    }).toList();

    final internshipList = filteredOffers.where((o) => (o['type'] ?? '').toLowerCase() == 'stage').toList();
    final jobList = filteredOffers.where((o) => (o['type'] ?? '').toLowerCase() != 'stage').toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Carrières & Stages"),
        backgroundColor: AppColors.ensiCyan,
        foregroundColor: Colors.white,
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadRealOffers)
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
                  ? IconButton(icon: const Icon(Icons.clear), onPressed: () => setState(() { _searchCtrl.clear(); _search = ""; })) 
                  : null,
              ),
              onChanged: (val) => setState(() => _search = val),
            ),
          ),

          
          Expanded(
            child: _isLoading 
            ? const Center(child: CircularProgressIndicator())
            : Row(
                children: [
                  Expanded(
                    child: _buildColonne(
                      titre: "Offres d'Emploi",
                      couleur: Colors.blue[800]!,
                      liste: jobList,
                      isStage: false,
                      canAdd: canAdd,
                      monId: myId, 
                      isAdmin: isAdmin
                    ),
                  ),
                  Container(width: 1, color: Colors.grey[300]),
                  Expanded(
                    child: _buildColonne(
                      titre: "Offres de Stage",
                      couleur: Colors.orange[800]!,
                      liste: internshipList,
                      isStage: true,
                      canAdd: canAdd,
                      monId: myId, 
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

  Widget _buildColonne({
    required String titre,
    required Color couleur,
    required List<Map<String, dynamic>> liste,
    required bool isStage,
    required bool canAdd,
    required String monId,
    required bool isAdmin,
  }) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(15),
          color: couleur.withOpacity(0.1),
          child: Text(
            titre,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: couleur),
          ),
        ),

        Expanded(
          child: liste.isEmpty
              ? const Center(child: Text("Aucune offre trouvée", style: TextStyle(color: Colors.grey)))
              : ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: liste.length,
                  itemBuilder: (context, index) {
                    final offre = liste[index];
                    
                   
                    String idOfferAuthor = (offre['id_auteur'] ?? '').toString();
                    
               
                    bool isMyOffer = (idOfferAuthor == monId);
                    
                
                    bool can = isAdmin || isMyOffer;

                    return Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      elevation: 2,
                      child: ListTile(
                        title: Text(offre['titre'] ?? 'Poste', style: const TextStyle(fontWeight: FontWeight.bold), maxLines: 2, overflow: TextOverflow.ellipsis),
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
                        onTap: () => _seeDetail(offre),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                             if (!can)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(color: couleur.withOpacity(0.1), borderRadius: BorderRadius.circular(5)),
                                child: Text(offre['type'] ?? '', style: TextStyle(fontSize: 10, color: couleur, fontWeight: FontWeight.bold)),
                              ),

                            
                            if (can) ...[
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.blue, size: 20),
                                onPressed: () => _ouvrirFormulaire(existingOffer: offre, isInternship: isStage, color: couleur),
                                tooltip: "Modifier",
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                                onPressed: () => _confirmDeletion(offre['id_offre'].toString()),
                                tooltip: "Supprimer",
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
                  backgroundColor: couleur, 
                  foregroundColor: Colors.white, 
                  padding: const EdgeInsets.all(15)
                ),
                icon: const Icon(Icons.add),
                label: Text(isStage ? "Ajouter un Stage" : "Ajouter un Emploi"),
                onPressed: () => _ouvrirFormulaire(isInternship: isStage, color: couleur),
              ),
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
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(5)),
                child: Text("Type : ${offre['type']}"),
              ),
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
}