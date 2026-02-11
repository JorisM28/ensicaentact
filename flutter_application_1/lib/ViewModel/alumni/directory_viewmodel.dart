import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../Model/alumnis.dart';
import '../../../Model/data/services/database_service.dart';

class DirectoryViewModel extends ChangeNotifier {
  final Map<String, dynamic> user;

  List<Alumnis> _allAlumni = [];
  List<Alumnis> _alumniPoster = [];
  Alumnis? selectedStudent;

  bool loading = true;
  bool openFilters = false;
  int numberWaitingRequest = 0;

  final TextEditingController searchController = TextEditingController();
  final Set<String> promotionFilterSelected = {};
  final Set<String> sectorFilterSelected = {};
  final Set<String> internshipCountryFilterSelected = {};
  final ScrollController scrollController = ScrollController();

  DirectoryViewModel({required this.user});

  bool get isAdmin => user['role'] == 'admin';
  List<Alumnis> get alumniPoster => _alumniPoster;

  List<String> get promotionAvailable {
    final promos = _allAlumni
        .map((e) => e.promotion.toString())
        .where((e) => e != "0" && e.isNotEmpty)
        .toSet()
        .toList();
    promos.sort();
    return promos;
  }

  List<String> get sectorAvailable {
    final sector = _allAlumni
        .map((e) => e.sector)
        .where((e) => e.isNotEmpty)
        .toSet()
        .toList();
    sector.sort();
    return sector;
  }

  List<String> get internshipCountryAvailable {
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

  Future<void> loadInitialData() async {
    try {
      var data = await DatabaseService().getAllStudent();
      _allAlumni = data;
      _alumniPoster = data;
      loading = false;

      if (searchController.text.isNotEmpty ||
          promotionFilterSelected.isNotEmpty ||
          sectorFilterSelected.isNotEmpty ||
          internshipCountryFilterSelected.isNotEmpty) {
        filterResults(searchController.text);
      } else {
        notifyListeners();
      }
    } catch (e) {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> loadCounterNotifications() async {
    if (!isAdmin) return;
    try {
      var request = await DatabaseService().getWaitingRequests();
      numberWaitingRequest = request.length;
      notifyListeners();
    } catch (e) {
      debugPrint("Erreur notifs: $e");
    }
  }

  void filterResults(String recherche) {
    List<Alumnis> results = _allAlumni;

    if (recherche.isNotEmpty) {
      results = results.where((eleve) {
        final query = recherche.toLowerCase();
        return eleve.wholeName.toLowerCase().contains(query) ||
            eleve.job.toLowerCase().contains(query) ||
            eleve.company.toLowerCase().contains(query);
      }).toList();
    }

    if (promotionFilterSelected.isNotEmpty) {
      results = results.where((e) => promotionFilterSelected.contains(e.promotion.toString())).toList();
    }
    if (sectorFilterSelected.isNotEmpty) {
      results = results.where((e) => sectorFilterSelected.contains(e.sector)).toList();
    }
    if (internshipCountryFilterSelected.isNotEmpty) {
      results = results.where((eleve) {
        return eleve.internships.any((s) => internshipCountryFilterSelected.contains(s.country));
      }).toList();
    }

    _alumniPoster = results;
    if (selectedStudent != null && !results.contains(selectedStudent)) {
      selectedStudent = null;
    }
    notifyListeners();
  }

  void toggleFilters() {
    openFilters = !openFilters;
    notifyListeners();
  }

  void selectStudent(Alumnis student) {
    selectedStudent = student;
    notifyListeners();
  }

  void clearSearch() {
    searchController.clear();
    filterResults('');
  }

  Future<void> deleteStudent(Alumnis student) async {
    await DatabaseService().deleteStudents(student.lastName, student.firstname);
    _allAlumni.removeWhere((e) => e.id == student.id);
    if (selectedStudent?.id == student.id) selectedStudent = null;
    filterResults(searchController.text);
  }

  void changeKeyboardSelection(int direction) {
    if (_alumniPoster.isEmpty) return;
    if (selectedStudent == null) {
      selectStudent(_alumniPoster.first);
      return;
    }
    int currentIndex = _alumniPoster.indexOf(selectedStudent!);
    int newIndex = currentIndex + direction;

    if (newIndex >= 0 && newIndex < _alumniPoster.length) {
      selectStudent(_alumniPoster[newIndex]);
      if (scrollController.hasClients) {
        double target = newIndex * 90.0;
        scrollController.animateTo(
          target > 200 ? target - 200 : target,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    scrollController.dispose();
    super.dispose();
  }
}