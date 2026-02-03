import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'profileBadge.dart';
import 'colors.dart';
import 'alumnis.dart';
import 'database_service.dart';
import 'filtre_widget.dart';
import 'alumni_detail_page.dart'; 
import 'alumni_detail_page_admin.dart';
import 'alumni_preview.dart';
import 'add_alumni.dart'; 
import 'navigation.dart';

void main() {
  runApp(const MonReseauAlumni());
}

class MonReseauAlumni extends StatelessWidget {
  const MonReseauAlumni({super.key});

  @override
  Widget build(BuildContext context) {
    const userConnecte = {
      'prenom': 'Test',
      'nom': 'Guest',
      'role': 'guest',
      'email': 'guest@test.fr'
    };

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: AppColors.ensiCyan),
      home: const PageAnnuaire(user: userConnecte),
    );
  }
}

class PageAnnuaire extends StatefulWidget {
  final Map<String, dynamic> user;

  const PageAnnuaire({
    super.key,
    required this.user, 
  });

  @override
  State<PageAnnuaire> createState() => _PageAnnuaireState();
}

class _PageAnnuaireState extends State<PageAnnuaire> with RouteAware{
  Alumnis? _eleveSelectionne;
  final ScrollController _scrollController = ScrollController();
  List<Alumnis> _tousLesAlumnis = [];
  List<Alumnis> _alumnisAffiches = [];
  bool _filtresOuverts = false;
  
  final Set<String> _filtresPromoSelectionnes = {};
  final Set<String> _filtresFiliereSelectionnes = {};
  final Set<String> _filtresPaysStageSelectionnes = {};
  
  bool _chargementEnCours = true;
  final TextEditingController _searchController = TextEditingController();

  bool get estAdmin => widget.user['role'] == 'admin';
@override
void didChangeDependencies() {
  super.didChangeDependencies();
  routeObserver.subscribe(this, ModalRoute.of(context)! as PageRoute);
}

@override
void dispose() {
  routeObserver.unsubscribe(this);
  super.dispose();
}
  @override
  void initState() {
    super.initState();
    _chargerDonneesInitiales();
  }
  @override
void didPopNext() {
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

  void _chargerDonneesInitiales() async {
    print("rechargement de la page");
    try {
        var donnees = await DatabaseService().getTousLesEleves();
      
      if (!mounted) return;

      setState(() {
        _tousLesAlumnis = donnees;
        _alumnisAffiches = donnees;
        _chargementEnCours = false;
        
        if (_searchController.text.isNotEmpty || 
            _filtresPromoSelectionnes.isNotEmpty || 
            _filtresFiliereSelectionnes.isNotEmpty ||
            _filtresPaysStageSelectionnes.isNotEmpty) {
            
            _filtrerResultats(_searchController.text); 
        }
      });
    } catch (e) {
      print("Erreur de chargement : $e");
      if (mounted) setState(() => _chargementEnCours = false);
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
      resultats = resultats.where((e) => _filtresPromoSelectionnes.contains(e.promo.toString())).toList();
    }
    if (_filtresFiliereSelectionnes.isNotEmpty) {
      resultats = resultats.where((e) => _filtresFiliereSelectionnes.contains(e.filiere)).toList();
    }
    if (_filtresPaysStageSelectionnes.isNotEmpty) {
      resultats = resultats.where((eleve) {
        for (var stage in eleve.stages) {
          if (_filtresPaysStageSelectionnes.contains(stage.pays)) return true;
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

  Widget _boutonFiltre() {
  return Container(
    margin: const EdgeInsets.only(left: 10),
    decoration: BoxDecoration(
      color: _filtresOuverts ? AppColors.ensiCyan : Colors.white,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: Colors.grey.shade300),
    ),
    child: IconButton(
      icon: Icon(
        _filtresOuverts ? Icons.filter_list_off : Icons.filter_list,
        color: _filtresOuverts ? Colors.white : Colors.grey[700],
      ),
      tooltip: _filtresOuverts ? "Masquer les filtres" : "Afficher les filtres",
      onPressed: () {
        setState(() {
          _filtresOuverts = !_filtresOuverts;
        });
      },
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    double largeurEcran = MediaQuery.of(context).size.width;
    bool estGrandEcran = largeurEcran > 800;

    return Scaffold(
      appBar: AppBar(
        title: Text("ENSIcaentact ("+widget.user['role']+')'),
        backgroundColor: AppColors.ensiCyan,
        foregroundColor: Colors.white,
        actions: [
          if (estAdmin)
            IconButton(
              icon: const Icon(Icons.history),
              tooltip: "Historique des actions",
              onPressed: () => _afficherHistorique(context),
            ),
            ProfileBadge(user: widget.user)
        ],
      ),
      floatingActionButton: estAdmin 
          ? FloatingActionButton(
              backgroundColor: AppColors.ensiCyan,
              child: const Icon(Icons.add, color: Colors.white),
              onPressed: _ouvrirModalAjout,
            )
          : null,

      body: _chargementEnCours
          ? const Center(child: CircularProgressIndicator())
          : CallbackShortcuts(
              bindings: {
                const SingleActivator(LogicalKeyboardKey.arrowDown): () => _changerSelectionClavier(1, _alumnisAffiches),
                const SingleActivator(LogicalKeyboardKey.arrowUp): () => _changerSelectionClavier(-1, _alumnisAffiches),
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
                                const Padding(padding: EdgeInsets.all(15)),
                                _boutonFiltre(),
                                const Padding(padding: EdgeInsets.all(15)),
                                if (_filtresOuverts) 
                                  Expanded(
                                    child: _construireFiltres()
                                  ),
                              ],
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                              const Text("Trouver un mentor", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 15),
                              
                              Row(
                                children: [
                                  Expanded(child: _champRecherche()),
                                  _boutonFiltre(),
                                ],
                              ),
                              
                              if (_filtresOuverts) ...[
                                const SizedBox(height: 15),
                                _construireFiltres(),
                              ]
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
                                        return _carteEleve(context, eleve, estGrandEcran);
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

  Widget _construireFiltres() {
    return ZoneFiltres(
      promosDisponibles: _promosDisponibles,
      promosSelectionnees: _filtresPromoSelectionnes,
      onPromoChanged: (promo, estCoche) {
        setState(() {
          estCoche ? _filtresPromoSelectionnes.add(promo) : _filtresPromoSelectionnes.remove(promo);
          _filtrerResultats(_searchController.text);
        });
      },
      filieresDisponibles: _filieresDisponibles,
      filieresSelectionnees: _filtresFiliereSelectionnes,
      onFiliereChanged: (filiere, estCoche) {
        setState(() {
          estCoche ? _filtresFiliereSelectionnes.add(filiere) : _filtresFiliereSelectionnes.remove(filiere);
          _filtrerResultats(_searchController.text);
        });
      },
      paysStageDisponibles: _paysStageDisponibles,
      paysStageSelectionnees: _filtresPaysStageSelectionnes,
      onPaysStageChanged: (pays, estCoche) {
        setState(() {
          estCoche ? _filtresPaysStageSelectionnes.add(pays) : _filtresPaysStageSelectionnes.remove(pays);
          _filtrerResultats(_searchController.text);
        });
      },
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

  Widget _carteEleve(BuildContext context, Alumnis eleve, bool estGrandEcran) {
    final estSelectionne = eleve == _eleveSelectionne;
    void ouvrirDetail() {
      if (estGrandEcran) {
        setState(() => _eleveSelectionne = eleve);
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => estAdmin
                ? AlumniDetailPageAdmin(alumni: eleve)
                : AlumniDetailPage(alumni: eleve, user: widget.user),
          ),
        ).then((resultat) {
            _chargerDonneesInitiales();
        });
      }
    }

    return Card(
      elevation: estSelectionne ? 5  : 2,
      color: estSelectionne ? const Color.fromARGB(255, 210, 210, 210).withOpacity(1) : Colors.white,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: estSelectionne ? const BorderSide(color: Color.fromARGB(255, 118, 118, 118), width: 0.5) : BorderSide.none,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: ouvrirDetail,
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
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
                        children: [
                          if (eleve.promo != 0)
                            TextSpan(
                              text: " - ${eleve.promo}",
                              style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.bold, fontSize: 14),
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
                onPressed: () {
                  if (!estGrandEcran) {
                     ouvrirDetail();
                  } else {
                     Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => estAdmin 
                             ? AlumniDetailPageAdmin(alumni: eleve) 
                             : AlumniDetailPage(alumni: eleve, user: widget.user),
                        ),
                      );
                  }
                },
                icon: const Icon(Icons.visibility, size: 18),
                label: const Text("Voir", style: TextStyle(fontSize: 12)),
              ),

              if (estAdmin) 
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _confirmerSuppression(eleve),
                ),
            ],
          ),
        ),
      ),
    );
    
  }

  Widget _vueParDefaut() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.touch_app, size: 80, color: Colors.grey),
        const SizedBox(height: 20),
        const Text("Sélectionnez un élève", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.grey)),
        const SizedBox(height: 10),
        Text("Utilisez les flèches ↑ ↓ de votre clavier", style: TextStyle(fontSize: 16, color: Colors.grey[600])),
      ],
    );
  }


  void _ouvrirModalAjout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Nouvel Alumni"),
        content: SizedBox(
          width: 500,
          child: AddAlumniForm(
            isAdmin: true,
            onSuccess: () {
              Navigator.pop(context);
              _chargerDonneesInitiales();
            },
          ),
        ),
      ),
    );
  }

  Future<void> _confirmerSuppression(Alumnis eleve) async {
    bool confirmation = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Supprimer ?"),
        content: Text("Veux-tu vraiment supprimer ${eleve.nomComplet} ?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Non")),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("Oui")),
        ],
      ),
    ) ?? false;

    if (confirmation) {
      await DatabaseService().supprimerEleve(eleve.nom, eleve.prenom);
      
      setState(() {
        _alumnisAffiches.removeWhere((e) => e.id == eleve.id);
        _tousLesAlumnis.removeWhere((e) => e.id == eleve.id);
        if (_eleveSelectionne?.id == eleve.id) {
          _eleveSelectionne = null;
        }
      });
      
      _chargerDonneesInitiales(); 
    }
  }

  void _afficherHistorique(BuildContext context) async {
    final logs = await DatabaseService().getHistorique();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(children: [Icon(Icons.history, color: AppColors.ensiCyan), SizedBox(width: 10), Text("Historique")]),
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
                        child: Icon(isDelete ? Icons.delete_forever : Icons.person_add, color: isDelete ? Colors.red : Colors.green, size: 20),
                      ),
                      title: Text("${log['prenom_alumni']} ${log['nom_alumni']}", style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text("${log['action']} le ${log['date_action']}"),
                    );
                  },
                ),
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("Fermer"))],
      ),
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
}