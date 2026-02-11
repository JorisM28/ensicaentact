import 'package:flutter/material.dart';
import '../colors.dart';
import '../database_service.dart';

class PageActualites extends StatefulWidget {
  final Map<String, dynamic> user;
  const PageActualites({super.key, required this.user});

  @override
  State<PageActualites> createState() => _PageActualitesState();
}

class _PageActualitesState extends State<PageActualites> {
  List<Map<String, dynamic>> _actus = [];
  bool _isLoading = true;
  String _recherche = "";
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _chargerDonnees();
  }

  void _chargerDonnees() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    
    var dataActus = await DatabaseService().getActualites();    
    
    if (mounted) {
      setState(() {
        _actus = dataActus;
        _isLoading = false;
      });
    }
  }

  Color _parseColor(String? hex) {
    if (hex == null || !hex.startsWith('#')) return AppColors.ensiCyan;
    try {
      return Color(int.parse(hex.replaceFirst('#', '0xFF')));
    } catch (e) {
      return AppColors.ensiCyan;
    }
  }


  void _confirmerSuppression(BuildContext context, Map<String, dynamic> item) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("Supprimer l'actualité ?"),
          content: Text("Voulez-vous vraiment supprimer définitivement : \n\n\"${item['titre']}\" ?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx), 
              child: const Text("Annuler")
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(ctx); // Ferme la pop-up
                
        
                int idToDelete = int.parse(item['id_actu'].toString()); 
                // ---------------------

                // Appel BDD
                bool success = await DatabaseService().supprimerActualite(idToDelete);

                if (success) {
                  // Rafraîchir la liste locale
                  _chargerDonnees();
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Actualité supprimée avec succès."))
                    );
                  }
                } else {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Erreur lors de la suppression."))
                    );
                  }
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
    final actusFiltrees = _actus.where((a) => 
      (a['titre'] ?? '').toLowerCase().contains(_recherche.toLowerCase())).toList();

   
    bool estAdmin = widget.user['role'] == 'admin';

    return Scaffold(
      appBar: AppBar(
        title: const Text("Actualités du Réseau"),
        backgroundColor: AppColors.ensiCyan,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh), 
            onPressed: _chargerDonnees
          )
        ],
      ),

      floatingActionButton: estAdmin 
        ? FloatingActionButton(
            backgroundColor: AppColors.ensiCyan,
            tooltip: "Ajouter une actualité",
            child: const Icon(Icons.add, color: Colors.white),
            onPressed: () => _afficherDialogAjout(context),
          )
        : null,
      
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(
            child: _isLoading 
                ? const Center(child: CircularProgressIndicator())
                : _buildSectionActus(actusFiltrees, estAdmin), 
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() => Padding(
    padding: const EdgeInsets.all(10),
    child: TextField(
      controller: _searchCtrl,
      decoration: InputDecoration(
        labelText: "Rechercher une actualité...",
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      onChanged: (v) => setState(() => _recherche = v),
    ),
  );

  Widget _buildSectionActus(List<Map<String, dynamic>> liste, bool estAdmin) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          color: Colors.teal.withOpacity(0.1),
          child: const Text(
            "Fil d'actualités",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: liste.length,
            itemBuilder: (context, i) {
              final item = liste[i];
              final String? imageUrl = item['image_url'];

              return Card(
                margin: const EdgeInsets.only(bottom: 15),
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: InkWell(
                  onTap: () { 
                    Navigator.push(
                      context, 
                      MaterialPageRoute(
                        builder: (context) => DetailsPageSimple(item: item),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(10),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        // Barre de couleur (Tag)
                        Container(
                          width: 6,
                          height: 80, 
                          decoration: BoxDecoration(
                            color: _parseColor(item['tag_color']),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 15),
                        
                        // Image
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            width: 80, height: 80,
                            color: Colors.grey[200],
                            child: (imageUrl != null && imageUrl.isNotEmpty)
                                ? Image.network(imageUrl, fit: BoxFit.cover, 
                                    errorBuilder: (c,e,s) => const Icon(Icons.image))
                                : const Icon(Icons.image, size: 30, color: Colors.grey),
                          ),
                        ),
                        const SizedBox(width: 15),
                        
                        // Textes
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item['tag']?.toUpperCase() ?? "NEWS",
                                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, 
                                  color: _parseColor(item['tag_color']))),
                              const SizedBox(height: 5),
                              Text(item['titre'] ?? "",
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                  maxLines: 2, overflow: TextOverflow.ellipsis),
                              const SizedBox(height: 5),
                              Text("Par ${item['prenom_auteur'] ?? ''} ${item['nom_auteur'] ?? ''}",
                                  style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                            ],
                          ),
                        ),

                   
                        if (estAdmin)
                          IconButton(
                            icon: const Icon(Icons.delete_outline, color: Colors.red),
                            tooltip: "Supprimer",
                            onPressed: () => _confirmerSuppression(context, item),
                          ),
                        // -----------------------------------
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }


  void _afficherDialogAjout(BuildContext context) {
    final titleCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final imgCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Nouvelle Actualité"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: "Titre")),
            TextField(controller: descCtrl, decoration: const InputDecoration(labelText: "Description"), maxLines: 3),
            TextField(controller: imgCtrl, decoration: const InputDecoration(labelText: "URL Image (optionnel)")),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Annuler")),
          ElevatedButton(
            onPressed: () async {
              if (titleCtrl.text.isEmpty) return;

              await DatabaseService().ajouterActualite({
                "titre": titleCtrl.text,
                "description": descCtrl.text,
                "image": imgCtrl.text,
                "auteur_id": widget.user['id_user'] ?? "0",
              });

              Navigator.pop(ctx);
              _chargerDonnees();
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Actualité publiée !")));
              }
            },
            child: const Text("Publier"),
          ),
        ],
      ),
    );
  }
}


class DetailsPageSimple extends StatelessWidget {
  final Map<String, dynamic> item;
  const DetailsPageSimple({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final String title = item['titre'] ?? "Sans titre";
    final String content = item['contenu'] ?? "Pas de contenu";
    final String date = item['date_publi'] ?? "";
    final String author = "${item['prenom_auteur'] ?? ''} ${item['nom_auteur'] ?? ''}";
    final String? imageUrl = item['image_url'];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Détail de l'actualité"),
        backgroundColor: AppColors.ensiCyan,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (imageUrl != null && imageUrl.isNotEmpty)
              Image.network(
                imageUrl,
                width: double.infinity,
                height: 300,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 200,
                  color: Colors.grey[200],
                  child: const Icon(Icons.broken_image, size: 50),
                ),
              ),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Par $author",
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.blueGrey),
                  ),
                  Text(
                    "Publié le $date",
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const Divider(height: 40),
                  Text(
                    content,
                    style: const TextStyle(fontSize: 16, height: 1.6),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}