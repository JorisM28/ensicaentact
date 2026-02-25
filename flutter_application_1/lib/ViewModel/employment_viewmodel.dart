import 'package:flutter/material.dart';
import '../../../service_locator.dart';
import '../Model/data/services/alumni_repository.dart';

class CareerViewModel extends ChangeNotifier {
  final Map<String, dynamic> user;

  List<Map<String, dynamic>> allOffers = [];
  List<Map<String, dynamic>> allCompanies = [];

  bool isLoadingOffers = true;
  bool isLoadingCompanies = true;
  String offerSearch = "";

  CareerViewModel({required this.user});

  String get myId => user['id'].toString();
  String get role => user['role'] ?? 'guest';
  bool get isAdmin => role == 'admin';
  bool get canAddOffer => isAdmin || role == 'alumni';

  List<Map<String, dynamic>> get internshipOffers {
    return _filteredOffers.where((o) => (o['type'] ?? '').toLowerCase() == 'stage').toList();
  }

  List<Map<String, dynamic>> get employmentOffers {
    return _filteredOffers.where((o) => (o['type'] ?? '').toLowerCase() != 'stage').toList();
  }

  List<Map<String, dynamic>> get _filteredOffers {
    if (offerSearch.isEmpty) return allOffers;
    return allOffers.where((o) {
      final title = (o['titre'] ?? '').toLowerCase();
      final company = (o['entreprise'] ?? '').toLowerCase();
      return title.contains(offerSearch.toLowerCase()) || company.contains(offerSearch.toLowerCase());
    }).toList();
  }

  Future<void> loadOffers() async {
    isLoadingOffers = true;
    notifyListeners();
    
    try {
      final data = await sl<AlumniRepository>().getOffers();
      allOffers = List<Map<String, dynamic>>.from(data);
    } catch (e) {
      debugPrint("Error loading offers: $e");
      allOffers = [];
    } finally {
      isLoadingOffers = false;
      notifyListeners();
    }
  }

  Future<void> loadCompanies() async {
    isLoadingCompanies = true;
    notifyListeners();
    
    try {
      final data = await sl<AlumniRepository>().getCompanies({});
      allCompanies = List<Map<String, dynamic>>.from(data);
    } catch (e) {
      debugPrint("Error loading companies: $e");
      allCompanies = [];
    } finally {
      isLoadingCompanies = false;
      notifyListeners();
    }
  }

  void updateOfferSearch(String val) {
    offerSearch = val;
    notifyListeners();
  }

  Future<bool> deleteOffer(String idOffre) async {
    try {
      await sl<AlumniRepository>().deleteOffer(idOffre);
      await loadOffers();
      return true;
    } catch (e) {
      debugPrint("Error deleting offer: $e");
      return false;
    }
  }

  Future<bool> addOffer(Map<String, dynamic> data) async {
    data['id_auteur'] = myId;
    try {
      await sl<AlumniRepository>().addOffer(data);
      await loadOffers();
      return true;
    } catch (e) {
      debugPrint("Error adding offer: $e");
      return false;
    }
  }

  bool canUserDeleteOffer(Map<String, dynamic> offer) {
    String idAutor = (offer['id_auteur'] ?? '').toString();
    return idAutor == myId || isAdmin;
  }
}