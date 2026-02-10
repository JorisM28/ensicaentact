import 'package:flutter/material.dart';
import 'package:flutter_application_ensicaentact/profileBadge.dart';
import 'colors.dart';
import 'alumnis.dart';
import 'database_service.dart';
import 'package:flutter/services.dart';

class AlumniDetailPage extends StatefulWidget {
  final Alumnis alumni;
  final Map<String, dynamic> user;
  final VoidCallback? onSave;

  const AlumniDetailPage({
    super.key,
    required this.alumni,
    required this.user,
    this.onSave,
  });

  @override
  State<AlumniDetailPage> createState() => _AlumniDetailPageState();
}

class StageEditor {
  TextEditingController intitule = TextEditingController();
  TextEditingController entreprise = TextEditingController();
  TextEditingController ville = TextEditingController();
  TextEditingController pays = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController annee = TextEditingController();
  TextEditingController debut = TextEditingController();
  TextEditingController fin = TextEditingController();
  String type = "E";

  void dispose() {
    intitule.dispose();
    entreprise.dispose();
    ville.dispose();
    pays.dispose();
    description.dispose();
    annee.dispose();
    debut.dispose();
    fin.dispose();
  }
}

class _AlumniDetailPageState extends State<AlumniDetailPage> {
  bool _enEdition = false;
  bool _modifiee = false;
  bool _voirDescription = false;

  late TextEditingController _nomCtrl;
  late TextEditingController _prenomCtrl;
  late TextEditingController _dateNaissanceCtrl;
  late TextEditingController _promoCtrl;
  late TextEditingController _posteCtrl;
  late TextEditingController _descriptionPosteCtrl;
  late TextEditingController _dateDebutPosteCtrl;
  late TextEditingController _entrepriseCtrl;
  late TextEditingController _villeCtrl;
  late TextEditingController _emailCtrl;
  late TextEditingController _telCtrl;
  late TextEditingController _filiereCtrl;
  late TextEditingController _majeureCtrl;
  late TextEditingController _optionCtrl;
  late TextEditingController _doublediplomeCtrl;

  String _sexeSelectionne = 'I';
  String _formationSelectionne = 'FISE';

  late bool _autorSwitch;
  late bool _decedeSwitch;

  late Alumnis currentAlumni;

  List<StageEditor> _stageEditors = [];
  List<Stage> _stagesAffichage = [];

  @override
  void initState() {
    super.initState();
    currentAlumni = widget.alumni;

    _nomCtrl = TextEditingController(text: currentAlumni.nom);
    _prenomCtrl = TextEditingController(text: currentAlumni.prenom);
    _dateNaissanceCtrl = TextEditingController(text: currentAlumni.dateNaissance);
    _promoCtrl = TextEditingController(text: currentAlumni.promo.toString());
    
    _posteCtrl = TextEditingController(text: currentAlumni.job);
    _descriptionPosteCtrl = TextEditingController(text: currentAlumni.jobDescription);
    _dateDebutPosteCtrl = TextEditingController(text: currentAlumni.jobDebut ?? "");
    _entrepriseCtrl = TextEditingController(text: currentAlumni.entreprise);
    
    _villeCtrl = TextEditingController(text: currentAlumni.ville);
    _emailCtrl = TextEditingController(text: currentAlumni.email);
    _telCtrl = TextEditingController(text: currentAlumni.tel);
    
    _filiereCtrl = TextEditingController(text: currentAlumni.filiere);
    _majeureCtrl = TextEditingController(text: currentAlumni.majeure);
    _optionCtrl = TextEditingController(text: currentAlumni.option);
    _doublediplomeCtrl = TextEditingController(text: currentAlumni.ddiplome);

    _sexeSelectionne = ['M', 'F', 'I'].contains(currentAlumni.sexe) ? currentAlumni.sexe : 'I';
    _formationSelectionne = ['FISE', 'FISA', 'MTS'].contains(currentAlumni.formation) ? currentAlumni.formation : 'FISE';

    _autorSwitch = currentAlumni.autor == 1;
    _decedeSwitch = currentAlumni.decede == 1;

    _stagesAffichage = List.from(currentAlumni.stages);
    _initialiserStageEditors();
  }

  void _initialiserStageEditors() {
    for (var editor in _stageEditors) editor.dispose();
    _stageEditors.clear();

    for (var stage in _stagesAffichage) {
      var editor = StageEditor();
      editor.intitule.text = stage.intitule;
      editor.entreprise.text = stage.entreprise;
      editor.ville.text = stage.ville;
      editor.pays.text = stage.pays;
      editor.description.text = stage.description;
      editor.annee.text = stage.annee;
      editor.type = stage.type;
      editor.debut.text = stage.dateDebut;
      editor.fin.text = stage.dateFin;  
      _stageEditors.add(editor);
    }
  }

  @override
  void dispose() {
    _nomCtrl.dispose(); 
    _prenomCtrl.dispose(); 
    _dateNaissanceCtrl.dispose();
    _promoCtrl.dispose(); 
    _posteCtrl.dispose(); 
    _descriptionPosteCtrl.dispose(); 
    _dateDebutPosteCtrl.dispose();
    _entrepriseCtrl.dispose(); 
    _villeCtrl.dispose(); 
    _emailCtrl.dispose(); _telCtrl.dispose();
    _filiereCtrl.dispose()
    ; _majeureCtrl.dispose(); 
    _optionCtrl.dispose(); 
    _doublediplomeCtrl.dispose();
    for (var editor in _stageEditors) editor.dispose();
    super.dispose();
  }

  Future<void> _selectionnerDate(BuildContext context, TextEditingController controller) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime(2100),
      locale: const Locale("fr", "FR"),
    );
    if (picked != null) {
      setState(() {
        controller.text = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  String _calculerAge(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return "";
    try {
      DateTime dn = DateTime.parse(dateStr);
      DateTime now = DateTime.now();
      int age = now.year - dn.year;
      if (now.month < dn.month || (now.month == dn.month && now.day < dn.day)) {
        age--;
      }
      return "$age ans";
    } catch (e) {
      return "";
    }
  }

  String _calculerAnciennete(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return "";
    try {
      DateTime start = DateTime.parse(dateStr);
      DateTime now = DateTime.now();
      int months = (now.year - start.year) * 12 + now.month - start.month;
      if (months < 1) return "Moins d'un mois";
      if (months < 12) return "$months mois";
      int years = months ~/ 12;
      int restMonths = months % 12;
      return restMonths > 0 ? "$years ans et $restMonths mois" : "$years ans";
    } catch (e) {
      return "";
    }
  }

  void _ajouterStage() {
    setState(() {
      _stageEditors.add(StageEditor());
    });
  }

  void _supprimerStage(int index) {
    setState(() {
      _stageEditors[index].dispose();
      _stageEditors.removeAt(index);
    });
  }

  void _sauvegarder() async {
    int promoInt = int.tryParse(_promoCtrl.text) ?? currentAlumni.promo;
    int autorInt = _autorSwitch ? 1 : 0;
    int decedeInt = _decedeSwitch ? 1 : 0;

List<Map<String, dynamic>> stagesData = _stageEditors.map((editor) {
  return {
        "intitule": editor.intitule.text.trim(),
        "entreprise": editor.entreprise.text.trim(),
        "ville": editor.ville.text.trim(),
        "pays": editor.pays.text.trim(),
        "description": editor.description.text.trim(),
        "annee": editor.annee.text.trim(),
        "type": editor.type.trim(),
        "debut": editor.debut.text.trim(),
        "fin": editor.fin.text.trim(),
      };
    }).toList();

    Map<String, dynamic> updateData = {
      "id": widget.alumni.id,
      "nom": _nomCtrl.text.trim(),
      "prenom": _prenomCtrl.text.trim(),
      "dateNaissance": _dateNaissanceCtrl.text.trim(),
      "sexe": _sexeSelectionne,
      "promo": promoInt,
      "filiere": _filiereCtrl.text.trim(),
      "formation": _formationSelectionne,
      "majeure": _majeureCtrl.text.trim(),
      "option": _optionCtrl.text.trim(),
      "diplome": _doublediplomeCtrl.text.trim(),
      "autor": autorInt,
      "decede": decedeInt,
      "poste": _posteCtrl.text.trim(),
      "description": _descriptionPosteCtrl.text.trim(),
      "debut": _dateDebutPosteCtrl.text.trim(),
      "entreprise": _entrepriseCtrl.text.trim(),
      "ville": _villeCtrl.text.trim(),
      "email": _emailCtrl.text.trim(),
      "tel": _telCtrl.text.trim(),
      "stages": stagesData,
    };

    await DatabaseService().modifierEleve(updateData);

    if (widget.onSave != null) {
      widget.onSave!();
    }

    if (!mounted) return;

    setState(() {
      _stagesAffichage = _stageEditors.map((editor) {
        return Stage(
          intitule: editor.intitule.text,
          entreprise: editor.entreprise.text,
          ville: editor.ville.text,
          pays: editor.pays.text,
          description: editor.description.text,
          annee: editor.annee.text,
          type: editor.type,
          dateDebut: editor.debut.text,
          dateFin: editor.fin.text,
        );
      }).toList();

      currentAlumni = Alumnis(
        id: widget.alumni.id,
        nom: _nomCtrl.text.trim(),
        prenom: _prenomCtrl.text.trim(),
        email: _emailCtrl.text.trim(),
        tel: _telCtrl.text.trim(),
        autor: autorInt,
        decede: decedeInt,
        sexe: _sexeSelectionne,
        dateNaissance: _dateNaissanceCtrl.text.trim(),
        promo: promoInt,
        filiere: _filiereCtrl.text.trim(),
        formation: _formationSelectionne,
        majeure: _majeureCtrl.text.trim(),
        option: _optionCtrl.text.trim(),
        ddiplome: _doublediplomeCtrl.text.trim(),
        job: _posteCtrl.text.trim(),
        jobDescription: _descriptionPosteCtrl.text.trim(),
        jobDebut: _dateDebutPosteCtrl.text.trim(),
        jobFin: "",
        entreprise: _entrepriseCtrl.text.trim(),
        ville: _villeCtrl.text.trim(),
        pays: "",
        stages: _stagesAffichage,
      );

      _enEdition = false;
      _modifiee = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Profil mis à jour avec succès !"),
        backgroundColor: Colors.green,
      ),
    );
  }  

@override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool estGrand = screenWidth > 800;
    
    double horizontalPadding = 40.0;
    double spacing = 10.0;
    
    int stageCount = _stagesAffichage.length;
    
    int divisor = stageCount > 0 ? stageCount : 1;
    if (divisor > 3) divisor = 3;
    
    double cardWidth = (screenWidth - horizontalPadding - (spacing * (divisor - 1))) / divisor;

    bool estAdmin = widget.user['role'] == 'admin';

    List<Widget> etuItems = [
      if (currentAlumni.filiere.isNotEmpty || _enEdition)...[
              _buildEditableTile(Icons.school, Colors.orange, "Filière", _filiereCtrl, currentAlumni.filiere),
              const Divider(height: 1),
      ],
      if (_enEdition || currentAlumni.majeure.isNotEmpty || currentAlumni.option.isNotEmpty || currentAlumni.ddiplome.isNotEmpty) ...[
         if (_enEdition) ...[
            _buildEditableTile(Icons.book, Colors.redAccent, "Majeure", _majeureCtrl, currentAlumni.majeure),
            const Divider(height: 1),
            _buildEditableTile(Icons.bookmark, Colors.pinkAccent, "Option", _optionCtrl, currentAlumni.option),
            const Divider(height: 1),
            _buildEditableTile(Icons.workspace_premium, Colors.purple, "Double Diplôme", _doublediplomeCtrl, currentAlumni.ddiplome),
         ] else ...[
            if (currentAlumni.majeure.isNotEmpty)...[
              _buildEditableTile(Icons.book, Colors.redAccent, "Majeure", _majeureCtrl, currentAlumni.majeure),
              const Divider(height: 1),
            ],
            if (currentAlumni.option.isNotEmpty)...[
              _buildEditableTile(Icons.bookmark, Colors.pinkAccent, "Option", _optionCtrl, currentAlumni.option),
              const Divider(height: 1),
            ],
            if (currentAlumni.ddiplome.isNotEmpty)...[
              _buildEditableTile(Icons.workspace_premium, Colors.purple, "Double Diplôme", _doublediplomeCtrl, currentAlumni.ddiplome),
            ],
         ],
      ],
    ];

    List<Widget> proItems = [
      if (_enEdition) ...[
        _buildEditableTile(Icons.work, Colors.blue, "Poste", _posteCtrl, currentAlumni.job),
        const SizedBox(height: 10),
        _buildEditableTile(Icons.description, Colors.grey, "Description du poste", _descriptionPosteCtrl, currentAlumni.jobDescription),
        const Divider(height: 1),
      ] 
      else if (currentAlumni.job.isNotEmpty) ...[
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          leading: const Icon(Icons.work, color: Colors.blue, size: 24),
          title: const Text("Poste", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey)),
          subtitle: Text(
            currentAlumni.job,
            style: const TextStyle(fontSize: 16, color: Colors.black87),
          ),
          trailing: currentAlumni.jobDescription.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    _voirDescription ? Icons.remove_circle_outline : Icons.add_circle_outline,
                    color: AppColors.ensiCyan,
                  ),
                  onPressed: () {
                    setState(() {
                      _voirDescription = !_voirDescription;
                    });
                  },
                )
              : null,
        ),
        if (_voirDescription && currentAlumni.jobDescription.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 15),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                border: Border(left: BorderSide(color: AppColors.ensiCyan, width: 3)),
              ),
              child: Text(
                currentAlumni.jobDescription,
                style: const TextStyle(fontStyle: FontStyle.italic, color: Colors.black87),
              ),
            ),
          ),
        const Divider(height: 1),
      ],
      
      if (currentAlumni.ville.isNotEmpty)...[
        _buildEditableTile(Icons.location_on, Colors.red, "Ville", _villeCtrl, currentAlumni.ville),
        const Divider(height: 1),
      ],
      if (currentAlumni.entreprise.isNotEmpty || _enEdition)...[
        _buildEditableTile(Icons.business, Colors.indigo, "Entreprise", _entrepriseCtrl, currentAlumni.entreprise),
        const Divider(height: 1),
        if (!_enEdition && _dateDebutPosteCtrl.text.isNotEmpty) ...[
          ListTile(
            leading: Icon(Icons.timer, color: Colors.teal),
            title: Text("Ancienneté"),
            subtitle: Text("${_dateDebutPosteCtrl.text} (${_calculerAnciennete(_dateDebutPosteCtrl.text)})"),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          ),
        ]
        else if (_enEdition)
           Padding(
             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
             child: TextFormField(
                controller: _dateDebutPosteCtrl,
                decoration: const InputDecoration(
                  labelText: "Date de début (Poste)", 
                  border: OutlineInputBorder(), 
                  prefixIcon: Icon(Icons.calendar_today)
                ),
                readOnly: true,
                onTap: () => _selectionnerDate(context, _dateDebutPosteCtrl),
             ),
           ),
      ],
    ];
    
    if (proItems.isEmpty) proItems.add(Text("Aucune information renseignée"));


    List<Widget> contactItems = [
      if (_enEdition || (currentAlumni.autor == 1 && currentAlumni.decede == 0)) ...[
        const Divider(height: 1),
        if (currentAlumni.email.isNotEmpty)...[
        _buildEditableTile(Icons.email, Colors.green, "Email", _emailCtrl, currentAlumni.email),
        const Divider(height: 1),
        ],
        if (currentAlumni.tel.isNotEmpty)...[
        _buildEditableTile(Icons.phone, Colors.amber, "Téléphone", _telCtrl, currentAlumni.tel),
        ],
      ],
    ];
    if (contactItems.isEmpty) contactItems.add(Text("Aucune information renseignée"));

    bool modeLigne = MediaQuery.of(context).size.width > 600 && currentAlumni.email.isNotEmpty && currentAlumni.tel.isNotEmpty;
    return Scaffold(
      appBar: AppBar(
        title: Text(_enEdition ? "Modifier Alumni" : "${currentAlumni.prenom} ${currentAlumni.nom}"),
        backgroundColor: AppColors.ensiCyan,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context, _modifiee),
        ),
        actions: [
          if (estAdmin)
            IconButton(
              icon: Icon(_enEdition ? Icons.save : Icons.edit),
              tooltip: _enEdition ? "Enregistrer" : "Modifier",
              onPressed: () {
                if (_enEdition) {
                  _sauvegarder();
                } else {
                  setState(() {
                    _enEdition = true;
                    _initialiserStageEditors();
                  });
                }
              },
            ),
            ProfileBadge(user: widget.user),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 50,
              backgroundColor: AppColors.ensiCyan,
              child: Text(
                currentAlumni.prenom.isNotEmpty ? currentAlumni.prenom[0] : "?",
                style: const TextStyle(fontSize: 40, color: Colors.white),
              ),
            ),
            const SizedBox(height: 10),

            if (_enEdition) ...[
              Row(
                children: [
                  Expanded(child: TextField(controller: _prenomCtrl, decoration: const InputDecoration(labelText: "Prénom", border: OutlineInputBorder()))),
                  const SizedBox(width: 10),
                  Expanded(child: TextField(controller: _nomCtrl, decoration: const InputDecoration(labelText: "Nom", border: OutlineInputBorder()))),
                ],
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _promoCtrl,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(labelText: "Promo (Année)", border: OutlineInputBorder()),
              ),
              const SizedBox(height: 10),
             TextFormField(
                controller: _dateNaissanceCtrl,
                decoration: const InputDecoration(labelText: "Date de Naissance", border: OutlineInputBorder(), prefixIcon: Icon(Icons.cake)),
                readOnly: true,
                onTap: () => _selectionnerDate(context, _dateNaissanceCtrl),
              ),
              const Divider(height: 40),
              Card(
                color: Colors.grey[100],
                elevation: 0,
                margin: const EdgeInsets.only(bottom: 20),
                child: Column(
                  children: [
                    const Padding(padding: EdgeInsets.all(8.0), child: Text("Statut Administrateur", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54))),
                    SwitchListTile(title: const Text("Autorisation des données"), subtitle: Text(_autorSwitch ? "Visible" : "Caché"), activeColor: Colors.green, value: _autorSwitch, onChanged: (val) => setState(() => _autorSwitch = val)),
                    const Divider(height: 1),
                    SwitchListTile(title: const Text("Décédé"), subtitle: const Text("Marquer comme décédé"), activeColor: Colors.red, value: _decedeSwitch, onChanged: (val) => setState(() => _decedeSwitch = val)),
                  ],
                ),
              ),
              const Divider(height: 20),
            ] else ...[
              Text("${currentAlumni.prenom} ${currentAlumni.nom}", style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
              Text("Promo ${currentAlumni.promo}", style: const TextStyle(fontSize: 20, color: Colors.grey)),
              if (currentAlumni.dateNaissance.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text("${_calculerAge(currentAlumni.dateNaissance)}", style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic)),
                ),
              const Divider(height: 40),
            ],

            if (estGrand)...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildInfoCard(title: "Infos Pro", items: proItems)),
                  const SizedBox(width: 20),
                  Expanded(child: _buildInfoCard(title: "Etudes", items: etuItems)),
                ],
              ),
            ] else ...[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoCard(title: "Infos Pro", items: proItems),
                  const SizedBox(height: 20),
                  _buildInfoCard(title: "Etudes", items: etuItems),
                ],
              ),
            ],
              
              if (_enEdition || (currentAlumni.autor == 1 && currentAlumni.decede == 0)) ...[
              Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text("Contact", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      ),
                      
                      // Si on a assez de place ET les 2 infos : LIGNE
                      if (modeLigne) 
                        Row(
                          children: [
                            Expanded(
                              child: _buildEditableTile(Icons.email, Colors.green, "Email", _emailCtrl, currentAlumni.email),
                            ),
                            // Petit trait de séparation vertical optionnel
                            Container(width: 1, height: 40, color: Colors.grey[300]),
                            Expanded(
                              child: _buildEditableTile(Icons.phone, Colors.amber, "Téléphone", _telCtrl, currentAlumni.tel),
                            ),
                          ],
                        )
                      else 
                        Column(
                          children: [
                            if (currentAlumni.email.isNotEmpty || _enEdition)
                              _buildEditableTile(Icons.email, Colors.green, "Email", _emailCtrl, currentAlumni.email),
                              
                            if ((currentAlumni.email.isNotEmpty || _enEdition) && (currentAlumni.tel.isNotEmpty || _enEdition))
                              const Divider(indent: 20, endIndent: 20, height: 1),
                              
                            if (currentAlumni.tel.isNotEmpty || _enEdition)
                              _buildEditableTile(Icons.phone, Colors.amber, "Téléphone", _telCtrl, currentAlumni.tel),
                          ],
                        ),
                        
                        if (currentAlumni.email.isEmpty && currentAlumni.tel.isEmpty && !_enEdition)
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("Aucune coordonnée renseignée", style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey)),
                          )
                    ],
                  ),
                ),
              ),
            ] else ...[
              const Card(
                elevation: 1,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(
                    child: Text(
                      "Coordonnées masquées par l'Alumni", 
                      style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey)
                    ),
                  ),
                ),
              ),
            ],  
            const SizedBox(height: 30),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
                  child: Text("Stages", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                ),
                if (_enEdition)
                  ElevatedButton.icon(
                    onPressed: _ajouterStage,
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text("Ajouter Stage"),
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.ensiCyan, foregroundColor: Colors.white),
                  )
              ],
            ),

            if (_enEdition)
              Column(
                children: _stageEditors.asMap().entries.map((entry) {
                  int index = entry.key;
                  StageEditor editor = entry.value;
                  return Card(
                    margin: const EdgeInsets.only(bottom: 15),
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Stage #${index + 1}", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                              IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => _supprimerStage(index)),
                            ],
                          ),
                          Row(children: [
                             Expanded(
                              child: DropdownButtonFormField<String>(
                                value: ['1A', '2A', '3A'].contains(editor.annee.text) 
                                    ? editor.annee.text 
                                    : null,
                                    
                                decoration: const InputDecoration(labelText: "Année", border: OutlineInputBorder()),
                                
                                items: const [
                                  DropdownMenuItem(value: '1A', child: Text("1A")), 
                                  DropdownMenuItem(value: '2A', child: Text("2A")), 
                                  DropdownMenuItem(value: '3A', child: Text("3A"))
                                ],
                                
                                onChanged: (v) { if (v != null) { setState(() { editor.annee.text = v; });}},
                              ),
                            ),
                             const SizedBox(width: 10),
                             Expanded(child: DropdownButtonFormField<String>(
                               value: editor.type,
                               decoration: const InputDecoration(labelText: "Type", border: OutlineInputBorder()),
                               items: const [DropdownMenuItem(value: 'E', child: Text("Entreprise")), DropdownMenuItem(value: 'U', child: Text("Université"))],
                               onChanged: (v) => setState(() => editor.type = v!),
                             )),
                          ]),
                          const SizedBox(height: 10),
                          TextField(controller: editor.intitule, decoration: const InputDecoration(labelText: "Intitulé", border: OutlineInputBorder())),
                          const SizedBox(height: 10),
                          TextField(controller: editor.entreprise, decoration: const InputDecoration(labelText: "Entreprise", border: OutlineInputBorder())),
                          const SizedBox(height: 10),
                          Row(children: [
                            Expanded(child: TextField(controller: editor.ville, decoration: const InputDecoration(labelText: "Ville", border: OutlineInputBorder()))),
                            const SizedBox(width: 10),
                            Expanded(child: TextField(controller: editor.pays, decoration: const InputDecoration(labelText: "Pays", border: OutlineInputBorder()))),
                          ]),
                          const SizedBox(height: 10),
                          TextField(controller: editor.description, maxLines: 3, decoration: const InputDecoration(labelText: "Description", border: OutlineInputBorder())),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              )
            else
              _stagesAffichage.isEmpty
                  ? const Card(
                      elevation: 1,
                      child: ListTile(title: Text("Aucun stage renseigné", style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey))),
                    )
                  : estGrand
                      ? SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: IntrinsicHeight(
                            child: Row(
                              children: _stagesAffichage.map((stage) {
                                return _buildStageCard(stage, cardWidth, spacing, _stagesAffichage.last == stage);
                              }).toList(),
                            ),
                          ),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: _stagesAffichage.map((stage) {
                            return _buildStageCard(stage, cardWidth, spacing, _stagesAffichage.last == stage);
                          }).toList(),
                        ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({required String title, required List<Widget> items}) {
    return Card(
      elevation: 2,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
          ...items,
        ],
      ),
    );
  }

  Widget _buildEditableTile(IconData icon, Color color, String title, TextEditingController controller, String currentValue) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      leading: Icon(icon, color: color, size: 24),
      title: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey)),
      subtitle: _enEdition
          ? TextField(
              controller: controller,
              decoration: const InputDecoration(
                isDense: true,
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.all(8),
              ),
            )
          : Text(
              currentValue,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
    );
  }

  Widget _buildStageCard(dynamic stage, double width, double spacing, bool isLast) {
    return Container(
      width: width,
      margin: EdgeInsets.only(right: isLast ? 0 : spacing, bottom: 10),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    stage.type == "E" ? Icons.apartment : Icons.school,
                    color: AppColors.ensiCyan,
                    size: 18,
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      "${stage.annee} - ${stage.intitule}",
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const Divider(),
              _buildStageField(stage.type == "U" ? "Université" : "Entreprise", stage.type == "E" ? Icons.apartment : Icons.school, Colors.green, stage.entreprise),
              _buildStageField("Lieu", Icons.location_on, Colors.red, "${stage.ville}, ${stage.pays}", isItalic: true),
              if (stage.dateDebut.isNotEmpty || stage.dateFin.isNotEmpty)
              _buildStageField("Période",Icons.calendar_today , Colors.blue, "${stage.dateDebut} au ${stage.dateFin}"),
              _buildStageField("Description", Icons.insert_drive_file, Colors.grey, stage.description),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStageField(String label, IconData icon, Color color, String value, {bool isItalic = false}) {
    if (value.isEmpty || value == ", ") return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 14),
              const SizedBox(width: 4),
              Text(label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.ensiCyan)),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 18.0),
            child: Text(
              value,
              style: TextStyle(
                fontSize: 15,
                fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
              ),
              maxLines: 10,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}