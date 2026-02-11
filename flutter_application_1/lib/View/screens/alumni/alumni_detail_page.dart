import 'package:flutter/material.dart';
import 'package:flutter_application_ensicaentact/View/common/profile_badge.dart';
import '../../../Model/core/theme/colors.dart';
import '../../../Model/data/alumnis.dart';
import '../../../Model/data/services/database_service.dart';
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

class InternshipEditor {
  TextEditingController entilted = TextEditingController();
  TextEditingController entreprise = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController country = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController year = TextEditingController();
  TextEditingController start = TextEditingController();
  TextEditingController end = TextEditingController();
  String type = "E";

  void dispose() {
    entilted.dispose();
    entreprise.dispose();
    city.dispose();
    country.dispose();
    description.dispose();
    year.dispose();
    start.dispose();
    end.dispose();
  }
}

class _AlumniDetailPageState extends State<AlumniDetailPage> {
  bool _isEdited = false;
  bool _modified = false;
  bool _seeDescription = false;

  late TextEditingController _controllerLastName;
  late TextEditingController _controllerFirstName;
  late TextEditingController _controllerDateOfBirth;
  late TextEditingController _controllerPromotion;
  late TextEditingController _controllerPosition;
  late TextEditingController _controllerPositionDescription;
  late TextEditingController _controllerStartPositionDate;
  late TextEditingController _controllerCompany;
  late TextEditingController _controllerCity;
  late TextEditingController _controllereMail;
  late TextEditingController _controllerPhone;
  late TextEditingController _controllerSector;
  late TextEditingController _controllerSpecialisation;
  late TextEditingController _controllerOption;
  late TextEditingController _controllerDoubleDiploma;

  String _selectedGender = 'I';
  String _selectedFormation = 'FISE';

  late bool _permissionSwitch;
  late bool _deceasedSwitch;

  late Alumnis currentAlumni;

  List<InternshipEditor> _internshipEditors = [];
  List<Internship> _internshipDisplay = [];

  @override
  void initState() {
    super.initState();
    currentAlumni = widget.alumni;

    _controllerLastName = TextEditingController(text: currentAlumni.lastName);
    _controllerFirstName = TextEditingController(text: currentAlumni.firstname);
    _controllerDateOfBirth = TextEditingController(text: currentAlumni.dateOfBirth);
    _controllerPromotion = TextEditingController(text: currentAlumni.promotion.toString());
    
    _controllerPosition = TextEditingController(text: currentAlumni.job);
    _controllerPositionDescription = TextEditingController(text: currentAlumni.jobDescription);
    _controllerStartPositionDate = TextEditingController(text: currentAlumni.jobStart ?? "");
    _controllerCompany = TextEditingController(text: currentAlumni.company);
    
    _controllerCity = TextEditingController(text: currentAlumni.city);
    _controllereMail = TextEditingController(text: currentAlumni.email);
    _controllerPhone = TextEditingController(text: currentAlumni.phone);
    
    _controllerSector = TextEditingController(text: currentAlumni.sector);
    _controllerSpecialisation = TextEditingController(text: currentAlumni.specialisation);
    _controllerOption = TextEditingController(text: currentAlumni.option);
    _controllerDoubleDiploma = TextEditingController(text: currentAlumni.doubleDiploma);

    _selectedGender = ['M', 'F', 'I'].contains(currentAlumni.gender) ? currentAlumni.gender : 'I';
    _selectedFormation = ['FISE', 'FISA', 'MTS'].contains(currentAlumni.formation) ? currentAlumni.formation : 'FISE';

    _permissionSwitch = currentAlumni.permission == 1;
    _deceasedSwitch = currentAlumni.deceased == 1;

    _internshipDisplay = List.from(currentAlumni.internships);
    _initialiserStageEditors();
  }

  void _initialiserStageEditors() {
    for (var editor in _internshipEditors) editor.dispose();
    _internshipEditors.clear();

    for (var stage in _internshipDisplay) {
      var editor = InternshipEditor();
      editor.entilted.text = stage.entitled;
      editor.entreprise.text = stage.company;
      editor.city.text = stage.city;
      editor.country.text = stage.country;
      editor.description.text = stage.description;
      editor.year.text = stage.year;
      editor.type = stage.type;
      editor.start.text = stage.startDate;
      editor.end.text = stage.endDate;  
      _internshipEditors.add(editor);
    }
  }

  @override
  void dispose() {
    _controllerLastName.dispose(); 
    _controllerFirstName.dispose(); 
    _controllerDateOfBirth.dispose();
    _controllerPromotion.dispose(); 
    _controllerPosition.dispose(); 
    _controllerPositionDescription.dispose(); 
    _controllerStartPositionDate.dispose();
    _controllerCompany.dispose(); 
    _controllerCity.dispose(); 
    _controllereMail.dispose(); _controllerPhone.dispose();
    _controllerSector.dispose()
    ; _controllerSpecialisation.dispose(); 
    _controllerOption.dispose(); 
    _controllerDoubleDiploma.dispose();
    for (var editor in _internshipEditors) editor.dispose();
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

  String _calculateAge(String? dateStr) {
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

  String _calculateSeniority(String? dateStr) {
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

  void _addInternship() {
    setState(() {
      _internshipEditors.add(InternshipEditor());
    });
  }

  void _deleteInternship(int index) {
    setState(() {
      _internshipEditors[index].dispose();
      _internshipEditors.removeAt(index);
    });
  }

  void _save() async {
    int poromotionInt = int.tryParse(_controllerPromotion.text) ?? currentAlumni.promotion;
    int permissionInt = _permissionSwitch ? 1 : 0;
    int deceasedInt = _deceasedSwitch ? 1 : 0;

List<Map<String, dynamic>> stagesData = _internshipEditors.map((editor) {
  return {
        "intitule": editor.entilted.text.trim(),
        "entreprise": editor.entreprise.text.trim(),
        "ville": editor.city.text.trim(),
        "pays": editor.country.text.trim(),
        "description": editor.description.text.trim(),
        "annee": editor.year.text.trim(),
        "type": editor.type.trim(),
        "debut": editor.start.text.trim(),
        "fin": editor.end.text.trim(),
      };
    }).toList();

    Map<String, dynamic> updateData = {
      "id": widget.alumni.id,
      "nom": _controllerLastName.text.trim(),
      "prenom": _controllerFirstName.text.trim(),
      "dateNaissance": _controllerDateOfBirth.text.trim(),
      "sexe": _selectedGender,
      "promo": poromotionInt,
      "filiere": _controllerSector.text.trim(),
      "formation": _selectedFormation,
      "majeure": _controllerSpecialisation.text.trim(),
      "option": _controllerOption.text.trim(),
      "diplome": _controllerDoubleDiploma.text.trim(),
      "autor": permissionInt,
      "decede": deceasedInt,
      "poste": _controllerPosition.text.trim(),
      "description": _controllerPositionDescription.text.trim(),
      "debut": _controllerStartPositionDate.text.trim(),
      "entreprise": _controllerCompany.text.trim(),
      "ville": _controllerCity.text.trim(),
      "email": _controllereMail.text.trim(),
      "tel": _controllerPhone.text.trim(),
      "stages": stagesData,
    };

    await DatabaseService().modifyStudent(updateData);

    if (widget.onSave != null) {
      widget.onSave!();
    }

    if (!mounted) return;

    setState(() {
      _internshipDisplay = _internshipEditors.map((editor) {
        return Internship(
          entitled: editor.entilted.text,
          company: editor.entreprise.text,
          city: editor.city.text,
          country: editor.country.text,
          description: editor.description.text,
          year: editor.year.text,
          type: editor.type,
          startDate: editor.start.text,
          endDate: editor.end.text,
        );
      }).toList();

      currentAlumni = Alumnis(
        id: widget.alumni.id,
        lastName: _controllerLastName.text.trim(),
        firstname: _controllerFirstName.text.trim(),
        email: _controllereMail.text.trim(),
        phone: _controllerPhone.text.trim(),
        permission: permissionInt,
        deceased: deceasedInt,
        gender: _selectedGender,
        dateOfBirth: _controllerDateOfBirth.text.trim(),
        promotion: poromotionInt,
        sector: _controllerSector.text.trim(),
        formation: _selectedFormation,
        specialisation: _controllerSpecialisation.text.trim(),
        option: _controllerOption.text.trim(),
        doubleDiploma: _controllerDoubleDiploma.text.trim(),
        job: _controllerPosition.text.trim(),
        jobDescription: _controllerPositionDescription.text.trim(),
        jobStart: _controllerStartPositionDate.text.trim(),
        jobEnd: "",
        company: _controllerCompany.text.trim(),
        city: _controllerCity.text.trim(),
        country: "",
        internships: _internshipDisplay,
      );

      _isEdited = false;
      _modified = true;
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
    bool isBig = screenWidth > 800;
    
    double horizontalPadding = 40.0;
    double spacing = 10.0;
    
    int stageCount = _internshipDisplay.length;
    
    int divisor = stageCount > 0 ? stageCount : 1;
    if (divisor > 3) divisor = 3;
    
    double cardWidth = (screenWidth - horizontalPadding - (spacing * (divisor - 1))) / divisor;

    bool isAdmin = widget.user['role'] == 'admin';

    List<Widget> etuItems = [
      if (currentAlumni.sector.isNotEmpty || _isEdited)...[
              _buildEditableTile(Icons.school, Colors.orange, "Filière", _controllerSector, currentAlumni.sector),
              const Divider(height: 1),
      ],
      if (_isEdited || currentAlumni.specialisation.isNotEmpty || currentAlumni.option.isNotEmpty || currentAlumni.doubleDiploma.isNotEmpty) ...[
         if (_isEdited) ...[
            _buildEditableTile(Icons.book, Colors.redAccent, "Majeure", _controllerSpecialisation, currentAlumni.specialisation),
            const Divider(height: 1),
            _buildEditableTile(Icons.bookmark, Colors.pinkAccent, "Option", _controllerOption, currentAlumni.option),
            const Divider(height: 1),
            _buildEditableTile(Icons.workspace_premium, Colors.purple, "Double Diplôme", _controllerDoubleDiploma, currentAlumni.doubleDiploma),
         ] else ...[
            if (currentAlumni.specialisation.isNotEmpty)...[
              _buildEditableTile(Icons.book, Colors.redAccent, "Majeure", _controllerSpecialisation, currentAlumni.specialisation),
              const Divider(height: 1),
            ],
            if (currentAlumni.option.isNotEmpty)...[
              _buildEditableTile(Icons.bookmark, Colors.pinkAccent, "Option", _controllerOption, currentAlumni.option),
              const Divider(height: 1),
            ],
            if (currentAlumni.doubleDiploma.isNotEmpty)...[
              _buildEditableTile(Icons.workspace_premium, Colors.purple, "Double Diplôme", _controllerDoubleDiploma, currentAlumni.doubleDiploma),
            ],
         ],
      ],
    ];

    List<Widget> proItems = [
      if (_isEdited) ...[
        _buildEditableTile(Icons.work, Colors.blue, "Poste", _controllerPosition, currentAlumni.job),
        const SizedBox(height: 10),
        _buildEditableTile(Icons.description, Colors.grey, "Description du poste", _controllerPositionDescription, currentAlumni.jobDescription),
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
                    _seeDescription ? Icons.remove_circle_outline : Icons.add_circle_outline,
                    color: AppColors.ensiCyan,
                  ),
                  onPressed: () {
                    setState(() {
                      _seeDescription = !_seeDescription;
                    });
                  },
                )
              : null,
        ),
        if (_seeDescription && currentAlumni.jobDescription.isNotEmpty)
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
      
      if (currentAlumni.city.isNotEmpty)...[
        _buildEditableTile(Icons.location_on, Colors.red, "Ville", _controllerCity, currentAlumni.city),
        const Divider(height: 1),
      ],
      if (currentAlumni.company.isNotEmpty || _isEdited)...[
        _buildEditableTile(Icons.business, Colors.indigo, "Entreprise", _controllerCompany, currentAlumni.company),
        const Divider(height: 1),
        if (!_isEdited && _controllerStartPositionDate.text.isNotEmpty) ...[
          ListTile(
            leading: Icon(Icons.timer, color: Colors.teal),
            title: Text("Ancienneté"),
            subtitle: Text("${_controllerStartPositionDate.text} (${_calculateSeniority(_controllerStartPositionDate.text)})"),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          ),
        ]
        else if (_isEdited)
           Padding(
             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
             child: TextFormField(
                controller: _controllerStartPositionDate,
                decoration: const InputDecoration(
                  labelText: "Date de début (Poste)", 
                  border: OutlineInputBorder(), 
                  prefixIcon: Icon(Icons.calendar_today)
                ),
                readOnly: true,
                onTap: () => _selectionnerDate(context, _controllerStartPositionDate),
             ),
           ),
      ],
    ];
    
    if (proItems.isEmpty) proItems.add(Text("Aucune information renseignée"));


    List<Widget> contactItems = [
      if (_isEdited || (currentAlumni.permission == 1 && currentAlumni.deceased == 0)) ...[
        const Divider(height: 1),
        if (currentAlumni.email.isNotEmpty)...[
        _buildEditableTile(Icons.email, Colors.green, "Email", _controllereMail, currentAlumni.email),
        const Divider(height: 1),
        ],
        if (currentAlumni.phone.isNotEmpty)...[
        _buildEditableTile(Icons.phone, Colors.amber, "Téléphone", _controllerPhone, currentAlumni.phone),
        ],
      ],
    ];
    if (contactItems.isEmpty) contactItems.add(Text("Aucune information renseignée"));

    bool modeLigne = MediaQuery.of(context).size.width > 600 && currentAlumni.email.isNotEmpty && currentAlumni.phone.isNotEmpty;
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEdited ? "Modifier Alumni" : "${currentAlumni.firstname} ${currentAlumni.lastName}"),
        backgroundColor: AppColors.ensiCyan,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context, _modified),
        ),
        actions: [
          if (isAdmin)
            IconButton(
              icon: Icon(_isEdited ? Icons.save : Icons.edit),
              tooltip: _isEdited ? "Enregistrer" : "Modifier",
              onPressed: () {
                if (_isEdited) {
                  _save();
                } else {
                  setState(() {
                    _isEdited = true;
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
                currentAlumni.firstname.isNotEmpty ? currentAlumni.firstname[0] : "?",
                style: const TextStyle(fontSize: 40, color: Colors.white),
              ),
            ),
            const SizedBox(height: 10),

            if (_isEdited) ...[
              Row(
                children: [
                  Expanded(child: TextField(controller: _controllerFirstName, decoration: const InputDecoration(labelText: "Prénom", border: OutlineInputBorder()))),
                  const SizedBox(width: 10),
                  Expanded(child: TextField(controller: _controllerLastName, decoration: const InputDecoration(labelText: "Nom", border: OutlineInputBorder()))),
                ],
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _controllerPromotion,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(labelText: "Promo (Année)", border: OutlineInputBorder()),
              ),
              const SizedBox(height: 10),
             TextFormField(
                controller: _controllerDateOfBirth,
                decoration: const InputDecoration(labelText: "Date de Naissance", border: OutlineInputBorder(), prefixIcon: Icon(Icons.cake)),
                readOnly: true,
                onTap: () => _selectionnerDate(context, _controllerDateOfBirth),
              ),
              const Divider(height: 40),
              Card(
                color: Colors.grey[100],
                elevation: 0,
                margin: const EdgeInsets.only(bottom: 20),
                child: Column(
                  children: [
                    const Padding(padding: EdgeInsets.all(8.0), child: Text("Statut Administrateur", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54))),
                    SwitchListTile(title: const Text("Autorisation des données"), subtitle: Text(_permissionSwitch ? "Visible" : "Caché"), activeColor: Colors.green, value: _permissionSwitch, onChanged: (val) => setState(() => _permissionSwitch = val)),
                    const Divider(height: 1),
                    SwitchListTile(title: const Text("Décédé"), subtitle: const Text("Marquer comme décédé"), activeColor: Colors.red, value: _deceasedSwitch, onChanged: (val) => setState(() => _deceasedSwitch = val)),
                  ],
                ),
              ),
              const Divider(height: 20),
            ] else ...[
              Text("${currentAlumni.firstname} ${currentAlumni.lastName}", style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
              Text("Promo ${currentAlumni.promotion}", style: const TextStyle(fontSize: 20, color: Colors.grey)),
              if (currentAlumni.dateOfBirth.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text("${_calculateAge(currentAlumni.dateOfBirth)}", style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic)),
                ),
              const Divider(height: 40),
            ],

            if (isBig)...[
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
              
              if (_isEdited || (currentAlumni.permission == 1 && currentAlumni.deceased == 0)) ...[
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


                      if (modeLigne) 
                        Row(
                          children: [
                            Expanded(
                              child: _buildEditableTile(Icons.email, Colors.green, "Email", _controllereMail, currentAlumni.email),
                            ),

                            Container(width: 1, height: 40, color: Colors.grey[300]),
                            Expanded(
                              child: _buildEditableTile(Icons.phone, Colors.amber, "Téléphone", _controllerPhone, currentAlumni.phone),
                            ),
                          ],
                        )
                      else 
                        Column(
                          children: [
                            if (currentAlumni.email.isNotEmpty || _isEdited)
                              _buildEditableTile(Icons.email, Colors.green, "Email", _controllereMail, currentAlumni.email),
                              
                            if ((currentAlumni.email.isNotEmpty || _isEdited) && (currentAlumni.phone.isNotEmpty || _isEdited))
                              const Divider(indent: 20, endIndent: 20, height: 1),
                              
                            if (currentAlumni.phone.isNotEmpty || _isEdited)
                              _buildEditableTile(Icons.phone, Colors.amber, "Téléphone", _controllerPhone, currentAlumni.phone),
                          ],
                        ),
                        
                        if (currentAlumni.email.isEmpty && currentAlumni.phone.isEmpty && !_isEdited)
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
                if (_isEdited)
                  ElevatedButton.icon(
                    onPressed: _addInternship,
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text("Ajouter Stage"),
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.ensiCyan, foregroundColor: Colors.white),
                  )
              ],
            ),

            if (_isEdited)
              Column(
                children: _internshipEditors.asMap().entries.map((entry) {
                  int index = entry.key;
                  InternshipEditor editor = entry.value;
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
                              IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => _deleteInternship(index)),
                            ],
                          ),
                          Row(children: [
                             Expanded(
                              child: DropdownButtonFormField<String>(
                                value: ['1A', '2A', '3A'].contains(editor.year.text) 
                                    ? editor.year.text 
                                    : null,
                                    
                                decoration: const InputDecoration(labelText: "Année", border: OutlineInputBorder()),
                                
                                items: const [
                                  DropdownMenuItem(value: '1A', child: Text("1A")), 
                                  DropdownMenuItem(value: '2A', child: Text("2A")), 
                                  DropdownMenuItem(value: '3A', child: Text("3A"))
                                ],
                                
                                onChanged: (v) { if (v != null) { setState(() { editor.year.text = v; });}},
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
                          TextField(controller: editor.entilted, decoration: const InputDecoration(labelText: "Intitulé", border: OutlineInputBorder())),
                          const SizedBox(height: 10),
                          TextField(controller: editor.entreprise, decoration: const InputDecoration(labelText: "Entreprise", border: OutlineInputBorder())),
                          const SizedBox(height: 10),
                          Row(children: [
                            Expanded(child: TextField(controller: editor.city, decoration: const InputDecoration(labelText: "Ville", border: OutlineInputBorder()))),
                            const SizedBox(width: 10),
                            Expanded(child: TextField(controller: editor.country, decoration: const InputDecoration(labelText: "Pays", border: OutlineInputBorder()))),
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
              _internshipDisplay.isEmpty
                  ? const Card(
                      elevation: 1,
                      child: ListTile(title: Text("Aucun stage renseigné", style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey))),
                    )
                  : isBig
                      ? SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: IntrinsicHeight(
                            child: Row(
                              children: _internshipDisplay.map((stage) {
                                return _buildStageCard(stage, cardWidth, spacing, _internshipDisplay.last == stage);
                              }).toList(),
                            ),
                          ),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: _internshipDisplay.map((stage) {
                            return _buildStageCard(stage, cardWidth, spacing, _internshipDisplay.last == stage);
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
      subtitle: _isEdited
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
                      "${stage.year} - ${stage.entitled}",
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const Divider(),
              _buildStageField(stage.type == "U" ? "Université" : "Entreprise", stage.type == "E" ? Icons.apartment : Icons.school, Colors.green, stage.company),
              _buildStageField("Lieu", Icons.location_on, Colors.red, "${stage.city}, ${stage.country}", isItalic: true),
              if (stage.startDate.isNotEmpty || stage.endDate.isNotEmpty)
              _buildStageField("Période",Icons.calendar_today , Colors.blue, "${stage.startDate} au ${stage.endDate}"),
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