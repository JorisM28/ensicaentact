import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../Model/core/theme/colors.dart';
import '../../../service_locator.dart';
import '../../../Model/data/services/alumni_repository.dart';

class StageFormModel {
  final Key key = UniqueKey();
  
  final TextEditingController controllerEntitled = TextEditingController();
  final TextEditingController controllerCompany = TextEditingController();
  final TextEditingController controllerCity = TextEditingController();
  final TextEditingController controllercountry = TextEditingController();
  final TextEditingController controllerDescription = TextEditingController();
  final TextEditingController controllerStartDate = TextEditingController();
  final TextEditingController controllerEndDate = TextEditingController();
  String internshipType ='I';
  String selectedYear = '2A';

  void dispose() {
    controllerEntitled.dispose();
    controllerCompany.dispose();
    controllerCity.dispose();
    controllercountry.dispose();
    controllerDescription.dispose();
    controllerStartDate.dispose();
    controllerEndDate.dispose();
  }

  Map<String, dynamic> toMap() {
    return {
      "intitule": controllerEntitled.text.trim(),
      "annee": selectedYear,
      "type" : internshipType,
      "entreprise": controllerCompany.text.trim(),
      "ville": controllerCity.text.trim(),
      "pays": controllercountry.text.trim(),
      "description": controllerDescription.text.trim(),
      "debut": controllerStartDate.text.trim(),
      "fin": controllerEndDate.text.trim(),
    };
  }
}

class AddAlumniForm extends StatefulWidget {
  final VoidCallback? onSuccess;
  final bool isAdmin;
  final Map<String, dynamic>? initialData;
  final int? requestId;

const AddAlumniForm({super.key, this.onSuccess, this.isAdmin=false, this.initialData, this.requestId});

  @override
  State<AddAlumniForm> createState() => _AddAlumniFormState();
}

class _AddAlumniFormState extends State<AddAlumniForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool? _consent = false;

  final _controllerLastName = TextEditingController();
  final _controllerFirstName = TextEditingController();
  final _controllerDateOfBirth = TextEditingController();
  final _controllereMail = TextEditingController();
  final _controllerPhone = TextEditingController();
  final _controllerPositionDescription = TextEditingController();
  final _controllerStartDate = TextEditingController();
  String _selectedGender = 'I';
  String? _selectedSpecialisation;
  String? _selectedOption;

  final _controllerPromotion = TextEditingController();
  String _selectedFormation = 'FISE';
  String _selectedSector = 'Informatique';

  final _controllerPosition = TextEditingController();
  final _controllerCompany = TextEditingController();
  final _controllerCity = TextEditingController();
  final _paysCtrl = TextEditingController();

  final Map<String, Map<String, List<String>>> _hierarchieFormation = {
    'Informatique': {
      'ISIA': ['Intelligence Artificielle', 'Scala'],
      'CYIA': ['Intelligence Artificielle', 'Scala'],
      'EPCS': ['Intelligence Artificielle', 'Scala'],
    },
    'Systèmes Embarqués': {
      'Systèmes embarqués et automatique': [],
      'Ingénierie physique et capteurs': [],
      'Génie nucléaire et énergie' :[],
    },
    'Matériaux Chimie': {
      'Chimie organique et catalyse': ['Rearrangements et processus pericycliques et Synthese multi-etapes',"Biomasse lignocellulosique en energie et Catalyse et procedes pour l'energie et la chimie"],
      'Matériaux pour l’énergie et matériaux de structure': [],
    },
  };

  String type ='E';

  final List<StageFormModel> _internships = [];

  Future<void> _selectionnerDate(BuildContext context, TextEditingController controller) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      locale: const Locale("fr", "FR"),
    );

    if (picked != null) {
      setState(() {
        controller.text = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  Future<Map<String, double>?> _obtenirCoordonnees(String ville, String pays) async {
    if (ville.isEmpty) return null;

    String query = "$ville, $pays";
    var url = Uri.parse("https://nominatim.openstreetmap.org/search?q=$query&format=json&limit=1");

    try {
      var response = await http.get(url, headers: {
        'User-Agent': 'AlumniEnsiApp/1.0 (votre_email@exemple.com)' 
      });

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data is List && data.isNotEmpty) {
          return {
            "lat": double.parse(data[0]['lat']),
            "lon": double.parse(data[0]['lon']),
          };
        }
      }
    } catch (e) {
      print("Erreur de géocodage : $e");
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    
    if (widget.initialData != null) {
      var data = widget.initialData!;
      
      _controllerLastName.text = data['nom'] ?? '';
      _controllerFirstName.text = data['prenom'] ?? '';
      _selectedGender = data['sexe'] ?? 'I';
      _controllereMail.text = data['email'] ?? '';
      _controllerPhone.text = data['tel'] ?? '';
      _consent = data['autor'] == true || data['autor'] == 1; 

      _controllerPromotion.text = (data['promo'] ?? '').toString();
      _selectedFormation = data['formation'] ?? 'FISE';
      _selectedSector = data['filiere'] ?? 'Informatique';
      
      if (data['majeure'] != null) _selectedSpecialisation = data['majeure'];
      if (data['option'] != null) _selectedOption = data['option'];

      _controllerPosition.text = data['poste'] ?? data['job'] ?? '';
      _controllerCompany.text = data['entreprise'] ?? '';
      _controllerPositionDescription.text = data['description'] ?? '';
      _controllerCity.text = data['ville'] ?? '';
      _paysCtrl.text = data['pays'] ?? '';

      if (data['stages'] != null) {
        for (var s in data['stages']) {
          var stageModel = StageFormModel();
          stageModel.selectedYear = s['annee'] ?? '2A';
          stageModel.internshipType = s['type'] ?? 'I';
          stageModel.controllerEntitled.text = s['intitule'] ?? '';
          stageModel.controllerCompany.text = s['entreprise'] ?? '';
          stageModel.controllerCity.text = s['ville'] ?? '';
          stageModel.controllercountry.text = s['pays'] ?? '';
          stageModel.controllerDescription.text = s['description'] ?? '';
          _internships.add(stageModel);
        }
      }
    }
  }

  @override
  void dispose() {
    _controllerLastName.dispose(); 
    _controllerFirstName.dispose(); 
    _controllerDateOfBirth.dispose();
    _controllereMail.dispose(); 
    _controllerPhone.dispose();
    _controllerPromotion.dispose();
    _controllerPosition.dispose(); 
    _controllerCompany.dispose(); 
    _controllerPositionDescription.dispose();
    _controllerStartDate.dispose();
    _controllerCity.dispose(); 
    _paysCtrl.dispose();
    
    for (var internship in _internships) {
      internship.dispose();
    }
    super.dispose();
  }

  void _addInternship() {
    setState(() {
      _internships.add(StageFormModel());
    });
  }

  void _supprimerStage(int index) {
    setState(() {
      _internships[index].dispose();
      _internships.removeAt(index);
    });
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      double? positionLat;
      double? positionLon;
      var coordsPoste = await _obtenirCoordonnees(_controllerCity.text, _paysCtrl.text);
      if (coordsPoste != null) {
        positionLat = coordsPoste['lat'];
        positionLon = coordsPoste['lon'];
      }
      Map<String, dynamic> data = {
        "nom": _controllerLastName.text.trim(),
        "prenom": _controllerFirstName.text.trim(),
        "dateNaissance": _controllerDateOfBirth.text.trim(),
        "sexe": _selectedGender,
        "email": _controllereMail.text.trim(),
        "tel": _controllerPhone.text.trim(),
        "autor":_consent,
        "promo": int.tryParse(_controllerPromotion.text) ?? 2024,
        "filiere": _selectedSector,
        "formation": _selectedFormation,
        "majeure": _selectedSpecialisation ?? "",
        "option": _selectedOption ?? "",
        "job": _controllerPosition.text.trim(),
        "poste": _controllerPosition.text.trim(),
        "entreprise": _controllerCompany.text.trim(),
        "description": _controllerPositionDescription.text.trim(),
        "debut": _controllerStartDate.text.trim(),
        "ville": _controllerCity.text.trim(),
        "pays": _paysCtrl.text.trim(),
        "latitude": positionLat,
        "longitude": positionLon,
      };

      List<Map<String, dynamic>> internshipList = [];
      for (var s in _internships) {
        var stageMap = s.toMap();
        
        var coordsStage = await _obtenirCoordonnees(s.controllerCity.text, s.controllercountry.text);
        if (coordsStage != null) {
          stageMap['latitude'] = coordsStage['lat'];
          stageMap['longitude'] = coordsStage['lon'];
        }
        internshipList.add(stageMap);
      }

      if (internshipList.isNotEmpty) {
        data["stages"] = internshipList;
      }

      if (_internships.isNotEmpty) {
        data["stages"] = _internships.map((s) => s.toMap()).toList();
      }

      if (widget.isAdmin) {          
       await sl<AlumniRepository>().addAlumni(data, isAdmin: true);
        if (widget.requestId != null) {
          await sl<AlumniRepository>().deletePendingRequest({'id_demande': widget.requestId!});
        }
      } else {
       await sl<AlumniRepository>().addAlumni(data, isAdmin: false);
      }

      if (widget.onSuccess != null) {
        widget.onSuccess!();
      }
      
     if (mounted) {
        String msg = widget.isAdmin 
            ? "Alumni ajouté directement !" 
            : "Demande envoyée pour validation.";
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.green));
      }

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur : $e"), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
   List<String>? availableOption;

    if (_selectedSector.isNotEmpty && _selectedSpecialisation != null) {
      var sectorMap = _hierarchieFormation[_selectedSector];
      
      if (sectorMap != null) {
        availableOption = sectorMap[_selectedSpecialisation];
      }
    }
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _sectionTitle("Identité", Icons.person, Colors.purple),
              Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 20.0, top: 10.0),
                    child: Text(
                      "Formulaire d'ajout d'alumni",
                      style: TextStyle(
                        fontSize: 24, 
                        fontWeight: FontWeight.bold,
                        color: AppColors.ensiCyan,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded( 
                    child: TextFormField(
                      controller: _controllerLastName,
                      decoration: const InputDecoration(labelText: "Nom *", border: OutlineInputBorder()),
                      validator: (value) => value == null || value.isEmpty ? 'Requis' : null,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: _controllerFirstName,
                      decoration: const InputDecoration(labelText: "Prénom *", border: OutlineInputBorder()),
                      validator: (value) => value == null || value.isEmpty ? 'Requis' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _controllerDateOfBirth,
                      decoration: const InputDecoration(
                        labelText: "Date de naissance", 
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.cake),
                      ),
                      readOnly: true,
                      onTap: () => _selectionnerDate(context, _controllerDateOfBirth),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedGender,
                      decoration: const InputDecoration(labelText: "Sexe", border: OutlineInputBorder()),
                      items: const [
                        DropdownMenuItem(value: 'I', child: Text("Inconnu")),
                        DropdownMenuItem(value: 'M', child: Text("Homme")),
                        DropdownMenuItem(value: 'F', child: Text("Femme")),
                      ],
                      onChanged: (v) => setState(() => _selectedGender = v!),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _controllereMail,
                decoration: const InputDecoration(labelText: "Email", border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email)),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _controllerPhone,
                decoration: const InputDecoration(labelText: "Téléphone", border: OutlineInputBorder(), prefixIcon: Icon(Icons.phone)),
                keyboardType: TextInputType.phone,
              ),
              CheckboxListTile(
                title: Text("Consentir a ce que le téléphone et le mail soit visible"),
                value: _consent,
                onChanged: (value) {
                  setState(() {
                    _consent = value!;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
              ),

              const Divider(height: 30),

              _sectionTitle("Formation ENSI", Icons.school, Colors.orange),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _controllerPromotion,
                      decoration: const InputDecoration(labelText: "Promo (ex: 2024) *", border: OutlineInputBorder()),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: (value) => value == null || value.isEmpty ? 'Requis' : null,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedFormation,
                      decoration: const InputDecoration(labelText: "Formation", border: OutlineInputBorder()),
                      items: const [
                        DropdownMenuItem(value: 'FISE', child: Text("FISE (Etudiant)")),
                        DropdownMenuItem(value: 'FISA', child: Text("FISA (Alternance)")),
                        DropdownMenuItem(value: 'MTS', child: Text("MTS (Mastère)")),
                      ],
                      onChanged: (v) => setState(() => _selectedFormation = v!),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedSector,
                      decoration: const InputDecoration(labelText: "Filière", border: OutlineInputBorder()),
                      items: _hierarchieFormation.keys.map((String filiere) {
                        return DropdownMenuItem(value: filiere, child: Text(filiere, overflow: TextOverflow.ellipsis));
                      }).toList(),
                      onChanged: (v) {
                        setState(() {
                          _selectedSector = v!;
                          _selectedSpecialisation = null;
                          _selectedOption = null;
                        });
                      },
                    ),
                  ),
                  
                  const SizedBox(width: 10),

                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedSpecialisation,
                      decoration: const InputDecoration(labelText: "Majeure", border: OutlineInputBorder()),
                      isExpanded: true,
                      items: _selectedSector.isEmpty || _hierarchieFormation[_selectedSector] == null
                          ? []
                          : _hierarchieFormation[_selectedSector]!.keys.map((String majeure) {
                              return DropdownMenuItem(
                                value: majeure, 
                                child: Text(majeure, overflow: TextOverflow.ellipsis)
                              );
                            }).toList(),
                      onChanged: (v) {
                        setState(() {
                          _selectedSpecialisation = v;
                          _selectedOption = null;
                        });
                      },
                    ),
                  ),
                ],
              ),

              if ( availableOption != null && availableOption.isNotEmpty)...[
              const SizedBox(height : 10),
                DropdownButtonFormField<String>(
                      value: _selectedOption,
                      decoration: const InputDecoration(labelText: "Option", border: OutlineInputBorder()),
                      isExpanded: true,
                      items: availableOption.map((String option) {
                        return DropdownMenuItem(
                          value: option, 
                          child: Text(option, overflow: TextOverflow.ellipsis)
                        );
                      }).toList(),
                      onChanged: (v) => setState(() => _selectedOption = v),
                    ),
              ],

              const Divider(height: 30),

              _sectionTitle("Poste Actuel", Icons.work, Colors.indigo),
              TextFormField(
                controller: _controllerPosition,
                decoration: const InputDecoration(labelText: "Intitulé du poste", border: OutlineInputBorder()),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _controllerCompany,
                decoration: const InputDecoration(labelText: "Entreprise", border: OutlineInputBorder()),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _controllerCity,
                      decoration: const InputDecoration(labelText: "Ville", border: OutlineInputBorder()),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: _paysCtrl,
                      decoration: const InputDecoration(labelText: "Pays", border: OutlineInputBorder()),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _controllerPositionDescription,
                decoration: const InputDecoration(
                  labelText: "Description du poste",
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,),
                  maxLines: 4,
                  keyboardType: TextInputType.multiline,
                ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _controllerStartDate,
                      decoration: const InputDecoration(
                        labelText: "Date de début", 
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.calendar_today),
                      ),
                      readOnly: true,
                      onTap: () => _selectionnerDate(context, _controllerStartDate),
                    ),
                  ),
                  ],
              ),

              const Divider(height: 30),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _sectionTitle("Stages", Icons.work_history, Colors.green),
                  TextButton.icon(
                    onPressed: _addInternship,
                    icon: const Icon(Icons.add_circle, color: AppColors.ensiCyan),
                    label: const Text("Ajouter un stage", style: TextStyle(color: AppColors.ensiCyan)),
                  ),
                ],
              ),

              if (_internships.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text("Aucun stage ajouté (facultatif)", style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic)),
                )
              else
                ..._internships.asMap().entries.map((entry) {
                  int index = entry.key;
                  StageFormModel intership = entry.value;

                  return Card(
                    key: intership.key,
                    margin: const EdgeInsets.only(bottom: 15),
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Stage #${index + 1}", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                tooltip: "Supprimer ce stage",
                                onPressed: () => _supprimerStage(index),
                              ),
                            ],
                          ),
                          DropdownButtonFormField<String>(
                            value: intership.selectedYear,
                            decoration: const InputDecoration(labelText: "Année du stage", border: OutlineInputBorder()),
                            items: const [
                              DropdownMenuItem(value: '1A', child: Text("1ère Année (1A)")),
                              DropdownMenuItem(value: '2A', child: Text("2ème Année (2A)")),
                              DropdownMenuItem(value: '3A', child: Text("PFE (3A)")),
                            ],
                            onChanged: (v) => intership.selectedYear = v!,
                          ),
                            const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: intership.controllerStartDate,
                                  decoration: const InputDecoration(
                                    labelText: "Date de début", 
                                    border: OutlineInputBorder(),
                                    prefixIcon: Icon(Icons.calendar_today),
                                  ),
                                  readOnly: true,
                                  onTap: () => _selectionnerDate(context, intership.controllerStartDate),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: TextFormField(
                                  controller: intership.controllerEndDate,
                                  decoration: const InputDecoration(
                                    labelText: "Date de fin", 
                                    border: OutlineInputBorder(),
                                    prefixIcon: Icon(Icons.event),
                                  ),
                                  readOnly: true,
                                  onTap: () => _selectionnerDate(context, intership.controllerEndDate),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: intership.controllerEntitled,
                            decoration: const InputDecoration(labelText: "Sujet / Intitulé *", border: OutlineInputBorder()),
                            validator: (value) => value == null || value.isEmpty ? 'Requis' : null,
                          ),
                          const SizedBox(height: 10),
                         FormField<String>(
                            validator: (value) {
                              if (intership.internshipType == 'I') {
                                return 'Type de structure requis';
                              }
                              return null;
                            },
                            builder: (FormFieldState<String> state) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: RadioListTile<String>(
                                          title: const Text('Entreprise'),
                                          value: 'E',
                                          groupValue: intership.internshipType,
                                          activeColor: AppColors.ensiCyan,
                                          contentPadding: EdgeInsets.zero,
                                          onChanged: (value) {
                                            setState(() {
                                              intership.internshipType = value!;
                                              state.didChange(value);
                                            });
                                          },
                                        ),
                                      ),
                                      Expanded(
                                        child: RadioListTile<String>(
                                          title: const Text('Université'),
                                          value: 'U',
                                          groupValue: intership.internshipType,
                                          activeColor: AppColors.ensiCyan,
                                          contentPadding: EdgeInsets.zero,
                                          onChanged: (value) {
                                            setState(() {
                                              intership.internshipType = value!;
                                              state.didChange(value);
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (state.hasError)
                                    Padding(
                                      padding: const EdgeInsets.only(left: 12.0, bottom: 5),
                                      child: Text(
                                        state.errorText!,
                                        style: TextStyle(
                                          color: Theme.of(context).colorScheme.error,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                ],
                              );
                            },
                          ),
                          TextFormField(
                            controller: intership.controllerCompany,
                            decoration: const InputDecoration(labelText: "Nom de l'Entreprise / du Labo", border: OutlineInputBorder()),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(child: TextFormField(controller: intership.controllerCity, decoration: const InputDecoration(labelText: "Ville", border: OutlineInputBorder()))),
                              const SizedBox(width: 10),
                              Expanded(child: TextFormField(controller: intership.controllercountry, decoration: const InputDecoration(labelText: "Pays", border: OutlineInputBorder()))),
                            ],
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: intership.controllerDescription,
                            decoration: const InputDecoration(
                            labelText: "Description du stage", 
                            border: OutlineInputBorder(),
                            alignLabelWithHint: true,
                            ),
                            maxLines: 4,
                            keyboardType: TextInputType.multiline,
                            ),
                        ],
                      ),
                    ),
                  );
                }),

              const SizedBox(height: 20),
              
            if (widget.isAdmin && widget.requestId != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  onPressed: () async {
                    bool confirm = await showDialog(
                      context: context, 
                      builder: (c) => AlertDialog(
                        title: const Text("Refuser la demande ?"),
                        content: const Text("Cette action est irréversible."),
                        actions: [
                          TextButton(onPressed: ()=>Navigator.pop(c,false), child: const Text("Annuler")),
                          TextButton(onPressed: ()=>Navigator.pop(c,true), child: const Text("Confirmer le refus")),
                        ],
                      )
                    ) ?? false;

                    if (confirm) {
                      await sl<AlumniRepository>().deletePendingRequest({'id_demande': widget.requestId!});
                      if (widget.onSuccess != null) widget.onSuccess!();
                      if (mounted) Navigator.pop(context);
                    }
                  },
                  icon: const Icon(Icons.delete_forever, color: Colors.white),
                  label: const Text("REFUSER CETTE DEMANDE", style: TextStyle(color: Colors.white)),
                ),
              ),

              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.ensiCyan,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                onPressed: _isLoading ? null : _submitForm,
                icon: _isLoading 
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Icon(Icons.save, color: Colors.white),
                label: Text(
                  _isLoading ? "Enregistrement..." : "Enregistrer l'Alumni", 
                  style: const TextStyle(color: Colors.white, fontSize: 16)
                ),
              ),
              
            ],
          ),
        ),
      ),
    );
  }

 Widget _sectionTitle(String titre, IconData icon, Color color) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 15),
    child: Row(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(width: 10),
        Text(
          titre, 
          style: const TextStyle(
            fontWeight: FontWeight.bold, 
            fontSize: 18, 
            color: AppColors.ensiCyan
          )
        ),
      ],
    ),
  );
}
}