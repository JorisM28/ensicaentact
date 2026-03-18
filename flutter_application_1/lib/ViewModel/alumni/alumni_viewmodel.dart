import 'package:flutter/material.dart';
import '/Model/alumnis.dart';
import '/service_locator.dart';
import '/Model/data/services/alumni_repository.dart';

class InternshipEditor {
  final TextEditingController entilted = TextEditingController();
  final TextEditingController entreprise = TextEditingController();
  final TextEditingController city = TextEditingController();
  final TextEditingController country = TextEditingController();
  final TextEditingController description = TextEditingController();
  final TextEditingController year = TextEditingController();
  final TextEditingController start = TextEditingController();
  final TextEditingController end = TextEditingController();
  String type = "E";

  void dispose() {
    entilted.dispose(); entreprise.dispose(); city.dispose();
    country.dispose(); description.dispose(); year.dispose();
    start.dispose(); end.dispose();
  }
}

class AlumniViewModel extends ChangeNotifier {
  late Alumnis currentAlumni;
  bool isEdited = false;
  bool modified = false;
  bool seeDescription = false;

  late TextEditingController lastNameController;
  late TextEditingController firstNameController;
  late TextEditingController dateOfBirthController;
  late TextEditingController promotionController;
  late TextEditingController positionController;
  late TextEditingController positionDescController;
  late TextEditingController startPosDateController;
  late TextEditingController companyController;
  late TextEditingController cityController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController sectorController;
  late TextEditingController specialisationController;
  late TextEditingController optionController;
  late TextEditingController doubleDiplomaController;

  String selectedGender = 'I';
  String selectedFormation = 'FISE';
  bool permissionSwitch = false;
  bool deceasedSwitch = false;

  List<InternshipEditor> internshipEditors = [];
  List<Internship> internshipDisplay = [];

  AlumniViewModel(Alumnis alumni) {
    currentAlumni = alumni;
    _initControllers();
  }

  void _initControllers() {
    lastNameController = TextEditingController(text: currentAlumni.lastName);
    firstNameController = TextEditingController(text: currentAlumni.firstname);
    dateOfBirthController = TextEditingController(text: currentAlumni.dateOfBirth);
    promotionController = TextEditingController(text: currentAlumni.promotion.toString());
    positionController = TextEditingController(text: currentAlumni.job);
    positionDescController = TextEditingController(text: currentAlumni.jobDescription);
    startPosDateController = TextEditingController(text: currentAlumni.jobStart);
    companyController = TextEditingController(text: currentAlumni.company);
    cityController = TextEditingController(text: currentAlumni.city);
    emailController = TextEditingController(text: currentAlumni.email);
    phoneController = TextEditingController(text: currentAlumni.phone);
    sectorController = TextEditingController(text: currentAlumni.sector);
    specialisationController = TextEditingController(text: currentAlumni.specialisation);
    optionController = TextEditingController(text: currentAlumni.option);
    doubleDiplomaController = TextEditingController(text: currentAlumni.doubleDiploma);

    selectedGender = ['M', 'F', 'I'].contains(currentAlumni.gender) ? currentAlumni.gender : 'I';
    selectedFormation = ['FISE', 'FISA', 'MTS'].contains(currentAlumni.formation) ? currentAlumni.formation : 'FISE';
    permissionSwitch = currentAlumni.permission == 1;
    deceasedSwitch = currentAlumni.deceased == 1;

    internshipDisplay = List.from(currentAlumni.internships);
    initialiserStageEditors();
  }

  void initialiserStageEditors() {
    for (var editor in internshipEditors) editor.dispose();
    internshipEditors.clear();
    for (var stage in internshipDisplay) {
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
      internshipEditors.add(editor);
    }
  }

  void toggleEdit() {
    isEdited = !isEdited;
    if (isEdited) initialiserStageEditors();
    notifyListeners();
  }

  void addInternship() {
    internshipEditors.add(InternshipEditor());
    notifyListeners();
  }

  void deleteInternship(int index) {
    internshipEditors[index].dispose();
    internshipEditors.removeAt(index);
    notifyListeners();
  }

  String calculateAge(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return "";
    try {
      DateTime dn = DateTime.parse(dateStr);
      DateTime now = DateTime.now();
      int age = now.year - dn.year;
      if (now.month < dn.month || (now.month == dn.month && now.day < dn.day)) age--;
      return "$age";
    } catch (e) { return ""; }
  }

  String calculateSeniority(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return "";
    try {
      DateTime start = DateTime.parse(dateStr);
      DateTime now = DateTime.now();
      int months = (now.year - start.year) * 12 + now.month - start.month;
      if (months < 1) return "Moins d'un mois";
      if (months < 12) return "$months mois";
      int years = months ~/ 12;
      return "$years ";
    } catch (e) { return ""; }
  }

  Future<void> save(BuildContext context, VoidCallback? onSaveCallback) async {
    int promoInt = int.tryParse(promotionController.text) ?? currentAlumni.promotion;
    int permissionInt = permissionSwitch ? 1 : 0;
    int deceasedInt = deceasedSwitch ? 1 : 0;

    List<Map<String, dynamic>> stagesData = internshipEditors.map((editor) => {
      "intitule": editor.entilted.text.trim(),
      "entreprise": editor.entreprise.text.trim(),
      "ville": editor.city.text.trim(),
      "pays": editor.country.text.trim(),
      "description": editor.description.text.trim(),
      "annee": editor.year.text.trim(),
      "type": editor.type.trim(),
      "debut": editor.start.text.trim(),
      "fin": editor.end.text.trim(),
    }).toList();

    Map<String, dynamic> updateData = {
      "id": currentAlumni.id,
      "nom": lastNameController.text.trim(),
      "prenom": firstNameController.text.trim(),
      "dateNaissance": dateOfBirthController.text.trim(),
      "sexe": selectedGender,
      "promo": promoInt,
      "filiere": sectorController.text.trim(),
      "formation": selectedFormation,
      "majeure": specialisationController.text.trim(),
      "option": optionController.text.trim(),
      "diplome": doubleDiplomaController.text.trim(),
      "autor": permissionInt,
      "decede": deceasedInt,
      "poste": positionController.text.trim(),
      "description": positionDescController.text.trim(),
      "debut": startPosDateController.text.trim(),
      "entreprise": companyController.text.trim(),
      "ville": cityController.text.trim(),
      "email": emailController.text.trim(),
      "tel": phoneController.text.trim(),
      "stages": stagesData,
    };


    await sl<AlumniRepository>().updateAlumni(updateData);
    if (onSaveCallback != null) onSaveCallback();

    internshipDisplay = internshipEditors.map((e) => Internship(
      entitled: e.entilted.text,
      company: e.entreprise.text,
      city: e.city.text,
      country: e.country.text,
      description: e.description.text,
      year: e.year.text,
      type: e.type,
      startDate: e.start.text,
      endDate: e.end.text,
    )).toList();

    currentAlumni = Alumnis(
      id: currentAlumni.id,
      lastName: lastNameController.text.trim(),
      firstname: firstNameController.text.trim(),
      email: emailController.text.trim(),
      phone: phoneController.text.trim(),
      permission: permissionInt,
      deceased: deceasedInt,
      gender: selectedGender,
      dateOfBirth: dateOfBirthController.text.trim(),
      promotion: promoInt,
      sector: sectorController.text.trim(),
      formation: selectedFormation,
      specialisation: specialisationController.text.trim(),
      option: optionController.text.trim(),
      doubleDiploma: doubleDiplomaController.text.trim(),
      job: positionController.text.trim(),
      jobDescription: positionDescController.text.trim(),
      jobStart: startPosDateController.text.trim(),
      jobEnd: currentAlumni.jobEnd,
      company: companyController.text.trim(),
      city: cityController.text.trim(),
      country: currentAlumni.country,
      internships: internshipDisplay,
    );


    isEdited = false;
    modified = true;
    notifyListeners();
  }

  @override
  void dispose() {
    lastNameController.dispose(); firstNameController.dispose();
    dateOfBirthController.dispose(); promotionController.dispose();
    positionController.dispose(); positionDescController.dispose();
    startPosDateController.dispose(); companyController.dispose();
    cityController.dispose(); emailController.dispose();
    phoneController.dispose(); sectorController.dispose();
    specialisationController.dispose(); optionController.dispose();
    doubleDiplomaController.dispose();
    for (var editor in internshipEditors) editor.dispose();
    super.dispose();
  }
}