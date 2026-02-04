import 'package:flutter/material.dart';
import 'colors.dart';
import 'database_service.dart';

class PageEmploi extends StatefulWidget {
  final Map<String, dynamic> user;

  const PageEmploi({super.key, required this.user});

  @override
  State<PageEmploi> createState() => _PageEmploiState();
}

class _PageEmploiState extends State<PageEmploi> {
  
  List<Map<String, dynamic>> _toutesLesOffres = [];
  bool _isLoading = true;

  String _recherche = "";
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _chargerLesVraiesOffres();
  }

  void _chargerLesVraiesOffres() async {
    setState(() => _isLoading = true);
    
    var data = await DatabaseService().getOffres();
    
    if (mounted) {
      setState(() {
        _toutesLesOffres = data;
        _isLoading = false;
      });
    }
  }

  void _confirmerSuppression(String idOffre) {
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
              
              bool success = await DatabaseService().supprimerOffre(idOffre);
              
              if (success) {
                _chargerLesVraiesOffres();
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
    String monId = widget.user['id'].toString();
    bool isAdmin = (role == 'admin');
    bool peutAjouter = (isAdmin || role == 'alumni');

    final offresFiltrees = _toutesLesOffres.where((o) {
      final titre = (o['titre'] ?? '').toLowerCase();
      final entreprise = (o['entreprise'] ?? '').toLowerCase();
      final motCle = _recherche.toLowerCase();
            return titre.contains(motCle) || entreprise.contains(motCle);
    }).toList();

    final listeStages = offresFiltrees.where((o) => (o['type'] ?? '').toLowerCase() == 'stage').toList();
    final listeEmplois = offresFiltrees.where((o) => (o['type'] ?? '').toLowerCase() != 'stage').toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Carrières & Stages"),
        backgroundColor: AppColors.ensiCyan,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh), 
            onPressed: _chargerLesVraiesOffres
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
                suffixIcon: _recherche.isNotEmpty 
                  ? IconButton(
                      icon: const Icon(Icons.clear), 
                      onPressed: () {
                        setState(() {
                          _searchCtrl.clear();
                          _recherche = "";
                        });
                      },
                    ) 
                  : null,
              ),
              onChanged: (val) {
                setState(() {
                  _recherche = val;
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
                    child: _buildColonne(
                      titre: "Offres d'Emploi",
                      couleur: Colors.blue[800]!,
                      liste: listeEmplois,
                      isStage: false,
                      peutAjouter: peutAjouter,
                      monId: monId,
                      isAdmin: isAdmin
                    ),
                  ),

                  Container(width: 1, color: Colors.grey[300]),

                  Expanded(
                    child: _buildColonne(
                      titre: "Offres de Stage",
                      couleur: Colors.orange[800]!,
                      liste: listeStages,
                      isStage: true,
                      peutAjouter: peutAjouter,
                      monId: monId,
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
    required bool peutAjouter,
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
                    print("DÉBUG OFFRE : $offre");
                    
                    String idAuteurOffre = (offre['id_auteur'] ?? '').toString();
                    bool estMonOffre = (idAuteurOffre == monId);
                    
                    bool droitSupprimer = estMonOffre || isAdmin;

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
                              decoration: BoxDecoration(color: couleur.withOpacity(0.1), borderRadius: BorderRadius.circular(5)),
                              child: Text(offre['type'] ?? '', style: TextStyle(fontSize: 12, color: couleur, fontWeight: FontWeight.bold)),
                            ),
                            
                            if (droitSupprimer) ...[
                              const SizedBox(width: 10),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                                onPressed: () => _confirmerSuppression(offre['id_offre'].toString()),
                                tooltip: "Supprimer",
                              ),
                            ]
                          ],
                        ),
                        onTap: () => _voirDetail(offre),
                      ),
                    );
                  },
                ),
        ),

        if (peutAjouter)
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
                onPressed: () => _popupAjouter(isStage, couleur),
              ),
            ),
          ),

        if (!peutAjouter)
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

  void _voirDetail(Map<String, dynamic> offre) {
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

  void _popupAjouter(bool isStage, Color couleur) {
    final titreCtrl = TextEditingController();
    final entCtrl = TextEditingController();
    final villeCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    final descCtrl = TextEditingController();
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
                    TextField(controller: titreCtrl, decoration: const InputDecoration(labelText: "Intitulé du poste")),
                    TextField(controller: entCtrl, decoration: const InputDecoration(labelText: "Entreprise")),
                    TextField(controller: villeCtrl, decoration: const InputDecoration(labelText: "Ville")),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: typeSelect,
                      items: (isStage ? ['Stage'] : ['CDI', 'CDD', 'Alternance', 'Freelance'])
                          .map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
                      onChanged: (v) => setStateDialog(() => typeSelect = v!),
                      decoration: const InputDecoration(labelText: "Type"),
                    ),
                    TextField(controller: emailCtrl, decoration: const InputDecoration(labelText: "Email contact")),
                    TextField(controller: descCtrl, decoration: const InputDecoration(labelText: "Description"), maxLines: 3),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text("Annuler")),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: couleur, foregroundColor: Colors.white),
                onPressed: () async { 
                  if (titreCtrl.text.isNotEmpty && entCtrl.text.isNotEmpty) {
                    
                    String monId = widget.user['id'].toString();

                    bool success = await DatabaseService().ajouterOffre({
                      "titre": titreCtrl.text,
                      "entreprise": entCtrl.text,
                      "ville": villeCtrl.text,
                      "type": typeSelect,
                      "contact_email": emailCtrl.text,
                      "description": descCtrl.text,
                      "id_auteur": monId
                    });

                    if (success && mounted) {
                      Navigator.pop(context); 
                      _chargerLesVraiesOffres();
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