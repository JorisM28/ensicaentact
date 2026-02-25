import 'package:flutter/material.dart';
import 'package:flutter_application_ensicaentact/profil_badge.dart';
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
  String type = "E";

  void dispose() {
    intitule.dispose();
    entreprise.dispose();
    ville.dispose();
    pays.dispose();
    description.dispose();
    annee.dispose();
  }
}

class _AlumniDetailPageState extends State<AlumniDetailPage> {
  bool _enEdition = false;
  bool _modifiee = false;

  late TextEditingController _nomCtrl;
  late TextEditingController _prenomCtrl;
  late TextEditingController _promoCtrl;
  late TextEditingController _posteCtrl;
  late TextEditingController _entrepriseCtrl;
  late TextEditingController _villeCtrl;
  late TextEditingController _emailCtrl;
  late TextEditingController _telCtrl;
  late TextEditingController _filiereCtrl;

  late bool _autorSwitch;
  late bool _decedeSwitch;

  late String nomActuel;
  late String prenomActuel;
  late int promoActuelle;
  late String posteActuel;
  late String entrepriseActuelle;
  late String filiereActuelle;
  late String villeActuelle;
  late String emailActuel;
  late String telActuel;

  List<StageEditor> _stageEditors = [];
  List<Stage> _stagesAffichage = [];

  @override
  void initState() {
    super.initState();
    nomActuel = widget.alumni.nom;
    prenomActuel = widget.alumni.prenom;
    promoActuelle = widget.alumni.promo;
    posteActuel = widget.alumni.job;
    entrepriseActuelle = widget.alumni.entreprise;
    villeActuelle = widget.alumni.ville;
    filiereActuelle = widget.alumni.filiere;
    emailActuel = widget.alumni.email;
    telActuel = widget.alumni.tel;

    _nomCtrl = TextEditingController(text: nomActuel);
    _prenomCtrl = TextEditingController(text: prenomActuel);
    _promoCtrl = TextEditingController(text: promoActuelle.toString());
    _posteCtrl = TextEditingController(text: posteActuel);
    _entrepriseCtrl = TextEditingController(text: entrepriseActuelle);
    _villeCtrl = TextEditingController(text: villeActuelle);
    _emailCtrl = TextEditingController(text: emailActuel);
    _telCtrl = TextEditingController(text: telActuel);
    _filiereCtrl = TextEditingController(text: filiereActuelle);
    _autorSwitch = widget.alumni.autor == 1;
    _decedeSwitch = widget.alumni.decede == 1;

    _stagesAffichage = List.from(widget.alumni.stages);
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
      _stageEditors.add(editor);
    }
  }

  @override
  void dispose() {
    _nomCtrl.dispose();
    _prenomCtrl.dispose();
    _promoCtrl.dispose();
    _posteCtrl.dispose();
    _entrepriseCtrl.dispose();
    _villeCtrl.dispose();
    _emailCtrl.dispose();
    _telCtrl.dispose();
    _filiereCtrl.dispose();
    for (var editor in _stageEditors) editor.dispose();
    super.dispose();
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
    int promoInt = int.tryParse(_promoCtrl.text) ?? promoActuelle;
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
      };
    }).toList();

    await DatabaseService().modifierEleve({
      "id": widget.alumni.id,
      "nom": _nomCtrl.text.trim(),
      "prenom": _prenomCtrl.text.trim(),
      "promo": promoInt,
      "autor": autorInt,
      "decede": decedeInt,
      "poste": _posteCtrl.text.trim(),
      "entreprise": _entrepriseCtrl.text.trim(),
      "ville": _villeCtrl.text.trim(),
      "filiere": _filiereCtrl.text.trim(),
      "email": _emailCtrl.text.trim(),
      "tel": _telCtrl.text.trim(),
      "stages": stagesData,

    });

    if (widget.onSave != null) {
      widget.onSave!();
    }

    if (!mounted) return;

    setState(() {
      nomActuel = _nomCtrl.text.trim();
      prenomActuel = _prenomCtrl.text.trim();
      promoActuelle = promoInt;
      posteActuel = _posteCtrl.text.trim();
      entrepriseActuelle = _entrepriseCtrl.text.trim();
      villeActuelle = _villeCtrl.text.trim();
      filiereActuelle = _filiereCtrl.text.trim();
      emailActuel = _emailCtrl.text.trim();
      telActuel = _telCtrl.text.trim();

      _stagesAffichage = _stageEditors.map((editor) {
        return Stage(
          intitule: editor.intitule.text,
          entreprise: editor.entreprise.text,
          ville: editor.ville.text,
          pays: editor.pays.text,
          description: editor.description.text,
          annee: editor.annee.text,
          type: editor.type,
        );
      }).toList();

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

    List<Widget> proItems = [
      if (posteActuel.isNotEmpty)...[
        _buildEditableTile(Icons.work, Colors.blue, "Poste", _posteCtrl, posteActuel),
        const Divider(height: 1),
      ],
      if (filiereActuelle.isNotEmpty)...[
        _buildEditableTile(Icons.school, Colors.orange, "Filière", _filiereCtrl, filiereActuelle),
        const Divider(height: 1),
      ],
      if (entrepriseActuelle.isNotEmpty)...[
      _buildEditableTile(Icons.business, Colors.indigo, "Entreprise", _entrepriseCtrl, entrepriseActuelle),
      ],
    ];
    if (proItems.isEmpty) proItems.add(Text("Aucune information renseignée"));


    List<Widget> contactItems = [
      if (villeActuelle.isNotEmpty)...[
      _buildEditableTile(Icons.location_on, Colors.red, "Ville", _villeCtrl, villeActuelle),
      ],
      if (_enEdition || (widget.alumni.autor == 1 && widget.alumni.decede == 0)) ...[
        const Divider(height: 1),
        if (emailActuel.isNotEmpty)...[
        _buildEditableTile(Icons.email, Colors.green, "Email", _emailCtrl, emailActuel),
        const Divider(height: 1),
        ],
        if (telActuel.isNotEmpty)...[
        _buildEditableTile(Icons.phone, Colors.amber, "Téléphone", _telCtrl, telActuel),
        ],
      ],
    ];
    if (contactItems.isEmpty) contactItems.add(Text("Aucune information renseignée"));

    return Scaffold(
      appBar: AppBar(
        title: Text(_enEdition ? "Modifier Alumni" : "$prenomActuel $nomActuel"),
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
                prenomActuel.isNotEmpty ? prenomActuel[0] : "?",
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
              Text("$prenomActuel $nomActuel", style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
              Text("Promo $promoActuelle", style: const TextStyle(fontSize: 20, color: Colors.grey)),
              const Divider(height: 40),
            ],

            if (estGrand)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildInfoCard(title: "Infos Pro", items: proItems)),
                  const SizedBox(width: 20),
                  Expanded(child: _buildInfoCard(title: "Contact", items: contactItems)),
                ],
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildInfoCard(title: "Infos Pro", items: proItems),
                  const SizedBox(height: 20),
                  _buildInfoCard(title: "Contact", items: contactItems),
                ],
              ),

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