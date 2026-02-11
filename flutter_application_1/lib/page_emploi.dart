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
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Offre supprimée.")));
              }
            },
            child: const Text("Supprimer", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _ouvrirFormulaire({Map<String, dynamic>? offreExistante, required bool isStage, required Color couleur}) {
    final bool estModification = offreExistante != null;

    final titreCtrl = TextEditingController(text: estModification ? offreExistante['titre'] : "");
    final entCtrl = TextEditingController(text: estModification ? offreExistante['entreprise'] : "");
    final villeCtrl = TextEditingController(text: estModification ? offreExistante['ville'] : "");
    final emailCtrl = TextEditingController(text: estModification ? offreExistante['contact_email'] : "");
    final descCtrl = TextEditingController(text: estModification ? offreExistante['description'] : "");
    
    // Type par défaut
    String typeSelect = estModification ? (offreExistante['type'] ?? 'CDI') : (isStage ? 'Stage' : 'CDI');
    
    final List<String> typesPossibles = isStage 
        ? ['Stage'] 
        : ['CDI', 'CDD', 'Alternance', 'Freelance', 'Intérim'];

    if (!typesPossibles.contains(typeSelect)) {
      typeSelect = typesPossibles.first;
    }

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) {
          return AlertDialog(
            title: Text(estModification ? "Modifier l'offre" : (isStage ? "Nouveau Stage" : "Nouvel Emploi")),
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
                      items: typesPossibles.map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
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
                style: ElevatedButton.styleFrom(backgroundColor: couleur, foregroundColor: Colors.white),
                onPressed: () async { 
                  if (titreCtrl.text.isNotEmpty && entCtrl.text.isNotEmpty) {
                    
                    String monId = (widget.user['id_user'] ?? widget.user['id']).toString();

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
                    if (estModification) {
                      dataToSend["id_offre"] = offreExistante['id_offre'].toString();
                      success = await DatabaseService().modifierOffre(dataToSend);
                    } else {
                      success = await DatabaseService().ajouterOffre(dataToSend);
                    }

                    if (success && mounted) {
                      Navigator.pop(context); 
                      _chargerLesVraiesOffres();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(estModification ? "Offre modifiée !" : "Offre publiée !"))
                      );
                    } else {
                       ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Erreur serveur"), backgroundColor: Colors.red)
                      );
                    }
                  }
                },
                child: Text(estModification ? "Enregistrer" : "Publier"),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String role = widget.user['role'] ?? 'guest';
    

    String monId = (widget.user['id_user'] ?? widget.user['id'] ?? '0').toString();
    
    bool isAdmin = (role == 'admin');
    bool estAlumni = (role == 'alumni');
    bool peutAjouter = (isAdmin || estAlumni);

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
          IconButton(icon: const Icon(Icons.refresh), onPressed: _chargerLesVraiesOffres)
        ],
      ),
      body: Column(
        children: [
          // Barre de recherche
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: _searchCtrl,
              decoration: InputDecoration(
                labelText: "Rechercher (Poste, Entreprise...)",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                suffixIcon: _recherche.isNotEmpty 
                  ? IconButton(icon: const Icon(Icons.clear), onPressed: () => setState(() { _searchCtrl.clear(); _recherche = ""; })) 
                  : null,
              ),
              onChanged: (val) => setState(() => _recherche = val),
            ),
          ),

          // Colonnes Stages / Emplois
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
                      monId: monId, // On passe l'ID connecté
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
                      monId: monId, // On passe l'ID connecté
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
        // En-tête colonne
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

        // Liste des offres
        Expanded(
          child: liste.isEmpty
              ? const Center(child: Text("Aucune offre trouvée", style: TextStyle(color: Colors.grey)))
              : ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: liste.length,
                  itemBuilder: (context, index) {
                    final offre = liste[index];
                    
                   
                    String idAuteurOffre = (offre['id_auteur'] ?? '').toString();
                    
               
                    bool estMonOffre = (idAuteurOffre == monId);
                    
                
                    bool aLeDroit = isAdmin || estMonOffre;

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
                        onTap: () => _voirDetail(offre),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                             if (!aLeDroit)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(color: couleur.withOpacity(0.1), borderRadius: BorderRadius.circular(5)),
                                child: Text(offre['type'] ?? '', style: TextStyle(fontSize: 10, color: couleur, fontWeight: FontWeight.bold)),
                              ),

                            // --- BOUTONS VISIBLES UNIQUEMENT SI C'EST MON OFFRE OU SI JE SUIS ADMIN ---
                            if (aLeDroit) ...[
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.blue, size: 20),
                                onPressed: () => _ouvrirFormulaire(offreExistante: offre, isStage: isStage, couleur: couleur),
                                tooltip: "Modifier",
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                                onPressed: () => _confirmerSuppression(offre['id_offre'].toString()),
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

        // Bouton Ajouter en bas
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
                onPressed: () => _ouvrirFormulaire(isStage: isStage, couleur: couleur),
              ),
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