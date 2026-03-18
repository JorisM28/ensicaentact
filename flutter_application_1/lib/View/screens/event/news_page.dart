import 'package:flutter/material.dart';
import '/Model/data/services/alumni_repository.dart';
import '/service_locator.dart';
import '/Model/data/services/auth_service.dart';
import '/l10n/app_localizations.dart';
import '/View/widget/base_layout.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  List<Map<String, dynamic>> _news = [];
  bool _isLoading = true;
  String _search = "";
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    var dataNews = await sl<AlumniRepository>().getNews();

    if (mounted) {
      setState(() {
        _news = dataNews;
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

  void _confirmDeletion(BuildContext context, Map<String, dynamic> item) {
    final traductions = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(traductions.deleteArticleTitle),
        content: Text("${traductions.deleteArticleContent}\"${item['titre']}\" ?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(traductions.cancel)
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              int idToDelete = int.parse(item['id_actu'].toString());
              bool success = await sl<AlumniRepository>().deleteNews(idToDelete);

              if (success) {
                _loadData();
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(traductions.articleDeletedSuccess))
                  );
                }
              }
            },
            child: Text(traductions.deleteBtn, style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    final traductions = AppLocalizations.of(context)!;
    final titleCtrl = TextEditingController();
    final contentCtrl = TextEditingController();
    final imgCtrl = TextEditingController();
    final currentUser = sl<AuthService>().currentUser;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(traductions.newArticle),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: titleCtrl, decoration: InputDecoration(labelText: traductions.dialogTitleLabel)),
              const SizedBox(height: 10),
              TextField(
                  controller: contentCtrl,
                  decoration: InputDecoration(
                      labelText: traductions.articleContentLabel,
                      alignLabelWithHint: true,
                      border: OutlineInputBorder()
                  ),
                  maxLines: 5
              ),
              const SizedBox(height: 10),
              TextField(controller: imgCtrl, decoration: InputDecoration(labelText: traductions.dialogImageUrlLabel)),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(traductions.cancel)),
          ElevatedButton(
            onPressed: () async {
              if (titleCtrl.text.isEmpty) return;


              print("👤 Auteur ID envoyé : ${currentUser?.id}");

              await sl<AlumniRepository>().addNews({
                "titre": titleCtrl.text,
                "contenu": contentCtrl.text,
                "description": contentCtrl.text,
                "image": imgCtrl.text,
                "auteur_id": currentUser?.id ?? "1",
                "tag": "NEWS",
                "date_publi": DateTime.now().toIso8601String(),
              });

              Navigator.pop(ctx);
              _loadData();
            },
            child: Text(traductions.publish),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = sl<AuthService>().currentUser;
    final actusFiltrees = _news.where((a) =>
        (a['titre'] ?? '').toLowerCase().contains(_search.toLowerCase())).toList();
    bool isAdmin = currentUser?.role == 'admin';

    return BaseLayout(
      backgroundColor: Colors.white, 
          floatingActionButton: isAdmin
          ? FloatingActionButton(
              backgroundColor: const Color(0xFF1A1A1A),
              child: const Icon(Icons.edit_note, color: Colors.white),
              onPressed: () => _showAddDialog(context),
            )
          : null,
      body: Column(
        children: [
          if (_search.isNotEmpty || actusFiltrees.length != _news.length)
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

    Widget _buildSearchBar() {
    final traductions = AppLocalizations.of(context)!; 
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextField(
        controller: _searchCtrl,
        cursorColor: Colors.black,
        decoration: InputDecoration( 
          hintText: traductions.searchArticle, 
          prefixIcon: const Icon(Icons.search, color: Colors.black54), 
          border: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.black12)), 
          focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)), 
        ),
        onChanged: (v) => setState(() => _search = v),
      ),
    );
  }

  Widget _buildHeroArticle(Map<String, dynamic> item, bool isMobile) {
    final imageUrl = _getImageUrl(item);
    final contentPreview = item['contenu'] ?? item['description'] ?? AppLocalizations.of(context)!.noDescription;

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
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => NewspaperDetailsPage(item: item))),
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
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => NewspaperDetailsPage(item: item))),
      child: content,
    );
  }

  Widget _buildNewspaperFeed(List<Map<String, dynamic>> liste) {
    if (liste.isEmpty) {
      return Center(child: Text(AppLocalizations.of(context)!.noArticle, style: TextStyle(fontFamily: 'serif', fontSize: 20)));
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

        List<Map<String, dynamic>> remaining = liste.sublist(1);

        for (int i = 0; i < remaining.length; i += 2) {
          if (isMobile) {
            feedWidgets.add(_buildSecondaryArticle(remaining[i], isFullWidth: true, isMobile: true));
            if (i + 1 < remaining.length) {
              feedWidgets.add(const Padding(padding: EdgeInsets.symmetric(vertical: 15), child: Divider(color: Colors.black12)));
              feedWidgets.add(_buildSecondaryArticle(remaining[i + 1], isFullWidth: true, isMobile: true));
            }
          } else {
            if (i + 1 < remaining.length) {
              feedWidgets.add(
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _buildSecondaryArticle(remaining[i])),
                      const SizedBox(width: 30),
                      Expanded(child: _buildSecondaryArticle(remaining[i + 1])),
                    ],
                  )
              );
            } else {
              feedWidgets.add(_buildSecondaryArticle(remaining[i], isFullWidth: true));
            }
          }

          if (i + 2 < remaining.length || (i + 1 < remaining.length && isMobile)) {
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

class NewspaperDetailsPage extends StatelessWidget {
  final Map<String, dynamic> item;
  const NewspaperDetailsPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final traductions = AppLocalizations.of(context)!;
    final String title = item['titre'] ?? traductions.untitled;
    final String content = item['contenu'] ?? item['description'] ?? traductions.noDescription;
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
                  (item['tag'] ?? traductions.defaultTagNews).toUpperCase(),
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
                    Text("${traductions.byAuthor}$author", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)), 
                    const SizedBox(width: 10),
                    if (date.isNotEmpty) Text("${traductions.publishedOn}$date", style: const TextStyle(color: Colors.grey)), 
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
                    child: Text(traductions.creditDR, style: TextStyle(fontSize: 10, color: Colors.grey[600])),
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