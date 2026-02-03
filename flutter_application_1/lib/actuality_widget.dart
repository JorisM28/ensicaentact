import 'package:flutter/material.dart';

class ActualityWidget extends StatelessWidget {
  const ActualityWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Données fictives pour l'exemple (basées sur ta capture)
    final List<Map<String, dynamic>> newsItems = [
      {
        "image": "assets/news1.jpg", // Remplace par tes vraies images
        "title": "On rembobine : récap du mois de janvier !",
        "tag": "Actualités",
        "tagColor": const Color(0xFF67CBB8), // Le vert/cyan de la capture
      },
      {
        "image": "assets/news2.jpg",
        "title": "Belle rencontre avec Anne Béatrice Schlumberger à l'occasion des voeux",
        "tag": "L'Association",
        "tagColor": const Color(0xFFE30613), // Le rouge Sciences Po
      },
      {
        "image": "assets/news3.jpg",
        "title": "Palmarès Le Figaro : découvrez les 37 Alumni de Sciences Po parmi...",
        "tag": "Actualités",
        "tagColor": const Color(0xFF67CBB8),
      },
      {
        "image": "assets/news4.jpg",
        "title": "Les Sciences Po dans la cybersécurité",
        "tag": "Actualités",
        "tagColor": const Color(0xFF67CBB8),
      },
    ];

    double screenWidth = MediaQuery.of(context).size.width;
    // Sur grand écran, on met 2 colonnes (grid), sur mobile 1 seule
    int crossAxisCount = screenWidth > 800 ? 2 : 1;
    // Ratio pour ajuster la hauteur des cartes (plus l'écran est large, plus la carte doit être haute proportionnellement)
    double childAspectRatio = screenWidth > 800 ? 1.4 : 1.1;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      color: Colors.white,
      child: Column(
        children: [
          // TITRE DE LA SECTION
          const Text(
            "ACTUALITÉS",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w400, // Police un peu fine comme sur le site
              letterSpacing: 1.0,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 30),

          // GRILLE DES ACTUALITÉS
          GridView.builder(
            physics: const NeverScrollableScrollPhysics(), // Important pour scroller avec la HomePage
            shrinkWrap: true,
            itemCount: newsItems.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              childAspectRatio: childAspectRatio,
            ),
            itemBuilder: (context, index) {
              return _buildNewsCard(newsItems[index]);
            },
          ),

          const SizedBox(height: 30),

          // BOUTON VOIR TOUTES LES ACTUALITÉS
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFFE30613)), // Bordure rouge
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)), // Bord carré
            ),
            child: const Text(
              "Voir toutes les actualités",
              style: TextStyle(color: Color(0xFFE30613), fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewsCard(Map<String, dynamic> item) {
    return Card(
      elevation: 4, // Ombre portée comme sur l'image
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // IMAGE + TAG
          Expanded(
            flex: 3, // L'image prend 3/4 de la hauteur
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Placeholder d'image (ou NetworkImage)
                Container(
                  color: Colors.grey[300], // Gris si pas d'image
                  child: const Icon(Icons.image, size: 50, color: Colors.grey),
                  // Pour mettre une vraie image :
                  // child: Image.asset(item['image'], fit: BoxFit.cover),
                ),
                // Le Tag coloré en haut à droite
                Positioned(
                  top: 15,
                  right: 15,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: item['tagColor'],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      item['tag'],
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // TITRE
          Expanded(
            flex: 2, // Le texte prend le reste
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  item['title'],
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
    );
  }
}