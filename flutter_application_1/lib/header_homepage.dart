import 'package:flutter/material.dart';
import 'colors.dart';



class HeaderHomePage extends StatelessWidget {
  const HeaderHomePage({super.key});

  static const sciencesPoRed = AppColors.ensiCyan;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isDesktop = screenWidth > 1100;

    return Container(
      width: double.infinity,
      height: 80,
      color: AppColors.ensiCyan,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // --------------------
          // 1. LE LOGO (Gauche)
          // --------------------
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: const TextSpan(
                  style: TextStyle(color: Colors.white, fontSize: 24, fontFamily: 'Arial'),
                  children: [
                    TextSpan(
                        text: "Sciences",
                        style: TextStyle(fontWeight: FontWeight.bold)
                    ),
                    TextSpan(
                        text: "Po",
                        style: TextStyle(fontWeight: FontWeight.w300) // "Po" est plus fin
                    ),
                  ],
                ),
              ),
              const Text(
                "ALUMNI",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  letterSpacing: 1.5, // Espacement des lettres
                ),
              ),
            ],
          ),

          // Espace flexible
          const Spacer(),

          // --------------------
          // 2. LE MENU CENTRAL (Caché si écran trop petit)
          // --------------------
          if (isDesktop) ...[
            _buildMenuLink("L'Association"),
            _buildMenuLink("Agenda & actualités"),
            _buildMenuLink("Annuaire"),
            _buildMenuLink("Réseau"),
            _buildMenuLink("Carrières"),
            _buildMenuLink("Émile"),
            _buildMenuLink("Sciences Po"),
          ],

          const Spacer(),

          // --------------------
          // 3. LES ACTIONS (Droite)
          // --------------------

          // Bouton "Cotiser"
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.thumb_up_alt_outlined, color: sciencesPoRed, size: 18),
            label: const Text("Cotiser", style: TextStyle(color: sciencesPoRed, fontWeight: FontWeight.bold)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            ),
          ),

          const SizedBox(width: 15),

          // Barre de recherche "Rechercher un alumni"
          Container(
            width: 250,
            height: 45,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              children: const [
                Icon(Icons.search, color: sciencesPoRed),
                SizedBox(width: 8),
                Text(
                  "Rechercher un alumni",
                  style: TextStyle(color: sciencesPoRed, fontSize: 14),
                ),
              ],
            ),
          ),

          // Si on est sur mobile, on ajoute un icône de menu burger à droite
          if (!isDesktop) ...[
            const SizedBox(width: 15),
            IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () {
                // Ouvrir un Drawer ici
              },
            )
          ]
        ],
      ),
    );
  }

  // Petite fonction pour éviter de répéter le style des liens du menu
  Widget _buildMenuLink(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: TextButton(
        onPressed: () {},
        child: Text(
          title,
          style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w400
          ),
        ),
      ),
    );
  }
}