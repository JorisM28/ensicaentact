import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'colors.dart';
import 'alumnis.dart';  
import 'database_service.dart';
import 'alumni_detail_page.dart';
import 'alumni_preview.dart';
import 'filtre_widget.dart';

void main() {
  runApp(const MonReseauAlumni());
}

class MonReseauAlumni extends StatelessWidget {
  final bool estAdmin;
  const MonReseauAlumni({super.key, this.estAdmin = false});

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
  final Map<String, dynamic> user;
  const PageAnnuaire({
    super.key, 
    this.user = const {
      'prenom': 'Visiteur',
      'nom': '',
      'email': '',
      'role': 'guest', /// a voir apres !!!
    },
  });
  @override
  State<PageAnnuaire> createState() => _PageAnnuaireState();
}

class _PageAnnuaireState extends State<PageAnnuaire> {
  Alumnis? _eleveSelectionne;
  final ScrollController _scrollController = ScrollController();
  List<Alumnis> _tousLesAlumnis = [];
  List<Alumnis> _alumnisAffiches = [];
  final Set<String> _filtresPromoSelectionnes = {};
  final Set<String> _filtresFiliereSelectionnes = {};
  bool _chargementEnCours = true;
  TextEditingController _searchController = TextEditingController();

  bool get estAdmin => widget.user['role'] == 'admin';

  @override
  void initState() {
    super.initState();
    _chargerDonneesInitiales();
  }

  List<String> get _promosDisponibles {
    final promos = _tousLesAlumnis
        .map((e) => e.promo.toString())
        .where((e) => e != "0" && e.isNotEmpty)
        .toSet()
        .toList();
    promos.sort();
    return promos;
  }

  List<String> get _filieresDisponibles {
    final filieres = _tousLesAlumnis
        .map((e) => e.filiere)
        .where((e) => e.isNotEmpty)
        .toSet()
        .toList();
    filieres.sort();
    return filieres;
  }

  void _chargerDonneesInitiales() async {
    try {
      var donnees = await DatabaseService().getTousLesEleves();
      setState(() {
        _tousLesAlumnis = donnees;
        _alumnisAffiches = donnees;
        _chargementEnCours = false;
      });
    } catch (e) {
      print("Erreur de chargement : $e");
      setState(() {
        _chargementEnCours = false;
      });
    }
  }

 void _filtrerResultats(String recherche) {
    List<Alumnis> resultats = _tousLesAlumnis;

    if (recherche.isNotEmpty) {
      resultats = resultats.where((eleve) {
        final nomLower = eleve.nomComplet.toLowerCase();
        final jobLower = eleve.job.toLowerCase();
        final entrepriseLower = eleve.entreprise.toLowerCase();
        final queryLower = recherche.toLowerCase();

        return nomLower.contains(queryLower) || 
               jobLower.contains(queryLower) || 
               entrepriseLower.contains(queryLower);
      }).toList();
    }

    if (_filtresPromoSelectionnes.isNotEmpty) {
      resultats = resultats.where((eleve) {
        return _filtresPromoSelectionnes.contains(eleve.promo.toString());
      }).toList();
    }

    if (_filtresFiliereSelectionnes.isNotEmpty) {
      resultats = resultats.where((eleve) {
        return _filtresFiliereSelectionnes.contains(eleve.filiere);
      }).toList();
    }

    setState(() {
      _alumnisAffiches = resultats;
      if (_eleveSelectionne != null && !resultats.contains(_eleveSelectionne)) {
        _eleveSelectionne = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double largeurEcran = MediaQuery.of(context).size.width;
    bool estGrandEcran = largeurEcran > 800;

    return Scaffold(
      appBar: AppBar(
        title: const Text("ENSIcaentact"),
        backgroundColor: AppColors.ensiCyan,
        foregroundColor: Colors.white,
      ),
      
      body: _chargementEnCours
          ? const Center(child: CircularProgressIndicator())
          : CallbackShortcuts(
              bindings: {
                const SingleActivator(LogicalKeyboardKey.arrowDown): () {
                  _changerSelectionClavier(1, _alumnisAffiches);
                },
                const SingleActivator(LogicalKeyboardKey.arrowUp): () {
                  _changerSelectionClavier(-1, _alumnisAffiches);
                },
              },
              child: Focus(
                autofocus: true,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      color: Colors.grey[100],
                      child: estGrandEcran
                ? Row(
                    children: [
                      SizedBox(width: 400, child: _champRecherche()),
                      Padding(padding: const EdgeInsets.all(15)),
                      Expanded(
                        child: ZoneFiltres(
                          promosDisponibles: _promosDisponibles,
                          filieresDisponibles: _filieresDisponibles,
                          promosSelectionnees: _filtresPromoSelectionnes,
                          filieresSelectionnees: _filtresFiliereSelectionnes,
                          onPromoChanged: (promo, estCoche) {
                            setState(() {
                              estCoche ? _filtresPromoSelectionnes.add(promo) : _filtresPromoSelectionnes.remove(promo);
                              _filtrerResultats(_searchController.text);
                            });
                          },
                          onFiliereChanged: (filiere, estCoche) {
                             setState(() {
                              estCoche ? _filtresFiliereSelectionnes.add(filiere) : _filtresFiliereSelectionnes.remove(filiere);
                              _filtrerResultats(_searchController.text);
                            });
                          },
                        ),
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Trouver un mentor", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 15),
                      _champRecherche(),
                      const SizedBox(height: 15),
                      ZoneFiltres(
                          promosDisponibles: _promosDisponibles,
                          filieresDisponibles: _filieresDisponibles,
                          promosSelectionnees: _filtresPromoSelectionnes,
                          filieresSelectionnees: _filtresFiliereSelectionnes,
                          onPromoChanged: (promo, estCoche) {
                            setState(() {
                              estCoche ? _filtresPromoSelectionnes.add(promo) : _filtresPromoSelectionnes.remove(promo);
                              _filtrerResultats(_searchController.text);
                            });
                          },
                          onFiliereChanged: (filiere, estCoche) {
                             setState(() {
                              estCoche ? _filtresFiliereSelectionnes.add(filiere) : _filtresFiliereSelectionnes.remove(filiere);
                              _filtrerResultats(_searchController.text);
                            });
                          },
                        ),
                    ],
                  ),
          ),
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Container(
                              color: Colors.white,
                              child: _alumnisAffiches.isEmpty
                                  ? const Center(child: Text("Aucun résultat"))
                                  : ListView.builder(
                                      controller: _scrollController,
                                      itemCount: _alumnisAffiches.length,
                                      padding: const EdgeInsets.all(10),
                                      itemBuilder: (context, index) {
                                        final eleve = _alumnisAffiches[index];
                                        final estSelectionne = eleve == _eleveSelectionne;
                                        return _carteEleve(context, eleve, estSelectionne, estGrandEcran);
                                      },
                                    ),
                            ),
                          ),
                          if (estGrandEcran) ...[
                            const VerticalDivider(width: 1),
                            Expanded(
                              flex: 2,
                              child: _eleveSelectionne == null
                                  ? _vueParDefaut()
                                  : AlumniPreview(alumni: _eleveSelectionne!, user: widget.user,),
                            ),
                          ]
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),);
  }

 Widget _champRecherche() {
    return TextField(
      controller: _searchController,
      onChanged: (value) => _filtrerResultats(value),
      decoration: InputDecoration(
        hintText: "Recherche...",
        prefixIcon: const Icon(Icons.search),
        suffixIcon: _searchController.text.isNotEmpty 
            ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _searchController.clear();
                  _filtrerResultats('');
                  FocusScope.of(context).unfocus(); 
                },
              ) 
            : null,
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
  void _changerSelectionClavier(int direction, List<Alumnis> liste) {
    if (liste.isEmpty) return;

    if (_eleveSelectionne == null) {
      setState(() {
        _eleveSelectionne = liste.first;
      });
      return;
    }

    int indexActuel = liste.indexOf(_eleveSelectionne!);
    
    if (indexActuel == -1) {
       setState(() {
        _eleveSelectionne = liste.first;
      });
      return;
    }

    int nouvelIndex = indexActuel + direction;

    if (nouvelIndex >= 0 && nouvelIndex < liste.length) {
      setState(() {
        _eleveSelectionne = liste[nouvelIndex];
      });

      if (_scrollController.hasClients) {
        double positionCible = nouvelIndex * 90.0;
        _scrollController.animateTo(
          positionCible > 200 ? positionCible - 200 : positionCible, 
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    }
  }

Widget _carteEleve(BuildContext context, Alumnis eleve, bool estSelectionne, bool estGrandEcran) {
  void _ouvrirPageComplete(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AlumniDetailPage(alumni: eleve, user: widget.user),
      ),
    );
  }
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
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
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
                          if (eleve.promo != 0)
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
              ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              ),
              onPressed: () => _ouvrirPageComplete(context),
              icon: const Icon(Icons.visibility, size: 18),
              label: const Text("Voir", style: TextStyle(fontSize: 12)),
            ),
            ],
          ),
        ),
      ),
    );
  }

  void _ouvrirPageDetail(BuildContext context, Alumnis eleve) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AlumniDetailPage(alumni: eleve, user: widget.user)),
    );
  }
}