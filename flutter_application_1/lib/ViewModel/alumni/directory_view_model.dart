import 'package:flutter/material.dart';
import '../../Model/alumnis.dart';
import '../../Model/data/services/alumni_repository.dart';

class DirectoryViewModel extends ChangeNotifier {
  final AlumniRepository _repository;
  DirectoryViewModel({required AlumniRepository repository}) : _repository = repository;

  List<Alumnis> _allAlumnis = [];
  List<dynamic> _historyLogs = [];
  List<dynamic> get historyLogs => _historyLogs;
  int _pendingRequestsCount = 0;
  int get pendingRequestsCount => _pendingRequestsCount;

  List<Alumnis> _filteredAlumnis = [];
  bool _isLoading = false;

  List<Alumnis> get alumnis => _filteredAlumnis;
  bool get isLoading => _isLoading;

  String _searchQuery = "";
  
  Set<String> _selectedPromotion = {};
  Set<String> _selectedSectors = {};
  Set<String> _selectedCountries = {};
  List<String> get promosAvailable => _allAlumnis.map((e) => e.promotion  .toString()).toSet().toList()..sort();
  List<String> get sectorAvailable => _allAlumnis.map((e) => e.sector).where((e) => e.isNotEmpty).toSet().toList()..sort();
  
  List<String> get countriesAvailable {
    final Set<String> countries = {};
    for (var alumni in _allAlumnis) {
      for (var internship in alumni.internships) {
        if (internship.country.isNotEmpty) countries.add(internship.country);
      }
    }
    return countries.toList()..sort();
  }

  Set<String> get selectedPromotions => _selectedPromotion;
  Set<String> get selectedSectors => _selectedSectors;
  Set<String> get selectedCountries => _selectedCountries;

  Future<void> loadAlumnis() async {
    _isLoading = true;
    notifyListeners();

    try {
      _allAlumnis = await _repository.getAllAlumnis();
      _applyFilters();
    } catch (e) {
      print("Erreur ViewModel: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void search(String query) {
    _searchQuery = query;
    _applyFilters();
  }

  void togglePromoFilter(String promo, bool isActive) {
    isActive ? _selectedPromotion.add(promo) : _selectedPromotion.remove(promo);
    _applyFilters();
  }

  void toggleSectorFilter(String sector, bool isActive) {
    isActive ? _selectedSectors.add(sector) : _selectedSectors.remove(sector);
    _applyFilters();
  }

  void toggleCountryFilter(String country, bool isActive) {
    isActive ? _selectedCountries.add(country) : _selectedCountries.remove(country);
    _applyFilters();
  }

  void _applyFilters() {
    _filteredAlumnis = _allAlumnis.where((alumni) {
      bool matchesSearch = _searchQuery.isEmpty ||
          alumni.wholeName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          alumni.company.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          alumni.job.toLowerCase().contains(_searchQuery.toLowerCase());

      bool matchesPromotions = _selectedPromotion.isEmpty || _selectedPromotion.contains(alumni.promotion.toString());

      bool matchesSectors = _selectedSectors.isEmpty || _selectedSectors.contains(alumni.sector);

      bool matchesCountries = _selectedCountries.isEmpty;
      if (!matchesCountries) {
        for (var internship in alumni.internships) {
          if (_selectedCountries.contains(internship.country)) {
            matchesCountries = true;
            break;
          }
        }
      }

      return matchesSearch && matchesPromotions && matchesSectors && matchesCountries;
    }).toList();

    notifyListeners();
  }
  
  void removeAlumniLocally(int id) {
    _allAlumnis.removeWhere((e) => e.id == id);
    _applyFilters();
  }

  Future<void> deleteAlumni(Alumnis alumni) async {
    try {
      await _repository.deleteAlumni(alumni.id); 
      
      removeAlumniLocally(alumni.id);
    } catch (e) {
      throw Exception("Erreur lors de la suppression : $e");
    }
  }

  Future<void> loadPendingRequestsCount() async {
    try {
      final requests = await _repository.getPendingRequests();
      _pendingRequestsCount = requests.length;
      notifyListeners();
    } catch (e) {
      print("Error loading pending requests: $e");
    }
  }

  Future<void> loadHistory() async {
    try {
      _historyLogs = await _repository.getHistory();
      notifyListeners();
    } catch (e) {
      print("Error loading history: $e");
    }
  }
}