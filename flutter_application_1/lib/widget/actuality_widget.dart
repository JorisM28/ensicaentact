import 'package:flutter/material.dart';
import 'package:flutter_application_ensicaentact/page_actualit%C3%A9s.dart';
import '../database_service.dart'; 

class ActualityWidget extends StatelessWidget {
  final Map<String, dynamic> user;

  const ActualityWidget({super.key, required this.user}); 

  Color _parseColor(String? hexString) {
    if (hexString == null || hexString.isEmpty) return const Color(0xFF67CBB8);
    try {
      final buffer = StringBuffer();
      if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
      buffer.write(hexString.replaceFirst('#', ''));
      return Color(int.parse(buffer.toString(), radix: 16));
    } catch (e) {
      return const Color(0xFF67CBB8); 
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = screenWidth > 800 ? 2 : 1;
    double childAspectRatio = screenWidth > 800 ? 1.4 : 1.1;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      color: Colors.white,
      child: Column(
        children: [
          const Text(
            "ACTUALITÉS",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w400,
              letterSpacing: 1.0,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 30),

          FutureBuilder<List<Map<String, dynamic>>>(
            future: DatabaseService().getActualites(), 
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text("Aucune actualité disponible pour le moment."),
                );
              }

              final newsItems = snapshot.data!;

              return GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: newsItems.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  childAspectRatio: childAspectRatio,
                ),
                itemBuilder: (context, index) {
                  return _buildNewsCard(newsItems[index], context);
                },
              );
            },
          ),

          const SizedBox(height: 30),

          // Bouton pour voir toutes les actualités
          OutlinedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PageActualites(user: user),
                ),
              );
            },
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFFE30613)),
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
            ),
            child: const Text(
              "Voir toutes les actualités",
              style: TextStyle(color: Color(0xFFE30613), fontSize: 16),
            ),
          ),
        ], // Fin des enfants de Column
      ), // Fin de Column
    ); // Fin de Container
  }

  Widget _buildNewsCard(Map<String, dynamic> item, BuildContext context) {
    final String title = item['titre'] ?? "Sans titre";
    final String tag = item['tag'] ?? "Actualités";
    final Color tagColor = _parseColor(item['tag_color']); 
    final String? imageUrl = item['image_url'];

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailsPageSimple(item: item),
          ),
        );
      },
      child: Card(
        elevation: 4,
        shadowColor: Colors.black26,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    color: Colors.grey[300],
                    child: (imageUrl != null && imageUrl.isNotEmpty)
                        ? Image.network(imageUrl, fit: BoxFit.cover)
                        : const Icon(Icons.image, size: 50, color: Colors.grey),
                  ),
                  Positioned(
                    top: 15,
                    right: 15,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: tagColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        tag,
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333),
                      height: 1.3,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}