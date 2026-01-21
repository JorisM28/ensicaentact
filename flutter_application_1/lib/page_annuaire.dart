import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Nécessaire pour le clavier (LogicalKeyboardKey)
import 'colors.dart';
import 'filtre.dart';
import 'alumnis.dart';
import 'database_service.dart';
import 'alumni_detail_page.dart';
import 'alumni_preview.dart';

// Si tu n'as pas séparé le main, garde le main() ici. Sinon, efface ces 3 lignes.
void main() {
  runApp(const MonReseauAlumni());
}

class MonReseauAlumni extends StatelessWidget {
  const MonReseauAlumni({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: AppColors.ensiCyan),
      home: const PageAnnuaire(),
    );
  }
}

class PageAnnuaire extends StatefulWidget {
  const PageAnnuaire({super.key});

  @override
  State<PageAnnuaire> createState() => _PageAnnuaireState();
}

class _PageAnnuaireState extends State<PageAnnuaire> {
  // --- VARIABLES D'ÉTAT ---
  Alumnis? _eleveSelectionne;
  late Future<List<Alumnis>> _futureAlumnis;
  
  // Permet de contrôler le défilement de la liste (pour suivre la sélection clavier)
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // On charge les données une seule fois au démarrage
    _futureAlumnis = DatabaseService().getTousLesEleves();
  }

  // --- LOGIQUE DE NAVIGATION CLAVIER ---
  void _changerSelectionClavier(int direction, List<Alumnis> liste) {
    if (liste.isEmpty) return;

    // 1. Si personne n'est sélectionné, on prend le premier
    if (_eleveSelectionne == null) {
      setState(() {
        _eleveSelectionne = liste.first;
      });
      return;
    }

    // 2. Calcul du nouvel index
    int indexActuel = liste.indexOf(_eleveSelectionne!);
    int nouvelIndex = indexActuel + direction;

    // 3. Vérification des limites (ne pas aller plus haut que 0 ou plus bas que la fin)
    if (nouvelIndex >= 0 && nouvelIndex < liste.length) {
      setState(() {
        _eleveSelectionne = liste[nouvelIndex];
      });

      // 4. Scroll automatique pour garder l'élément visible
      // On estime qu'une carte fait environ 80-100 pixels de haut
      if (_scrollController.hasClients) {
        double positionCible = nouvelIndex * 90.0; // 90 est une moyenne de hauteur de carte
        // On centre un peu le scroll
        _scrollController.animateTo(
          positionCible > 200 ? positionCible - 200 : positionCible, 
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double largeurEcran = MediaQuery.of(context).size.width;
    bool estGrandEcran = largeurEcran > 800;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            // Image.asset('assets/logo_alumni.png', scale: 20), // Décommente si tu as l'image
            const SizedBox(width: 10),
            const Text("ENSIcaentact"),
          ],
        ),
        backgroundColor: AppColors.ensiCyan,
        foregroundColor: Colors.white,
        actions: const [
          Icon(Icons.account_circle, size: 40),
          SizedBox(width: 20),
        ],
      ),

      // FutureBuilder pour charger les données
      body: FutureBuilder<List<Alumnis>>(
        future: _futureAlumnis,
        builder: (context, snapshot) {
          // Cas 1 : Chargement
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          // Cas 2 : Erreur
          if (snapshot.hasError) {
            return Center(child: Text("Erreur : ${snapshot.error}", style: const TextStyle(color: Colors.red)));
          }
          // Cas 3 : Pas de données
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Aucun résultat trouvé."));
          }

          final listeAlumnis = snapshot.data!;

          // --- LE COEUR DE LA PAGE (FOCUS WIDGET) ---
          return Focus(
            autofocus: true, // Capture le clavier dès l'ouverture
            onKeyEvent: (node, event) {
              // On écoute l'appui sur les touches (KeyDown)
              if (event is KeyDownEvent) {
                if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
                  _changerSelectionClavier(1, listeAlumnis); // Descendre
                  return KeyEventResult.handled;
                } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
                  _changerSelectionClavier(-1, listeAlumnis); // Monter
                  return KeyEventResult.handled;
                }
              }
              return KeyEventResult.ignored; // Laisser passer les autres touches
            },
            child: Column(
              children: [
                // --- ZONE DE FILTRES (Partie Grise en haut) ---
                Container(
                  padding: const EdgeInsets.all(20),
                  color: Colors.grey[100],
                  child: estGrandEcran
                      ? Row(
                          children: [
                            SizedBox(width: 400, child: _champRecherche()),
                            const Spacer(),
                            const FilterChipExample(),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _champRecherche(),
                            const SizedBox(height: 15),
                            const FilterChipExample(),
                          ],
                        ),
                ),

                // --- ZONE PRINCIPALE (Liste + Détail) ---
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // --- COLONNE GAUCHE : LISTE ---
                      Expanded(
                        flex: estGrandEcran ? 1 : 1, // 1/3 de l'écran sur PC
                        child: Container(
                          color: Colors.white,
                          child: ListView.builder(
                            controller: _scrollController, // IMPORTANT pour le scroll auto
                            itemCount: listeAlumnis.length,
                            padding: const EdgeInsets.all(10),
                            itemBuilder: (context, index) {
                              final eleve = listeAlumnis[index];
                              // Vérifie si cet élève est celui sélectionné (pour le colorier)
                              final estSelectionne = eleve == _eleveSelectionne;

                              return _carteEleve(context, eleve, estSelectionne, estGrandEcran);
                            },
                          ),
                        ),
                      ),

                      // --- COLONNE DROITE : DÉTAIL (Seulement sur grand écran) ---
                      if (estGrandEcran) ...[
                        const VerticalDivider(width: 1, thickness: 1, color: Colors.grey),
                        Expanded(
                          flex: 1, // 2/3 de l'écran
                          child: Container(
                            color: Colors.grey[50],
                            // Si aucun sélectionné, affiche message par défaut. Sinon, affiche la page détail.
                            child: _eleveSelectionne == null
                                ? _vueParDefaut()
                                : AlumniPreview(alumni: _eleveSelectionne!),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // --- WIDGETS AUXILIAIRES ---

  Widget _champRecherche() {
    return TextField(
      decoration: InputDecoration(
        hintText: "Rechercher...",
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }

  Widget _vueParDefaut() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.touch_app, size: 80, color: Colors.grey),
        const SizedBox(height: 20),
        const Text(
          "Sélectionnez un élève",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.grey),
        ),
        const SizedBox(height: 10),
        Text(
          "Utilisez les flèches ↑ ↓ de votre clavier",
          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
        ),
      ],
    );
  }

Widget _carteEleve(BuildContext context, Alumnis eleve, bool estSelectionne, bool estGrandEcran) {
    return Card(
      elevation: estSelectionne ? 8 : 2,
      color: estSelectionne ? AppColors.ensiCyan.withOpacity(0.1) : Colors.white,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: estSelectionne 
            ? const BorderSide(color: AppColors.ensiCyan, width: 2) 
            : BorderSide.none,
      ),
      child: InkWell( // InkWell gère les clics
        borderRadius: BorderRadius.circular(10), // Pour que l'effet visuel suive les bords arrondis
        
        onTap: () {
          if (estGrandEcran) {
            setState(() {
              _eleveSelectionne = eleve;
            });
          } else {
            _ouvrirPageDetail(context, eleve);
          }
        },

        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: AppColors.ensiCyan,
                radius: 30,
                child: Text(
                  eleve.prenom.isNotEmpty ? eleve.prenom[0] : "?",
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(
                      TextSpan(
                        text: eleve.nomComplet,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold, 
                          fontSize: 16, 
                          color: Colors.black
                        ),
                        children: [
                          if (eleve.promo != null)
                            TextSpan(
                              text: " - ${eleve.promo}",
                              style: TextStyle(
                                color: Colors.grey[600], 
                                fontWeight: FontWeight.bold,
                                fontSize: 14 
                              ),
                            ),
                        ],
                      ),
                      overflow: TextOverflow.ellipsis,  
                    ),
                    Text("${eleve.job} @ ${eleve.entreprise}", style: TextStyle(color: Colors.grey[800])),
                    const SizedBox(height: 5),
                    Wrap(
                      spacing: 5,
                      children: [
                        Chip(label: Text(eleve.filiere, style: const TextStyle(fontSize: 10)), backgroundColor: Colors.blue[50]),
                        Chip(avatar: const Icon(Icons.location_on, size: 14), label: Text(eleve.ville, style: const TextStyle(fontSize: 10)), backgroundColor: Colors.orange[50]),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Petite fonction utilitaire pour éviter de répéter le code de navigation
  void _ouvrirPageDetail(BuildContext context, Alumnis eleve) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AlumniDetailPage(alumni: eleve)),
    );
  }}