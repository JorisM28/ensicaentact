import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../common/profile_badge.dart';
import '../../../Model/core/theme/colors.dart';
import '../../../Model/data/alumnis.dart';
import '../../../Model/data/services/database_service.dart';
import '../../common/filtre_widget.dart';
import 'alumni_detail_page.dart';
import '../admin/admin_validate_page.dart';
import 'alumni_preview.dart';
import 'add_alumni.dart';
import '../../navigation.dart';

void main() {
  runApp(const MyAlumniNetwork());
}

class MyAlumniNetwork extends StatelessWidget {
  const MyAlumniNetwork({super.key});

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
      home: const DirectoryPage(user: userConnecte),
    );
  }
}

class DirectoryPage extends StatefulWidget {
  final Map<String, dynamic> user;

  const DirectoryPage({
    super.key,
    required this.user, 
  });

  @override
  State<DirectoryPage> createState() => _DirectoryPageState();
}

class _DirectoryPageState extends State<DirectoryPage> with RouteAware{
  Alumnis? _selectedStudent;
  final ScrollController _scrollController = ScrollController();
  List<Alumnis> _allAlumni = [];
  List<Alumnis> _alumniPoster = [];
  bool _openFilters = false;
  int _numberWaitingRequest = 0;
  
  final Set<String> _promotionFilterSelected = {};
  final Set<String> _sectorFilterSelected = {};
  final Set<String> _internshipCountryFilterSelected = {};
  
  bool _loading = true;
  final TextEditingController _searchController = TextEditingController();

  bool get isAdmin => widget.user['role'] == 'admin';
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
    _loadInitialData();
    if (widget.user['role'] == 'admin' || isAdmin) { 
      _loadCounterNotifications();
    }
  }
  @override
void didPopNext() {
  _loadInitialData();
}

  List<String> get _promotionavailable {
    final promos = _allAlumni
        .map((e) => e.promotion.toString())
        .where((e) => e != "0" && e.isNotEmpty)
        .toSet()
        .toList();
    promos.sort();
    return promos;
  }

  Future<void> _loadCounterNotifications() async {
    try {
      var request = await DatabaseService().getWaitingRequests();
      if (mounted) {
        setState(() {
          _numberWaitingRequest = request.length;
        });
      }
    } catch (e) {
      print("Erreur chargement notifs: $e");
    }
  }

  List<String> get _sectorAvailable {
    final sector = _allAlumni
        .map((e) => e.sector)
        .where((e) => e.isNotEmpty)
        .toSet()
        .toList();
    sector.sort();
    return sector;
  }

  
  List<String> get _internshipCountryAvailable {
    final Set<String> foundCountry = {};
    for (var alumni in _allAlumni) {
      for (var internship in alumni.internships) {
        if (internship.country.isNotEmpty && internship.country != "Non renseigné") {
          foundCountry.add(internship.country);
        }
      }
    }
    final sortedList = foundCountry.toList();
    sortedList.sort();
    return sortedList;
  }

  void _loadInitialData() async {
    print("rechargement de la page");
    try {
        var data = await DatabaseService().getAllStudent();
      
      if (!mounted) return;

      setState(() {
        _allAlumni = data;
        _alumniPoster = data;
        _loading = false;
        
        if (_searchController.text.isNotEmpty || 
            _promotionFilterSelected.isNotEmpty || 
            _sectorFilterSelected.isNotEmpty ||
            _internshipCountryFilterSelected.isNotEmpty) {
            
            _filterResults(_searchController.text); 
        }
      });
    } catch (e) {
      print("Erreur de chargement : $e");
      if (mounted) setState(() => _loading = false);
    }
  }

  void _filterResults(String recherche) {
  
    List<Alumnis> results = _allAlumni;

    if (recherche.isNotEmpty) {
      results = results.where((eleve) {
        final nameLower = eleve.wholeName.toLowerCase();
        final jobLower = eleve.job.toLowerCase();
        final companyLower = eleve.company.toLowerCase();
        final queryLower = recherche.toLowerCase();
        return nameLower.contains(queryLower) ||
            jobLower.contains(queryLower) ||
            companyLower.contains(queryLower);
      }).toList();
    }

    if (_promotionFilterSelected.isNotEmpty) {
      results = results.where((e) => _promotionFilterSelected.contains(e.promotion.toString())).toList();
    }
    if (_sectorFilterSelected.isNotEmpty) {
      results = results.where((e) => _sectorFilterSelected.contains(e.sector)).toList();
    }
    if (_internshipCountryFilterSelected.isNotEmpty) {
      results = results.where((eleve) {
        for (var stage in eleve.internships) {
          if (_internshipCountryFilterSelected.contains(stage.country)) return true;
        }
        return false;
      }).toList();
    }

    setState(() {
      _alumniPoster = results;
      if (_selectedStudent != null && !results.contains(_selectedStudent)) {
        _selectedStudent = null;
      }
    });
  }

  Widget _filterButton() {
  return Container(
    margin: const EdgeInsets.only(left: 10),
    decoration: BoxDecoration(
      color: _openFilters ? AppColors.ensiCyan : Colors.white,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: Colors.grey.shade300),
    ),
    child: IconButton(
      icon: Icon(
        _openFilters ? Icons.filter_list_off : Icons.filter_list,
        color: _openFilters ? Colors.white : Colors.grey[700],
      ),
      tooltip: _openFilters ? "Masquer les filtres" : "Afficher les filtres",
      onPressed: () {
        setState(() {
          _openFilters = !_openFilters;
        });
      },
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isWideScreen = screenWidth > 800;

    return Scaffold(
      appBar: AppBar(
        title: Text("ENSIcaentact ("+widget.user['role']+')'),
        backgroundColor: AppColors.ensiCyan,
        foregroundColor: Colors.white,
        actions: [
          if (isAdmin)
            IconButton(
              icon: const Icon(Icons.history),
              tooltip: "Historique des actions",
              onPressed: () => _displayHistory(context),
            ),
          ProfileBadge(user: widget.user),
        ],
      ),
      floatingActionButton: isAdmin 
          ? Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FloatingActionButton(
                  heroTag: "btn_validation",
                  backgroundColor: Colors.orange,
                  tooltip: "Voir les demandes en attente",
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AdminValidationPage()),
                    ).then((_) {
                      
                      _loadCounterNotifications();
                    });
                  },
                  
                  child: Badge(
                    label: Text('$_numberWaitingRequest'), 
                    isLabelVisible: _numberWaitingRequest > 0, 
                    backgroundColor: Colors.red, 
                    textColor: Colors.white,
                    child: const Icon(Icons.playlist_add_check, color: Colors.white),
                  ),
                ),
                
                const SizedBox(width: 15),

                FloatingActionButton(
                  heroTag: "btn_ajout_direct",
                  backgroundColor: AppColors.ensiCyan,
                  tooltip: "Ajouter un alumni directement",
                  onPressed: _openAddModal,
                  child: const Icon(Icons.add, color: Colors.white),
                ),
              ],
            ) 
          : null,

      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : CallbackShortcuts(
              bindings: {
                const SingleActivator(LogicalKeyboardKey.arrowDown): () => _changeKeyboardSelection(1, _alumniPoster),
                const SingleActivator(LogicalKeyboardKey.arrowUp): () => _changeKeyboardSelection(-1, _alumniPoster),
              },
              child: Focus(
                autofocus: true,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      color: Colors.grey[100],
                      child: isWideScreen
                          ? Row(
                              children: [
                                SizedBox(width: 400, child: _searchScope()),
                                const Padding(padding: EdgeInsets.all(15)),
                                _filterButton(),
                                const Padding(padding: EdgeInsets.all(15)),
                                if (_openFilters) 
                                  Expanded(
                                    child: _buildFilters()
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
                                  Expanded(child: _searchScope()),
                                  _filterButton(),
                                ],
                              ),
                              
                              if (_openFilters) ...[
                                const SizedBox(height: 15),
                                _buildFilters(),
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
                              child: _alumniPoster.isEmpty
                                  ? const Center(child: Text("Aucun résultat"))
                                  : ListView.builder(
                                      controller: _scrollController,
                                      itemCount: _alumniPoster.length,
                                      padding: const EdgeInsets.all(10),
                                      itemBuilder: (context, index) {
                                        final eleve = _alumniPoster[index];
                                        return _studentCard(context, eleve, isWideScreen);
                                      },
                                    ),
                            ),
                          ),
                          if (isWideScreen) ...[
                            const VerticalDivider(width: 1),
                            Expanded(
                              flex: 2,
                              child: _selectedStudent == null
                                  ? _defaultView()
                                  : AlumniPreview(alumni: _selectedStudent!, user: widget.user), 
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

  Widget _buildFilters() {
    return ZoneFiltres(
      promotionAvailable: _promotionavailable,
      selectedPromotion: _promotionFilterSelected,
      onPromoChanged: (promo, isTicked) {
        setState(() {
          isTicked ? _promotionFilterSelected.add(promo) : _promotionFilterSelected.remove(promo);
          _filterResults(_searchController.text);
        });
      },
      sectorAvailable: _sectorAvailable,
      sectorFilterSelected: _sectorFilterSelected,
      onSectorChanged: (filiere, isTicked) {
        setState(() {
          isTicked ? _sectorFilterSelected.add(filiere) : _sectorFilterSelected.remove(filiere);
          _filterResults(_searchController.text);
        });
      },
      internshipCountryAvailable: _internshipCountryAvailable,
      internshipCountryFilterSelected: _internshipCountryFilterSelected,
      onInternshipCountryChanged: (pays, isTicked) {
        setState(() {
          isTicked ? _internshipCountryFilterSelected.add(pays) : _internshipCountryFilterSelected.remove(pays);
          _filterResults(_searchController.text);
        });
      },
    );
  }

  Widget _searchScope() {
    return TextField(
      controller: _searchController,
      onChanged: (value) => _filterResults(value),
      decoration: InputDecoration(
        hintText: "Recherche...",
        prefixIcon: const Icon(Icons.search),
        suffixIcon: _searchController.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _searchController.clear();
                  _filterResults('');
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

  Widget _studentCard(BuildContext context, Alumnis Student, bool isWideScreen) {
    final IsSelected = Student == _selectedStudent;
    void openDetail() {
      if (isWideScreen) {
        setState(() => _selectedStudent = Student);
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>AlumniDetailPage(alumni: Student, user: widget.user,
            onSave: () {setState(() {}); 
            }, ),
          ),
        ).then((resultat) {
            _loadInitialData();
        });
      }
    }

    return Card(
      elevation: IsSelected ? 5  : 2,
      color: IsSelected ? const Color.fromARGB(255, 210, 210, 210).withOpacity(1) : Colors.white,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: IsSelected ? const BorderSide(color: Color.fromARGB(255, 118, 118, 118), width: 0.5) : BorderSide.none,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: openDetail,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: AppColors.ensiCyan,
                radius: 30,
                child: Text(
                  Student.firstname.isNotEmpty ? Student.firstname[0] : "?",
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
                        text: Student.wholeName,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
                        children: [
                          if (Student.promotion != 0)
                            TextSpan(
                              text: " - ${Student.promotion}",
                              style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                        ],
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                      if (Student.job.isNotEmpty || Student.company.isNotEmpty)...[
                    Text("${Student.job} ${Student.company.isEmpty || Student.job.isEmpty  ? "" : "⟶"} ${Student.company}", style: TextStyle(color: Colors.grey[800])),
                    ],  
                    const SizedBox(height: 5),
                    Wrap(
                      spacing: 5,
                      children: [
                        if (Student.sector.isNotEmpty)
                        Chip(label: Text(Student.sector, style: const TextStyle(fontSize: 10)), backgroundColor: Colors.blue[50]),
                        if (Student.city.isNotEmpty)
                        Chip(avatar: const Icon(Icons.location_on, size: 14), label: Text(Student.city, style: const TextStyle(fontSize: 10)), backgroundColor: Colors.orange[50]),
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
                  if (!isWideScreen) {
                     openDetail();
                  } else {
                     Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>AlumniDetailPage(alumni: Student, user: widget.user, 
                          onSave: () {setState(() {}); 
                          },),
                        ),
                      );
                  }
                },
                icon: const Icon(Icons.visibility, size: 18),
                label: const Text("Voir", style: TextStyle(fontSize: 12)),
              ),

              if (isAdmin) 
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteComfirm(Student),
                ),
            ],
          ),
        ),
      ),
    );
    
  }

  Widget _defaultView() {
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


  void _openAddModal() {
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
              _loadInitialData();
            },
          ),
        ),
      ),
    );
  }

  Future<void> _deleteComfirm(Alumnis student) async {
    bool comfirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Supprimer ?"),
        content: Text("Veux-tu vraiment supprimer ${student.wholeName} ?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Non")),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("Oui")),
        ],
      ),
    ) ?? false;

    if (comfirm) {
      await DatabaseService().deleteStudents(student.lastName, student.firstname);
      
      setState(() {
        _alumniPoster.removeWhere((e) => e.id == student.id);
        _allAlumni.removeWhere((e) => e.id == student.id);
        if (_selectedStudent?.id == student.id) {
          _selectedStudent = null;
        }
      });
      
      _loadInitialData(); 
    }
  }

  void _displayHistory(BuildContext context) async {
    final logs = await DatabaseService().getHistory();
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

  void _changeKeyboardSelection(int direction, List<Alumnis> liste) {
    if (liste.isEmpty) return;
    if (_selectedStudent == null) {
      setState(() => _selectedStudent = liste.first);
      return;
    }
    int indexActuel = liste.indexOf(_selectedStudent!);
    if (indexActuel == -1) {
      setState(() => _selectedStudent = liste.first);
      return;
    }
    int nouvelIndex = indexActuel + direction;
    if (nouvelIndex >= 0 && nouvelIndex < liste.length) {
      setState(() => _selectedStudent = liste[nouvelIndex]);
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