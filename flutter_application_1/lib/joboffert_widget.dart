import 'package:flutter/material.dart';

class JobOfferWidget extends StatelessWidget {
  const JobOfferWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Données fictives basées sur ta capture
    final List<Map<String, String>> jobs = [
      {
        "title": "Consultant Confirmé En Diagnostic Industriel (H/F)",
        "company": "GROUPE ALPHA -",
        "location": ""
      },
      {
        "title": "Deputy Director - Development Co-Operation Directorate M/F",
        "company": "OCDE - DIRECTION DE LA COOPERATION POUR LE DEVELOPPEMENT - PARIS",
        "location": ""
      },
      {
        "title": "Stagiaire Auprès De Bernard SPITZ - Stage 6 Mois",
        "company": "BSC CONSEILS -",
        "location": ""
      },
      {
        "title": "Customer Success Manager H/F",
        "company": "Paradigme - Paris",
        "location": ""
      },
    ];

    return Container(
      width: double.infinity, // Prend toute la largeur
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      color: const Color(0xFFE6E6E6), // Le fond gris clair caractéristique de la capture
      child: Column(
        children: [
          // TITRE DE LA SECTION
          const Text(
            "OFFRES D'EMPLOI",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w400,
              letterSpacing: 1.0,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),

          // LISTE DES OFFRES
          // On utilise Column ici car le widget est dans une SingleChildScrollView parente (HomePage)
          Column(
            children: jobs.map((job) => _buildJobCard(job)).toList(),
          ),

          const SizedBox(height: 30),

          // BOUTON VOIR TOUTES LES OFFRES
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFFE30613)), // Bordure rouge
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
              backgroundColor: Colors.transparent, // Fond transparent (ou gris clair comme le container)
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)), // Bord carré/légèrement arrondi
            ),
            child: const Text(
              "Voir toutes les offres",
              style: TextStyle(
                  color: Color(0xFFE30613), // Texte rouge
                  fontSize: 16,
                  fontWeight: FontWeight.w500
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJobCard(Map<String, String> job) {
    return Container(
      width: double.infinity, // La carte prend toute la largeur disponible
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(2), // Coins très légèrement arrondis
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TITRE DU POSTE
          Text(
            job['title']!,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600, // Semi-bold
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 8),

          // ENTREPRISE / LIEU
          Text(
            job['company']!,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.grey, // Gris moyen
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}