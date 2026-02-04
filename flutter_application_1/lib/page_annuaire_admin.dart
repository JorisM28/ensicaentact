import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'colors.dart';
import 'alumnis.dart';
import 'database_service.dart';
import 'alumni_detail_page_admin.dart';
import 'alumni_preview.dart';
import 'filtre_widget.dart';
import 'add_alumni.dart'; 

void main() {
  runApp(const MonReseauAlumni()); 
}

class MonReseauAlumni extends StatelessWidget {
  final bool estAdmin;
  final Map<String, dynamic> user;
  
  const MonReseauAlumni({
    super.key, 
    this.estAdmin = true, 
    this.user = const {
      'prenom': 'Super',
      'nom': 'Admin',
      'role': 'admin'
    }
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: AppColors.ensiCyan),
      home: PageAnnuaireAdmin(estAdmin: estAdmin, user: user), 
    );
  }
}

class PageAnnuaireAdmin extends StatefulWidget {
  final bool estAdmin;
  final Map<String, dynamic> user; 

  const PageAnnuaireAdmin({
    super.key, 
    this.estAdmin = true,
    this.user = const {
      'prenom': 'Admin',
      'nom': 'Système',
      'role': 'admin'
    }
  });

  @override
  State<PageAnnuaireAdmin> createState() => _PageAnnuaireAdminState();
}

class _PageAnnuaireAdminState extends State<PageAnnuaireAdmin> {
  Alumnis? _eleveSelectionne;
  final ScrollController _scrollController = ScrollController();
  List<Alumnis> _tousLesAlumnis = [];
  List<Alumnis> _alumnisAffiches = [];
  
  // --- ETAT DES FILTRES ---
  final Set<String> _filtresPromoSelectionnes = {};
  final Set<String> _filtresFiliereSelectionnes = {};
  final Set<String> _filtresPaysStageSelectionnes = {}; // <--- NOUVEAU

  bool _chargementEnCours = true;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _chargerDonneesInitiales();
  }

  // --- GETTERS ---
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

  // <--- NOUVEAU GETTER : Parcours les stages pour trouver les pays uniques
  List<String> get _paysStageDisponibles {
    final Set<String> paysTrouves = {};
    for (var alumni in _tousLesAlumnis) {
      for (var stage in alumni.stages) {
        if (stage.pays.isNotEmpty && stage.pays != "Non renseigné") {
          paysTrouves.add(stage.pays);
        }
      }
    }
    final listeTriee = paysTrouves.toList();
    listeTriee.sort();
    return listeTriee;
  }
  // ---------------

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

    // 1. Filtre Texte
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

    // 2. Filtre Promo
    if (_filtresPromoSelectionnes.isNotEmpty) {
      resultats = resultats.where((eleve) {
        return _filtresPromoSelectionnes.contains(eleve.promo.toString());
      }).toList();
    }

    // 3. Filtre Filière
    if (_filtresFiliereSelectionnes.isNotEmpty) {
      resultats = resultats.where((eleve) {
        return _filtresFiliereSelectionnes.contains(eleve.filiere);
      }).toList();
    }

    // 4. Filtre Pays Stage (NOUVEAU)
    if (_filtresPaysStageSelectionnes.isNotEmpty) {
      resultats = resultats.where((eleve) {
        // On garde l'élève s'il a au moins UN stage dans un des pays sélectionnés
        for (var stage in eleve.stages) {
          if (_filtresPaysStageSelectionnes.contains(stage.pays)) {
            return true;
          }
        }
        return false;
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
        title: const Text("ENSIcaentact (Admin)"),
        backgroundColor: AppColors.ensiCyan,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => _afficherHistorique(context),
          ),
        ],
      ),
      
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.ensiCyan,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("Nouvel Alumni"),
              content: SizedBox(
                width: 500,
                child: AddAlumniForm(
                  onSuccess: () {
                    Navigator.pop(context);
                    // On recharge juste les données au lieu de pushReplacement
                    // c'est plus fluide
                    _chargerDonneesInitiales();
                  },
                ),
              ),
            ),
          );
        },
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(width: 400, child: _champRecherche()),
                                const Padding(padding: EdgeInsets.all(15)),
                                Expanded(
                                  // --- FILTRES DESKTOP ---
                                  child: ZoneFiltres(
                                    // Promos
                                    promosDisponibles: _promosDisponibles,
                                    promosSelectionnees: _filtresPromoSelectionnes,
                                    onPromoChanged: (promo, estCoche) {
                                      setState(() {
                                        estCoche
                                            ? _filtresPromoSelectionnes.add(promo)
                                            : _filtresPromoSelectionnes.remove(promo);
                                        _filtrerResultats(_searchController.text);
                                      });
                                    },
                                    // Filières
                                    filieresDisponibles: _filieresDisponibles,
                                    filieresSelectionnees: _filtresFiliereSelectionnes,
                                    onFiliereChanged: (filiere, estCoche) {
                                      setState(() {
                                        estCoche
                                            ? _filtresFiliereSelectionnes.add(filiere)
                                            : _filtresFiliereSelectionnes.remove(filiere);
                                        _filtrerResultats(_searchController.text);
                                      });
                                    },
                                    // Pays Stage (NOUVEAU)
                                    paysStageDisponibles: _paysStageDisponibles,
                                    paysStageSelectionnees: _filtresPaysStageSelectionnes,
                                    onPaysStageChanged: (pays, estCoche) {
                                      setState(() {
                                        estCoche
                                            ? _filtresPaysStageSelectionnes.add(pays)
                                            : _filtresPaysStageSelectionnes.remove(pays);
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
                                const Text("Trouver un mentor",
                                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 15),
                                _champRecherche(),
                                const SizedBox(height: 15),
                                // --- FILTRES MOBILE ---
                                ZoneFiltres(
                                  // Promos
                                  promosDisponibles: _promosDisponibles,
                                  promosSelectionnees: _filtresPromoSelectionnes,
                                  onPromoChanged: (promo, estCoche) {
                                    setState(() {
                                      estCoche
                                          ? _filtresPromoSelectionnes.add(promo)
                                          : _filtresPromoSelectionnes.remove(promo);
                                      _filtrerResultats(_searchController.text);
                                    });
                                  },
                                  // Filières
                                  filieresDisponibles: _filieresDisponibles,
                                  filieresSelectionnees: _filtresFiliereSelectionnes,
                                  onFiliereChanged: (filiere, estCoche) {
                                    setState(() {
                                      estCoche
                                          ? _filtresFiliereSelectionnes.add(filiere)
                                          : _filtresFiliereSelectionnes.remove(filiere);
                                      _filtrerResultats(_searchController.text);
                                    });
                                  },
                                  // Pays Stage (NOUVEAU)
                                  paysStageDisponibles: _paysStageDisponibles,
                                  paysStageSelectionnees: _filtresPaysStageSelectionnes,
                                  onPaysStageChanged: (pays, estCoche) {
                                    setState(() {
                                      estCoche
                                          ? _filtresPaysStageSelectionnes.add(pays)
                                          : _filtresPaysStageSelectionnes.remove(pays);
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
                                  // Maintenant widget.user va fonctionner !
                                  : AlumniPreview(alumni: _eleveSelectionne!, user: widget.user), 
                            ),
                          ]
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
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
      setState(() => _eleveSelectionne = liste.first);
      return;
    }
    int indexActuel = liste.indexOf(_eleveSelectionne!);
    if (indexActuel == -1) {
      setState(() => _eleveSelectionne = liste.first);
      return;
    }
    int nouvelIndex = indexActuel + direction;
    if (nouvelIndex >= 0 && nouvelIndex < liste.length) {
      setState(() => _eleveSelectionne = liste[nouvelIndex]);
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

  void _afficherHistorique(BuildContext context) async {
    final logs = await DatabaseService().getHistorique();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.history, color: AppColors.ensiCyan),
            SizedBox(width: 10),
            Text("Historique des actions"),
          ],
        ),
        content: SizedBox(
          width: 500,
          height: 400,
          child: logs.isEmpty
              ? const Center(child: Text("Aucune action enregistrée."))
              : ListView.builder(
                  itemCount: logs.length,
                  itemBuilder: (context, index) {
                    final log = logs[index];
                    final bool isDelete = log['action'] == 'SUPPRESSION';
                    
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: isDelete ? Colors.red[50] : Colors.green[50],
                        child: Icon(
                          isDelete ? Icons.delete_forever : Icons.person_add,
                          color: isDelete ? Colors.red : Colors.green,
                          size: 20,
                        ),
                      ),
                      title: Text(
                        "${log['prenom_alumni']} ${log['nom_alumni']}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        "${log['action']} le ${log['date_action']}",
                        style: const TextStyle(fontSize: 12),
                      ),
                    );
                  },
                ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Fermer"),
          ),
        ],
      ),
    );
  }

  Widget _carteEleve(BuildContext context, Alumnis eleve, bool estSelectionne, bool estGrandEcran) {
    void _ouvrirPageComplete(BuildContext context) async {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AlumniDetailPageAdmin(alumni: eleve),
        ),
      );
      _chargerDonneesInitiales();
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
                  style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
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
                            color: Colors.black),
                        children: [
                          if (eleve.promo != 0)
                            TextSpan(
                              text: " - ${eleve.promo}",
                              style: TextStyle(
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14),
                            ),
                        ],
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text("${eleve.job} @ ${eleve.entreprise}",
                        style: TextStyle(color: Colors.grey[800])),
                    const SizedBox(height: 5),
                    Wrap(
                      spacing: 5,
                      children: [
                        Chip(
                            label: Text(eleve.filiere,
                                style: const TextStyle(fontSize: 10)),
                            backgroundColor: Colors.blue[50]),
                        Chip(
                            avatar:
                                const Icon(Icons.location_on, size: 14),
                            label: Text(eleve.ville,
                                style: const TextStyle(fontSize: 10)),
                            backgroundColor: Colors.orange[50]),
                      ],
                    ),
                  ],
                ),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                ),
                onPressed: () => _ouvrirPageComplete(context),
                icon: const Icon(Icons.visibility, size: 18),
                label: const Text("Voir", style: TextStyle(fontSize: 12)),
              ),
              IconButton(
                icon : const Icon(Icons.delete, color: Colors.red),
                onPressed: () async {
                  bool confirmation = await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Supprimer ?"),
                      content: Text("Veux-tu vraiment supprimer ${eleve.nomComplet} ?"),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Non")),
                        TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("Oui")),
                      ]
                    ),
                  ) ?? false;

                  if (confirmation) {
                    // UTILISATION DE L'ID (CRUCIAL POUR PHP)
                    await DatabaseService().supprimerEleve(eleve.nom, eleve.prenom);

                    // Rechargement des données sans changer de page (plus fluide)
                    _chargerDonneesInitiales();
                    
                    // Si on a supprimé celui qui était sélectionné à droite, on le déselectionne
                    if (_eleveSelectionne == eleve) {
                      setState(() {
                         _eleveSelectionne = null;
                      });
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _ouvrirPageDetail(BuildContext context, Alumnis eleve) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AlumniDetailPageAdmin(alumni: eleve)),
    );
    _chargerDonneesInitiales();
  }
}