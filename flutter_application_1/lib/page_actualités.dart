import 'package:flutter/material.dart';
import '../colors.dart';
import 'widget/custom_app_bar.dart';
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

  String? _getImageUrl(Map<String, dynamic> item) {
    if (item['image_url'] != null && item['image_url'].toString().isNotEmpty) {
      return item['image_url'];
    }
    if (item['image'] != null && item['image'].toString().isNotEmpty) {
      return item['image'];
    }
    return null;
  }

  Widget _buildImage(String? url, {double? width, double? height}) {
    if (url == null || url.isEmpty) {
      return Container(
        width: width ?? double.infinity,
        height: height ?? 200,
        color: Colors.grey[300],
        child: const Icon(Icons.newspaper, color: Colors.grey, size: 40),
      );
    }
    return Image.network(
      url,
      width: width,
      height: height,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => Container(
        width: width ?? double.infinity,
        height: height ?? 200,
        color: Colors.grey[300],
        child: const Icon(Icons.broken_image, color: Colors.grey, size: 40),
      ),
    );
  }

  void _confirmerSuppression(BuildContext context, Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Supprimer l'article ?"),
        content: Text("Voulez-vous vraiment supprimer définitivement : \n\n\"${item['titre']}\" ?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("Annuler")
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              int idToDelete = int.parse(item['id_actu'].toString());
              bool success = await DatabaseService().supprimerActualite(idToDelete);

              if (success) {
                _chargerDonnees();
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Article supprimé."))
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

  void _afficherDialogAjout(BuildContext context) {
    final titleCtrl = TextEditingController();
    final contentCtrl = TextEditingController(); // Renommé pour plus de clarté
    final imgCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Nouvel Article"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: "Titre")),
              const SizedBox(height: 10),
              TextField(
                  controller: contentCtrl,
                  decoration: const InputDecoration(
                      labelText: "Contenu de l'article",
                      alignLabelWithHint: true,
                      border: OutlineInputBorder()
                  ),
                  maxLines: 5
              ),
              const SizedBox(height: 10),
              TextField(controller: imgCtrl, decoration: const InputDecoration(labelText: "URL Image (optionnel)")),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Annuler")),
          ElevatedButton(
            onPressed: () async {
              if (titleCtrl.text.isEmpty) return;

              // Debug : Vérifier l'ID utilisateur
              print("👤 Auteur ID envoyé : ${widget.user['id_user']}");

              await DatabaseService().ajouterActualite({
                "titre": titleCtrl.text,
                "contenu": contentCtrl.text,
                "description": contentCtrl.text,
                "image": imgCtrl.text,
                "auteur_id": widget.user['id_user'] ?? "1", // Mettre "1" par défaut plutôt que "0" si "0" n'existe pas en DB
                "tag": "NEWS", // Ajout d'un tag par défaut si nécessaire
                "date_publi": DateTime.now().toIso8601String(), // Parfois le PHP attend la date venant du client
              });

              Navigator.pop(ctx);
              _chargerDonnees();
            },
            child: const Text("Publier"),
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
      backgroundColor: Colors.white,
      appBar: CustomAppBar(),
      floatingActionButton: estAdmin
          ? FloatingActionButton(
        backgroundColor: const Color(0xFF1A1A1A),
        child: const Icon(Icons.edit_note, color: Colors.white),
        onPressed: () => _afficherDialogAjout(context),
      )
          : null,
      body: Column(
        children: [
          if (_recherche.isNotEmpty || actusFiltrees.length != _actus.length)
            _buildSearchBar(),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: Colors.black))
                : _buildNewspaperFeed(actusFiltrees),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    child: TextField(
      controller: _searchCtrl,
      cursorColor: Colors.black,
      decoration: const InputDecoration(
        hintText: "Rechercher un article...",
        prefixIcon: Icon(Icons.search, color: Colors.black54),
        border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black12)),
        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
      ),
      onChanged: (v) => setState(() => _recherche = v),
    ),
  );

  Widget _buildHeroArticle(Map<String, dynamic> item, bool isMobile) {
    final imageUrl = _getImageUrl(item);
    final contentPreview = item['contenu'] ?? item['description'] ?? "Pas de description";

    Widget textPart = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                item['titre'] ?? "",
                style: const TextStyle(fontFamily: 'serif', fontSize: 32, fontWeight: FontWeight.w900, height: 1.1, color: Color(0xFF111111)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        Text(
          contentPreview,
          maxLines: 4,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 16, height: 1.5, color: Color(0xFF555555)),
        ),
      ],
    );

    Widget imagePart = _buildImage(imageUrl, height: isMobile ? 250 : 350);

    return InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DetailsPageNewspaper(item: item))),
      child: isMobile
          ? Column(children: [textPart, const SizedBox(height: 20), imagePart])
          : Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 5, child: textPart),
          const SizedBox(width: 30),
          Expanded(flex: 7, child: imagePart),
        ],
      ),
    );
  }

  Widget _buildSecondaryArticle(Map<String, dynamic> item, {bool isFullWidth = false, bool isMobile = false}) {
    final imageUrl = _getImageUrl(item);

    Widget content = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!isFullWidth && !isMobile) ...[
          _buildImage(imageUrl, width: 120, height: 90),
          const SizedBox(width: 15),
        ],
        Expanded(
          flex: isFullWidth ? 3 : 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      item['titre'] ?? "",
                      style: TextStyle(fontFamily: 'serif', fontSize: isFullWidth ? 24 : 18, fontWeight: FontWeight.w800, height: 1.2, color: const Color(0xFF202124)),
                    ),
                  ),
                ],
              ),
              if (isFullWidth || isMobile) ...[
                const SizedBox(height: 10),
                Text(
                  item['description'] ?? "",
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 14, color: Color(0xFF555555)),
                ),
              ]
            ],
          ),
        ),
        if (isFullWidth && !isMobile) ...[
          const SizedBox(width: 20),
          Expanded(flex: 2, child: _buildImage(imageUrl, height: 160)),
        ],
        if (isMobile) ...[
          const SizedBox(width: 15),
          _buildImage(imageUrl, width: 100, height: 80),
        ]
      ],
    );

    return InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DetailsPageNewspaper(item: item))),
      child: content,
    );
  }

  Widget _buildNewspaperFeed(List<Map<String, dynamic>> liste) {
    if (liste.isEmpty) {
      return const Center(child: Text("Aucun article.", style: TextStyle(fontFamily: 'serif', fontSize: 20)));
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        bool isMobile = constraints.maxWidth < 800;

        List<Widget> feedWidgets = [];

        feedWidgets.add(_buildHeroArticle(liste.first, isMobile));
        feedWidgets.add(const Padding(
          padding: EdgeInsets.symmetric(vertical: 25),
          child: Divider(color: Colors.black26, thickness: 1),
        ));

        List<Map<String, dynamic>> restants = liste.sublist(1);

        for (int i = 0; i < restants.length; i += 2) {
          if (isMobile) {
            feedWidgets.add(_buildSecondaryArticle(restants[i], isFullWidth: true, isMobile: true));
            if (i + 1 < restants.length) {
              feedWidgets.add(const Padding(padding: EdgeInsets.symmetric(vertical: 15), child: Divider(color: Colors.black12)));
              feedWidgets.add(_buildSecondaryArticle(restants[i + 1], isFullWidth: true, isMobile: true));
            }
          } else {
            if (i + 1 < restants.length) {
              feedWidgets.add(
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _buildSecondaryArticle(restants[i])),
                      const SizedBox(width: 30),
                      Expanded(child: _buildSecondaryArticle(restants[i + 1])),
                    ],
                  )
              );
            } else {
              feedWidgets.add(_buildSecondaryArticle(restants[i], isFullWidth: true));
            }
          }

          if (i + 2 < restants.length || (i + 1 < restants.length && isMobile)) {
            feedWidgets.add(const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Divider(color: Colors.black12, thickness: 1),
            ));
          }
        }

        return SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1000),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: feedWidgets,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class DetailsPageNewspaper extends StatelessWidget {
  final Map<String, dynamic> item;
  const DetailsPageNewspaper({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final String title = item['titre'] ?? "Sans titre";
    final String content = item['contenu'] ?? item['description'] ?? "Pas de contenu";
    final String date = item['date_publi'] ?? "";
    final String author = "${item['prenom_auteur'] ?? ''} ${item['nom_auteur'] ?? ''}";

    String? imageUrl;
    if (item['image_url'] != null && item['image_url'].toString().isNotEmpty) imageUrl = item['image_url'];
    else if (item['image'] != null && item['image'].toString().isNotEmpty) imageUrl = item['image'];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        actions: [
          IconButton(icon: const Icon(Icons.share, color: Colors.black), onPressed: (){})
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  (item['tag'] ?? "ACTUALITÉ").toUpperCase(),
                  style: const TextStyle(color: Color(0xFFC00), fontWeight: FontWeight.bold, fontSize: 12),
                ),
                const SizedBox(height: 10),
                Text(
                  title,
                  style: const TextStyle(fontFamily: 'serif', fontSize: 32, fontWeight: FontWeight.w900, height: 1.1, color: Color(0xFF202124)),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Text("Par $author", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
                    const SizedBox(width: 10),
                    if (date.isNotEmpty) Text("•  Publié le $date", style: const TextStyle(color: Colors.grey)),
                  ],
                ),
                const SizedBox(height: 25),

                if (imageUrl == null || imageUrl.isEmpty)
                  Container(
                    width: double.infinity,
                    height: 300,
                    color: Colors.grey[300],
                    child: const Icon(Icons.newspaper, color: Colors.grey, size: 50),
                  )
                else ...[
                  Image.network(imageUrl, width: double.infinity, fit: BoxFit.cover),
                  const SizedBox(height: 5),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text("Crédit: DR", style: TextStyle(fontSize: 10, color: Colors.grey[600])),
                  ),
                ],

                const SizedBox(height: 30),
                Text(
                  content,
                  style: const TextStyle(fontSize: 18, height: 1.6, color: Color(0xFF222222)),
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }
}