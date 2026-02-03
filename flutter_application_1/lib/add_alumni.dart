import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'database_service.dart';
import 'colors.dart';

class StageFormModel {
  final Key key = UniqueKey();
  
  final TextEditingController intituleCtrl = TextEditingController();
  final TextEditingController entrepriseCtrl = TextEditingController();
  final TextEditingController villeCtrl = TextEditingController();
  final TextEditingController paysCtrl = TextEditingController();
  final TextEditingController descriptionCtrl = TextEditingController();

  String anneeSelectionnee = '2A';

  void dispose() {
    intituleCtrl.dispose();
    entrepriseCtrl.dispose();
    villeCtrl.dispose();
    paysCtrl.dispose();
    descriptionCtrl.dispose();
  }

  Map<String, dynamic> toMap() {
    return {
      "intitule": intituleCtrl.text.trim(),
      "annee": anneeSelectionnee,
      "entreprise": entrepriseCtrl.text.trim(),
      "ville": villeCtrl.text.trim(),
      "pays": paysCtrl.text.trim(),
      "description": descriptionCtrl.text.trim(),
    };
  }
}

class AddAlumniForm extends StatefulWidget {
  final VoidCallback? onSuccess;
  final bool isAdmin;

const AddAlumniForm({super.key, this.onSuccess, this.isAdmin=false});

  @override
  State<AddAlumniForm> createState() => _AddAlumniFormState();
}

class _AddAlumniFormState extends State<AddAlumniForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool? consent = false;

  final _nomCtrl = TextEditingController();
  final _prenomCtrl = TextEditingController();
  final _ageCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _telCtrl = TextEditingController();
  String _sexeSelectionne = 'I';

  final _promoCtrl = TextEditingController();
  String _formationSelectionnee = 'FISE';
  String _filiereSelectionnee = 'Informatique';

  final _posteCtrl = TextEditingController();
  final _entrepriseCtrl = TextEditingController();
  final _villeCtrl = TextEditingController();
  final _paysCtrl = TextEditingController();

  final List<StageFormModel> _stages = [];

  @override
  void dispose() {
    _nomCtrl.dispose(); _prenomCtrl.dispose(); _ageCtrl.dispose();
    _emailCtrl.dispose(); _telCtrl.dispose();
    _promoCtrl.dispose();
    _posteCtrl.dispose(); _entrepriseCtrl.dispose(); 
    _villeCtrl.dispose(); _paysCtrl.dispose();
    
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
      Map<String, dynamic> data = {
        "nom": _nomCtrl.text.trim(),
        "prenom": _prenomCtrl.text.trim(),
        "age": int.tryParse(_ageCtrl.text) ?? 0,
        "sexe": _sexeSelectionne,
        "email": _emailCtrl.text.trim(),
        "tel": _telCtrl.text.trim(),
        "autor":consent,
        "promo": int.tryParse(_promoCtrl.text) ?? 2024,
        "filiere": _filiereSelectionnee,
        "formation": _formationSelectionnee,
        "job": _posteCtrl.text.trim(),
        "poste": _posteCtrl.text.trim(),
        "entreprise": _entrepriseCtrl.text.trim(),
        "ville": _villeCtrl.text.trim(),
        "pays": _paysCtrl.text.trim(),
      };

      if (_stages.isNotEmpty) {
        data["stages"] = _stages.map((s) => s.toMap()).toList();
      }

      if (widget.isAdmin) {
        await DatabaseService().ajouterEleve(data);
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
                      controller: _ageCtrl,
                      decoration: const InputDecoration(labelText: "Âge", border: OutlineInputBorder()),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
                value: consent,
                onChanged: (value) {
                  setState(() {
                    consent = value!;
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
              Row (children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _filiereSelectionnee,
                  decoration: const InputDecoration(labelText: "Filière", border: OutlineInputBorder()),
                  items: const [
                    DropdownMenuItem(value: 'Informatique', child: Text("Informatique")),
                    DropdownMenuItem(value: 'Matériaux Chimie', child: Text("Matériaux Chimie")),
                    DropdownMenuItem(value: 'Systèmes Embarqués', child: Text("Systèmes Embarqués")),
                  ],
                  onChanged: (v) => setState(() => _filiereSelectionnee = v!),
                  validator: (value) => value == null || value.isEmpty ? 'Requis' : null,
                ),
              ),
              ],
              ),

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
                          TextFormField(
                            controller: stage.intituleCtrl,
                            decoration: const InputDecoration(labelText: "Sujet / Intitulé *", border: OutlineInputBorder()),
                            validator: (value) => value == null || value.isEmpty ? 'Requis' : null,
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: stage.entrepriseCtrl,
                            decoration: const InputDecoration(labelText: "Entreprise / Labo", border: OutlineInputBorder()),
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