import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/service_locator.dart';
import '/l10n/app_localizations.dart';
import '/View/theme/colors.dart';
import '/ViewModel/alumni/add_alumni_viewmodel.dart';

class StageFormModel {
  final Key key = UniqueKey();
  final TextEditingController controllerEntitled = TextEditingController();
  final TextEditingController controllerCompany = TextEditingController();
  final TextEditingController controllerCity = TextEditingController();
  final TextEditingController controllerPostalCode = TextEditingController();
  final TextEditingController controllerCountry = TextEditingController();
  final TextEditingController controllerDescription = TextEditingController();
  final TextEditingController controllerStartDate = TextEditingController();
  final TextEditingController controllerEndDate = TextEditingController();
  String internshipType = 'I';
  String selectedYear = '2A';

  void dispose() {
    controllerEntitled.dispose();
    controllerCompany.dispose();
    controllerCity.dispose();
    controllerPostalCode.dispose();
    controllerCountry.dispose();
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
      "code_postal": controllerPostalCode.text.trim(),
      "pays": controllerCountry.text.trim(),
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

  const AddAlumniForm({super.key, this.onSuccess, this.isAdmin = false, this.initialData, this.requestId});

  @override
  State<AddAlumniForm> createState() => _AddAlumniFormState();
}

class _AddAlumniFormState extends State<AddAlumniForm> {
  final AddAlumniViewModel _viewModel = sl<AddAlumniViewModel>();
  final _formKey = GlobalKey<FormState>();
  bool? _consent = false;

  final _controllerLastName = TextEditingController();
  final _controllerFirstName = TextEditingController();
  final _controllerDateOfBirth = TextEditingController();
  final _controllereMail = TextEditingController();
  final _controllerPassword = TextEditingController();
  bool _obscurePassword = true;
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
  final _controllerPostalCode = TextEditingController();
  final _controllerCountry = TextEditingController();

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

  String type = 'E';
  final List<StageFormModel> _internships = [];

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      locale: Locale(Localizations.localeOf(context).languageCode),
    );

    if (picked != null) {
      setState(() {
        controller.text = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
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
      _controllerPostalCode.text = data['code_postal'] ?? '';
      _controllerCountry.text = data['pays'] ?? '';

      if (data['stages'] != null) {
        for (var s in data['stages']) {
          var stageModel = StageFormModel();
          stageModel.selectedYear = s['annee'] ?? '2A';
          stageModel.internshipType = s['type'] ?? 'I';
          stageModel.controllerEntitled.text = s['intitule'] ?? '';
          stageModel.controllerCompany.text = s['entreprise'] ?? '';
          stageModel.controllerCity.text = s['ville'] ?? '';
          stageModel.controllerCountry.text = s['pays'] ?? '';
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
    _controllerPassword.dispose();
    _controllerPhone.dispose();
    _controllerPromotion.dispose();
    _controllerPosition.dispose();
    _controllerCompany.dispose();
    _controllerPositionDescription.dispose();
    _controllerStartDate.dispose();
    _controllerCity.dispose();
    _controllerPostalCode.dispose();
    _controllerCountry.dispose();

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

  void _deleteInternship(int index) {
    setState(() {
      _internships[index].dispose();
      _internships.removeAt(index);
    });
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    Map<String, dynamic> data = {
      "nom": _controllerLastName.text.trim(),
      "prenom": _controllerFirstName.text.trim(),
      "dateNaissance": _controllerDateOfBirth.text.trim(),
      "sexe": _selectedGender,
      "email": _controllereMail.text.trim(),
      "password": _controllerPassword.text.trim(),
      "tel": _controllerPhone.text.trim(),
      "autor": _consent,
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
      "code_postal": _controllerPostalCode.text.trim(),
      "pays": _controllerCountry.text.trim(),
    };

    List<Map<String, dynamic>> internshipsData = _internships.map((s) => s.toMap()).toList();

    try {
      await _viewModel.submitForm(
        alumniData: data,
        internshipsData: internshipsData,
        isAdmin: widget.isAdmin,
        requestId: widget.requestId,
      );

      if (widget.onSuccess != null) widget.onSuccess!();

      if (mounted) {
        final traductions = AppLocalizations.of(context)!;
        String msg = widget.isAdmin ? traductions.formMsgAdded : traductions.formMsgPending;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.green));
      }
    } catch (e) {
      if (mounted) {
        final traductions = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(traductions.formMsgError(e.toString())), backgroundColor: Colors.red)
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final traductions = AppLocalizations.of(context)!;
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
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0, top: 10.0),
                child: Text(
                  traductions.addAlumniFormTitle,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.ensiCyan,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              _sectionTitle(traductions.formIdentityTitle, Icons.person, Colors.purple),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _controllerLastName,
                      decoration: InputDecoration(labelText: "${traductions.detailLabelLastName} *", border: const OutlineInputBorder()),
                      validator: (value) => value == null || value.isEmpty ? traductions.formRequired : null,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: _controllerFirstName,
                      decoration: InputDecoration(labelText: "${traductions.detailLabelFirstName} *", border: const OutlineInputBorder()),
                      validator: (value) => value == null || value.isEmpty ? traductions.formRequired : null,
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
                      decoration: InputDecoration(
                        labelText: traductions.detailLabelBirthDate,
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.cake),
                      ),
                      readOnly: true,
                      onTap: () => _selectDate(context, _controllerDateOfBirth),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedGender,
                      decoration: InputDecoration(labelText: traductions.typeLabel, border: const OutlineInputBorder()),
                      items: [
                        DropdownMenuItem(value: 'I', child: Text(traductions.formGenderUnknown)),
                        DropdownMenuItem(value: 'M', child: Text(traductions.formGenderMale)),
                        DropdownMenuItem(value: 'F', child: Text(traductions.formGenderFemale)),
                      ],
                      onChanged: (v) => setState(() => _selectedGender = v!),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _controllereMail,
                decoration: InputDecoration(
                  labelText: "${traductions.profileEmail} *", 
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.email)
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) => value == null || value.isEmpty ? traductions.formRequired : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _controllerPassword,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: "${traductions.loginPasswordLabel} *",
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
                validator: (value) => value == null || value.isEmpty ? traductions.formRequired : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _controllerPhone,
                decoration: InputDecoration(labelText: traductions.profilePhone,border: const OutlineInputBorder(),prefixIcon: const Icon(Icons.phone)),
                keyboardType: TextInputType.phone,
              ),
              CheckboxListTile(
                title: Text(traductions.formConsent),
                value: _consent,
                onChanged: (value) {
                  setState(() {
                    _consent = value!;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
              ),

              const Divider(height: 30),

              _sectionTitle(traductions.formFormationTitle, Icons.school, Colors.orange),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _controllerPromotion,
                      decoration: InputDecoration(labelText: traductions.formPromoHint, border: const OutlineInputBorder()),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: (value) => value == null || value.isEmpty ? traductions.formRequired : null,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedFormation,
                      decoration: InputDecoration(labelText: traductions.detailInfoStudies, border: const OutlineInputBorder()),
                      items: [
                        DropdownMenuItem(value: 'FISE', child: Text(traductions.formFormationFISE)),
                        DropdownMenuItem(value: 'FISA', child: Text(traductions.formFormationFISA)),
                        DropdownMenuItem(value: 'MTS', child: Text(traductions.formFormationMTS)),
                      ],
                      onChanged: (v) => setState(() => _selectedFormation = v!),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedSector,
                      decoration: InputDecoration(labelText: traductions.detailLabelSector, border: const OutlineInputBorder()),
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
                      decoration: InputDecoration(labelText: traductions.detailLabelSpecialisation, border: const OutlineInputBorder()),
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

              if (availableOption != null && availableOption.isNotEmpty)...[
                const SizedBox(height : 10),
                DropdownButtonFormField<String>(
                  value: _selectedOption,
                  decoration: InputDecoration(labelText: traductions.detailLabelOption, border: const OutlineInputBorder()),
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

              _sectionTitle(traductions.formJobTitle, Icons.work, Colors.indigo),
              TextFormField(
                controller: _controllerPosition,
                decoration: InputDecoration(labelText: traductions.detailLabelJob, border: const OutlineInputBorder()),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _controllerCompany,
                decoration: InputDecoration(labelText: traductions.detailLabelCompany, border: const OutlineInputBorder()),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _controllerCity,
                      decoration: InputDecoration(labelText: traductions.detailLabelCity, border: const OutlineInputBorder()),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: _controllerPostalCode,
                      decoration: InputDecoration(labelText: traductions.detailLabelPostalCode, border: const OutlineInputBorder()),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: _controllerCountry,
                      decoration: InputDecoration(labelText: traductions.detailLabelCountry, border: const OutlineInputBorder()),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _controllerPositionDescription,
                decoration: InputDecoration(
                  labelText: traductions.detailLabelJobDesc,
                  border: const OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                maxLines: 4,
                keyboardType: TextInputType.multiline,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _controllerStartDate,
                      decoration: InputDecoration(
                        labelText: traductions.detailLabelStartDate,
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.calendar_today),
                      ),
                      readOnly: true,
                      onTap: () => _selectDate(context, _controllerStartDate),
                    ),
                  ),
                ],
              ),

              const Divider(height: 30),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _sectionTitle(traductions.formInternshipsTitle, Icons.work_history, Colors.green),
                  TextButton.icon(
                    onPressed: _addInternship,
                    icon: const Icon(Icons.add_circle, color: AppColors.ensiCyan),
                    label: Text(traductions.detailInternshipAdd, style: const TextStyle(color: AppColors.ensiCyan)),
                  ),
                ],
              ),

              if (_internships.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(traductions.formNoInternship, style: const TextStyle(color: Colors.grey, fontStyle: FontStyle.italic)),
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
                              Text("${traductions.detailInternshipTitle} #${index + 1}", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                tooltip: traductions.deleteBtn,
                                onPressed: () => _deleteInternship(index),
                              ),
                            ],
                          ),
                          DropdownButtonFormField<String>(
                            value: intership.selectedYear,
                            decoration: InputDecoration(labelText: traductions.formInternshipYear, border: const OutlineInputBorder()),
                            items: [
                              DropdownMenuItem(value: '1A', child: Text(traductions.formInternship1A)),
                              DropdownMenuItem(value: '2A', child: Text(traductions.formInternship2A)),
                              DropdownMenuItem(value: '3A', child: Text(traductions.formInternship3A)),
                            ],
                            onChanged: (v) => intership.selectedYear = v!,
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: intership.controllerStartDate,
                                  decoration: InputDecoration(
                                    labelText: traductions.detailLabelStartDate,
                                    border: const OutlineInputBorder(),
                                    prefixIcon: const Icon(Icons.calendar_today),
                                  ),
                                  readOnly: true,
                                  onTap: () => _selectDate(context, intership.controllerStartDate),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: TextFormField(
                                  controller: intership.controllerEndDate,
                                  decoration: InputDecoration(
                                    labelText: traductions.detailLabelBirthDate,
                                    border: const OutlineInputBorder(),
                                    prefixIcon: const Icon(Icons.event),
                                  ),
                                  readOnly: true,
                                  onTap: () => _selectDate(context, intership.controllerEndDate),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: intership.controllerEntitled,
                            decoration: InputDecoration(labelText: traductions.formInternshipSubject, border: const OutlineInputBorder()),
                            validator: (value) => value == null || value.isEmpty ? traductions.formRequired : null,
                          ),
                          const SizedBox(height: 10),
                          FormField<String>(
                            validator: (value) {
                              if (intership.internshipType == 'I') {
                                return traductions.formInternshipStructureReq;
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
                                          title: Text(traductions.detailInternshipCompany),
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
                                          title: Text(traductions.detailInternshipUniversity),
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
                            decoration: InputDecoration(labelText: traductions.formInternshipLab, border: const OutlineInputBorder()),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(child: TextFormField(controller: intership.controllerCity, decoration: InputDecoration(labelText: traductions.detailLabelCity, border: const OutlineInputBorder()))),
                              const SizedBox(width: 10),
                              Expanded(child: TextFormField(controller: intership.controllerPostalCode, decoration: InputDecoration(labelText: traductions.detailLabelPostalCode, border: const OutlineInputBorder()))),
                              const SizedBox(width: 10),
                              Expanded(child: TextFormField(controller: intership.controllerCountry, decoration: InputDecoration(labelText: traductions.detailLabelCountry, border: const OutlineInputBorder()))),
                            ],
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: intership.controllerDescription,
                            decoration: InputDecoration(
                              labelText: traductions.detailInternshipDescription,
                              border: const OutlineInputBorder(),
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
                  child: ListenableBuilder(
                      listenable: _viewModel,
                      builder: (context, _) {
                        return ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                          ),
                          onPressed: _viewModel.isLoading ? null : () async {
                            bool confirm = await showDialog(
                                context: context,
                                builder: (c) => AlertDialog(
                                  title: Text(traductions.formAdminRejectTitle),
                                  content: Text(traductions.formAdminRejectContent),
                                  actions: [
                                    TextButton(onPressed: () => Navigator.pop(c, false), child: Text(traductions.cancel)),
                                    TextButton(onPressed: () => Navigator.pop(c, true), child: Text(traductions.formAdminRejectConfirm)),
                                  ],
                                )
                            ) ?? false;

                            if (confirm) {
                              await _viewModel.rejectRequest(widget.requestId!);
                              if (widget.onSuccess != null) widget.onSuccess!();
                              if (mounted) Navigator.pop(context);
                            }
                          },
                          icon: const Icon(Icons.delete_forever, color: Colors.white),
                          label: Text(traductions.formAdminRejectButton, style: const TextStyle(color: Colors.white)),
                        );
                      }
                  ),
                ),

              ListenableBuilder(
                  listenable: _viewModel,
                  builder: (context, _) {
                    return ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.ensiCyan,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      onPressed: _viewModel.isLoading ? null : _handleSubmit,
                      icon: _viewModel.isLoading
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : const Icon(Icons.save, color: Colors.white),
                      label: Text(
                          _viewModel.isLoading ? traductions.formSaveLoading : traductions.formSaveButton,
                          style: const TextStyle(color: Colors.white, fontSize: 16)
                      ),
                    );
                  }
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