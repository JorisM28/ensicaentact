import 'package:flutter/material.dart';

class EventWidget extends StatelessWidget {
  const EventWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Données fictives basées sur ta capture
    final List<Map<String, String>> events = [
      {
        "title": "Stratégie De Recherche D'emploi (Méthode) - En Ligne",
        "category": "Carrières - Webinaire",
        "image": "assets/event1.jpg"
      },
      {
        "title": "Women Speed Networking",
        "category": "Rencontre",
        "image": "assets/event2.jpg"
      },
      {
        "title": "Un An Après : Quel Impact De L'administration Trump Sur La Politique...",
        "category": "Rencontre",
        "image": "assets/event3.jpg"
      },
      {
        "title": "Rencontre Des Alumni À Marseille",
        "category": "Soirée",
        "image": "assets/event4.jpg"
      },
      {
        "title": "ORLANDO, SALLY POTTER (1992)",
        "category": "Projection",
        "image": "assets/event5.jpg"
      },
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      color: Colors.white, // Fond blanc
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TITRE
          const Center( // Centré ou à gauche selon préférence (image semble alignée gauche mais titre global centré)
            child: Text(
              "ÉVÈNEMENTS",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w400,
                letterSpacing: 1.0,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: 30),

          // LISTE DES ÉVÉNEMENTS
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(), // Scroll géré par HomePage
            shrinkWrap: true,
            itemCount: events.length,
            itemBuilder: (context, index) {
              return _buildEventCard(events[index]);
            },
          ),

          const SizedBox(height: 10),

          // LIEN "VOIR TOUT" (Aligné à droite comme sur l'image)
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {},
              child: const Text(
                "Voir tout l'agenda",
                style: TextStyle(
                    color: Color(0xFFE30613),
                    fontSize: 16,
                    fontWeight: FontWeight.w500
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventCard(Map<String, String> event) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      height: 100, // Hauteur fixe pour uniformité
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300), // Bordure grise fine
        borderRadius: BorderRadius.circular(2),
        // Petite ombre optionnelle
        // boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 1))]
      ),
      child: Row(
        children: [
          // MINIATURE (GAUCHE)
          Container(
            width: 140, // Largeur de l'image
            color: Colors.grey[200],
            // child: Image.asset(event['image']!, fit: BoxFit.cover),
            child: const Icon(Icons.event, color: Colors.grey), // Placeholder
          ),

          // TEXTES (DROITE)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    event['title']!,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600, // Semi-bold
                      color: Color(0xFF333333),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    event['category']!,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}