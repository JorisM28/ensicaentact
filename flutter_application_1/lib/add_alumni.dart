import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'database_service.dart';
import 'colors.dart';

class StageFormModel {
  final Key key = UniqueKey();
  
  final TextEditingController intituleCtrl = TextEditingController();
  final TextEditingController entrepriseCtrl = TextEditingController();
  final TextEditingController villeCtrl = TextEditingController();
  final TextEditingController paysCtrl = TextEditingController();
  final TextEditingController descriptionCtrl = TextEditingController();
  final TextEditingController dateDebutCtrl = TextEditingController();
  final TextEditingController dateFinCtrl = TextEditingController();
  String typeStage ='I';
  String anneeSelectionnee = '2A';

  void dispose() {
    intituleCtrl.dispose();
    entrepriseCtrl.dispose();
    villeCtrl.dispose();
    paysCtrl.dispose();
    descriptionCtrl.dispose();
    dateDebutCtrl.dispose();
    dateFinCtrl.dispose();
  }

  Map<String, dynamic> toMap() {
    return {
      "intitule": intituleCtrl.text.trim(),
      "annee": anneeSelectionnee,
      "type" : typeStage,
      "entreprise": entrepriseCtrl.text.trim(),
      "ville": villeCtrl.text.trim(),
      "pays": paysCtrl.text.trim(),
      "description": descriptionCtrl.text.trim(),
      "debut": dateDebutCtrl.text.trim(),
      "fin": dateFinCtrl.text.trim(),
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

  final _nomCtrl = TextEditingController();
  final _prenomCtrl = TextEditingController();
  final _dateNaissanceCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _telCtrl = TextEditingController();
  final _descriptionPosteCtrl = TextEditingController();
  final _dateDebutCtrl = TextEditingController();
  String _sexeSelectionne = 'I';
  String? _majeureSelectionnee;
  String? _optionSelectionnee;

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

  final _promoCtrl = TextEditingController();
  String _formationSelectionnee = 'FISE';
  String _filiereSelectionnee = 'Informatique';

  final _posteCtrl = TextEditingController();
  final _entrepriseCtrl = TextEditingController();
  final _villeCtrl = TextEditingController();
  final _paysCtrl = TextEditingController();

  final List<StageFormModel> _stages = [];

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
      
      _nomCtrl.text = data['nom'] ?? '';
      _prenomCtrl.text = data['prenom'] ?? '';
      _sexeSelectionne = data['sexe'] ?? 'I';
      _emailCtrl.text = data['email'] ?? '';
      _telCtrl.text = data['tel'] ?? '';
      _consent = data['autor'] == true || data['autor'] == 1; 

      _promoCtrl.text = (data['promo'] ?? '').toString();
      _formationSelectionnee = data['formation'] ?? 'FISE';
      _filiereSelectionnee = data['filiere'] ?? 'Informatique';
      
      if (data['majeure'] != null) _majeureSelectionnee = data['majeure'];
      if (data['option'] != null) _optionSelectionnee = data['option'];

      _posteCtrl.text = data['poste'] ?? data['job'] ?? '';
      _entrepriseCtrl.text = data['entreprise'] ?? '';
      _descriptionPosteCtrl.text = data['description'] ?? '';
      _villeCtrl.text = data['ville'] ?? '';
      _paysCtrl.text = data['pays'] ?? '';

      if (data['stages'] != null) {
        for (var s in data['stages']) {
          var stageModel = StageFormModel();
          stageModel.anneeSelectionnee = s['annee'] ?? '2A';
          stageModel.typeStage = s['type'] ?? 'I';
          stageModel.intituleCtrl.text = s['intitule'] ?? '';
          stageModel.entrepriseCtrl.text = s['entreprise'] ?? '';
          stageModel.villeCtrl.text = s['ville'] ?? '';
          stageModel.paysCtrl.text = s['pays'] ?? '';
          stageModel.descriptionCtrl.text = s['description'] ?? '';
          _stages.add(stageModel);
        }
      }
    }
  }

  @override
  void dispose() {
    _nomCtrl.dispose(); 
    _prenomCtrl.dispose(); 
    _dateNaissanceCtrl.dispose();
    _emailCtrl.dispose(); 
    _telCtrl.dispose();
    _promoCtrl.dispose();
    _posteCtrl.dispose(); 
    _entrepriseCtrl.dispose(); 
    _descriptionPosteCtrl.dispose();
    _dateDebutCtrl.dispose();
    _villeCtrl.dispose(); 
    _paysCtrl.dispose();
    
    for (var stage in _stages) {
      stage.dispose();
    }
    super.dispose();
  }

  void _ajouterStage() {
    setState(() {
      _stages.add(StageFormModel());
    });
  }

  void _supprimerStage(int index) {
    setState(() {
      _stages[index].dispose();
      _stages.removeAt(index);
    });
  }

  Future<void> _soumettreFormulaire() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      double? latPoste, lonPoste;
      var coordsPoste = await _obtenirCoordonnees(_villeCtrl.text, _paysCtrl.text);
      if (coordsPoste != null) {
        latPoste = coordsPoste['lat'];
        lonPoste = coordsPoste['lon'];
      }
      Map<String, dynamic> data = {
        "nom": _nomCtrl.text.trim(),
        "prenom": _prenomCtrl.text.trim(),
        "dateNaissance": _dateNaissanceCtrl.text.trim(),
        "sexe": _sexeSelectionne,
        "email": _emailCtrl.text.trim(),
        "tel": _telCtrl.text.trim(),
        "autor":_consent,
        "promo": int.tryParse(_promoCtrl.text) ?? 2024,
        "filiere": _filiereSelectionnee,
        "formation": _formationSelectionnee,
        "majeure": _majeureSelectionnee ?? "",
        "option": _optionSelectionnee ?? "",
        "job": _posteCtrl.text.trim(),
        "poste": _posteCtrl.text.trim(),
        "entreprise": _entrepriseCtrl.text.trim(),
        "description": _descriptionPosteCtrl.text.trim(),
        "debut": _dateDebutCtrl.text.trim(),
        "ville": _villeCtrl.text.trim(),
        "pays": _paysCtrl.text.trim(),
        "latitude": latPoste,
        "longitude": lonPoste,
      };

      List<Map<String, dynamic>> stagesList = [];
      for (var s in _stages) {
        var stageMap = s.toMap();
        
        var coordsStage = await _obtenirCoordonnees(s.villeCtrl.text, s.paysCtrl.text);
        if (coordsStage != null) {
          stageMap['latitude'] = coordsStage['lat'];
          stageMap['longitude'] = coordsStage['lon'];
        }
        stagesList.add(stageMap);
      }

      if (stagesList.isNotEmpty) {
        data["stages"] = stagesList;
      }

      if (_stages.isNotEmpty) {
        data["stages"] = _stages.map((s) => s.toMap()).toList();
      }

      if (widget.isAdmin) {          
        await DatabaseService().ajouterEleve(data);
        if (widget.requestId != null) {
          await DatabaseService().supprimerDemande(widget.requestId!);
        }
      } else {
        await DatabaseService().demanderAjoutEleve(data);
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
   List<String>? optionsDisponibles;

    if (_filiereSelectionnee.isNotEmpty && _majeureSelectionnee != null) {
      var mapFiliere = _hierarchieFormation[_filiereSelectionnee];
      
      if (mapFiliere != null) {
        optionsDisponibles = mapFiliere[_majeureSelectionnee];
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
              _titreSection("Identité", Icons.person, Colors.purple),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _nomCtrl,
                      decoration: const InputDecoration(labelText: "Nom *", border: OutlineInputBorder()),
                      validator: (value) => value == null || value.isEmpty ? 'Requis' : null,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: _prenomCtrl,
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
                      controller: _dateNaissanceCtrl,
                      decoration: const InputDecoration(
                        labelText: "Date de naissance", 
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.cake),
                      ),
                      readOnly: true,
                      onTap: () => _selectionnerDate(context, _dateNaissanceCtrl),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _sexeSelectionne,
                      decoration: const InputDecoration(labelText: "Sexe", border: OutlineInputBorder()),
                      items: const [
                        DropdownMenuItem(value: 'I', child: Text("Inconnu")),
                        DropdownMenuItem(value: 'M', child: Text("Homme")),
                        DropdownMenuItem(value: 'F', child: Text("Femme")),
                      ],
                      onChanged: (v) => setState(() => _sexeSelectionne = v!),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _emailCtrl,
                decoration: const InputDecoration(labelText: "Email", border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email)),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _telCtrl,
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

              _titreSection("Formation ENSI", Icons.school, Colors.orange),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _promoCtrl,
                      decoration: const InputDecoration(labelText: "Promo (ex: 2024) *", border: OutlineInputBorder()),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: (value) => value == null || value.isEmpty ? 'Requis' : null,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _formationSelectionnee,
                      decoration: const InputDecoration(labelText: "Formation", border: OutlineInputBorder()),
                      items: const [
                        DropdownMenuItem(value: 'FISE', child: Text("FISE (Etudiant)")),
                        DropdownMenuItem(value: 'FISA', child: Text("FISA (Alternance)")),
                        DropdownMenuItem(value: 'MTS', child: Text("MTS (Mastère)")),
                      ],
                      onChanged: (v) => setState(() => _formationSelectionnee = v!),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _filiereSelectionnee,
                      decoration: const InputDecoration(labelText: "Filière", border: OutlineInputBorder()),
                      items: _hierarchieFormation.keys.map((String filiere) {
                        return DropdownMenuItem(value: filiere, child: Text(filiere, overflow: TextOverflow.ellipsis));
                      }).toList(),
                      onChanged: (v) {
                        setState(() {
                          _filiereSelectionnee = v!;
                          _majeureSelectionnee = null;
                          _optionSelectionnee = null;
                        });
                      },
                    ),
                  ),
                  
                  const SizedBox(width: 10),

                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _majeureSelectionnee,
                      decoration: const InputDecoration(labelText: "Majeure", border: OutlineInputBorder()),
                      isExpanded: true,
                      items: _filiereSelectionnee.isEmpty || _hierarchieFormation[_filiereSelectionnee] == null
                          ? []
                          : _hierarchieFormation[_filiereSelectionnee]!.keys.map((String majeure) {
                              return DropdownMenuItem(
                                value: majeure, 
                                child: Text(majeure, overflow: TextOverflow.ellipsis)
                              );
                            }).toList(),
                      onChanged: (v) {
                        setState(() {
                          _majeureSelectionnee = v;
                          _optionSelectionnee = null;
                        });
                      },
                    ),
                  ),
                ],
              ),

              if ( optionsDisponibles != null && optionsDisponibles.isNotEmpty)...[
              const SizedBox(height : 10),
                DropdownButtonFormField<String>(
                      value: _optionSelectionnee,
                      decoration: const InputDecoration(labelText: "Option", border: OutlineInputBorder()),
                      isExpanded: true,
                      items: optionsDisponibles.map((String option) {
                        return DropdownMenuItem(
                          value: option, 
                          child: Text(option, overflow: TextOverflow.ellipsis)
                        );
                      }).toList(),
                      onChanged: (v) => setState(() => _optionSelectionnee = v),
                    ),
              ],

              const Divider(height: 30),

              _titreSection("Poste Actuel", Icons.work, Colors.indigo),
              TextFormField(
                controller: _posteCtrl,
                decoration: const InputDecoration(labelText: "Intitulé du poste", border: OutlineInputBorder()),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _entrepriseCtrl,
                decoration: const InputDecoration(labelText: "Entreprise", border: OutlineInputBorder()),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _villeCtrl,
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
                controller: _descriptionPosteCtrl,
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
                      controller: _dateDebutCtrl,
                      decoration: const InputDecoration(
                        labelText: "Date de début", 
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.calendar_today),
                      ),
                      readOnly: true,
                      onTap: () => _selectionnerDate(context, _dateDebutCtrl),
                    ),
                  ),
                  ],
              ),

              const Divider(height: 30),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _titreSection("Stages", Icons.work_history, Colors.green),
                  TextButton.icon(
                    onPressed: _ajouterStage,
                    icon: const Icon(Icons.add_circle, color: AppColors.ensiCyan),
                    label: const Text("Ajouter un stage", style: TextStyle(color: AppColors.ensiCyan)),
                  ),
                ],
              ),

              if (_stages.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text("Aucun stage ajouté (facultatif)", style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic)),
                )
              else
                ..._stages.asMap().entries.map((entry) {
                  int index = entry.key;
                  StageFormModel stage = entry.value;

                  return Card(
                    key: stage.key,
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
                            value: stage.anneeSelectionnee,
                            decoration: const InputDecoration(labelText: "Année du stage", border: OutlineInputBorder()),
                            items: const [
                              DropdownMenuItem(value: '1A', child: Text("1ère Année (1A)")),
                              DropdownMenuItem(value: '2A', child: Text("2ème Année (2A)")),
                              DropdownMenuItem(value: '3A', child: Text("PFE (3A)")),
                            ],
                            onChanged: (v) => stage.anneeSelectionnee = v!,
                          ),
                            const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: stage.dateDebutCtrl,
                                  decoration: const InputDecoration(
                                    labelText: "Date de début", 
                                    border: OutlineInputBorder(),
                                    prefixIcon: Icon(Icons.calendar_today),
                                  ),
                                  readOnly: true,
                                  onTap: () => _selectionnerDate(context, stage.dateDebutCtrl),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: TextFormField(
                                  controller: stage.dateFinCtrl,
                                  decoration: const InputDecoration(
                                    labelText: "Date de fin", 
                                    border: OutlineInputBorder(),
                                    prefixIcon: Icon(Icons.event),
                                  ),
                                  readOnly: true,
                                  onTap: () => _selectionnerDate(context, stage.dateFinCtrl),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: stage.intituleCtrl,
                            decoration: const InputDecoration(labelText: "Sujet / Intitulé *", border: OutlineInputBorder()),
                            validator: (value) => value == null || value.isEmpty ? 'Requis' : null,
                          ),
                          const SizedBox(height: 10),
                         FormField<String>(
                            validator: (value) {
                              if (stage.typeStage == 'I') {
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
                                          groupValue: stage.typeStage,
                                          activeColor: AppColors.ensiCyan,
                                          contentPadding: EdgeInsets.zero,
                                          onChanged: (value) {
                                            setState(() {
                                              stage.typeStage = value!;
                                              state.didChange(value);
                                            });
                                          },
                                        ),
                                      ),
                                      Expanded(
                                        child: RadioListTile<String>(
                                          title: const Text('Université'),
                                          value: 'U',
                                          groupValue: stage.typeStage,
                                          activeColor: AppColors.ensiCyan,
                                          contentPadding: EdgeInsets.zero,
                                          onChanged: (value) {
                                            setState(() {
                                              stage.typeStage = value!;
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
                            controller: stage.entrepriseCtrl,
                            decoration: const InputDecoration(labelText: "Nom de l'Entreprise / du Labo", border: OutlineInputBorder()),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(child: TextFormField(controller: stage.villeCtrl, decoration: const InputDecoration(labelText: "Ville", border: OutlineInputBorder()))),
                              const SizedBox(width: 10),
                              Expanded(child: TextFormField(controller: stage.paysCtrl, decoration: const InputDecoration(labelText: "Pays", border: OutlineInputBorder()))),
                            ],
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: stage.descriptionCtrl,
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
                      await DatabaseService().supprimerDemande(widget.requestId!);
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
                onPressed: _isLoading ? null : _soumettreFormulaire,
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

 Widget _titreSection(String titre, IconData icon, Color color) {
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