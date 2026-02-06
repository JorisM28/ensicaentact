import 'package:flutter/material.dart';

class KeyFiguresWidget extends StatelessWidget {
  const KeyFiguresWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> stats = [
      {
        "value": 8000,
        "suffix": "+",
        "label": "DIPLÔMÉS",
        "icon": Icons.school,
        "color": const Color(0xFFE30613),
      },
      {
        "value": 45,
        "suffix": "",
        "label": "PAYS REPRÉSENTÉS",
        "icon": Icons.public,
        "color": Colors.blue[700],
      },
      {
        "value": 150,
        "suffix": "+",
        "label": "ÉVÉNEMENTS / AN",
        "icon": Icons.event_available,
        "color": Colors.orange[800],
      },
      {
        "value": 300,
        "suffix": "+",
        "label": "OFFRES D'EMPLOI",
        "icon": Icons.work,
        "color": Colors.teal[700],
      },
    ];

    double screenWidth = MediaQuery.of(context).size.width;
    bool isMobile = screenWidth < 800;

    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
      child: Column(
        children: [

          isMobile ? Column(
            children: stats.map((stat) => Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: _buildAnimatedStatItem(stat),
            )).toList(),
          ): Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: stats.map((stat) => _buildAnimatedStatItem(stat)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedStatItem(Map<String, dynamic> stat) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 1200),
      curve: Curves.easeOut,
      builder: (context, opacity, child) {
        return Opacity(
          opacity: opacity,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - opacity)), // Petit effet de glissement vers le haut
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 1. L'ICÔNE DANS UN CERCLE COLORÉ
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: (stat['color'] as Color).withOpacity(0.1), // Fond léger
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    stat['icon'],
                    color: stat['color'],
                    size: 35,
                  ),
                ),
                const SizedBox(height: 15),

                // 2. LE CHIFFRE ANIMÉ (COMPTEUR)
                TweenAnimationBuilder<int>(
                  tween: IntTween(begin: 0, end: stat['value']),
                  duration: const Duration(seconds: 2),
                  curve: Curves.easeOutExpo,
                  builder: (context, value, child) {
                    return Text(
                      "$value${stat['suffix']}", // ex: "8000+"
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w800,
                        color: Colors.grey[900], // Texte presque noir
                        height: 1.0,
                      ),
                    );
                  },
                ),

                const SizedBox(height: 8),

                // 3. LE LABEL
                Text(
                  stat['label'],
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[600],
                    letterSpacing: 1.0,
                  ),
                  textAlign: TextAlign.center,
                ),

                // Petite ligne décorative
                const SizedBox(height: 10),
                Container(
                  width: 30,
                  height: 3,
                  decoration: BoxDecoration(
                      color: stat['color'],
                      borderRadius: BorderRadius.circular(2)
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}