import 'package:flutter/material.dart';
import '../../../Model/data/services/database_service.dart';

class CareerViewModel extends ChangeNotifier {
  final Map<String, dynamic> user;
  final DatabaseService _dbService = DatabaseService();

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
    allOffers = await _dbService.getOffers();
    isLoadingOffers = false;
    notifyListeners();
  }

  Future<void> loadCompanies() async {
    isLoadingCompanies = true;
    notifyListeners();
    allCompanies = await _dbService.getCompanies();
    isLoadingCompanies = false;
    notifyListeners();
  }

  void updateOfferSearch(String val) {
    offerSearch = val;
    notifyListeners();
  }

  Future<bool> deleteOffer(String idOffre) async {
    bool success = await _dbService.deleteOffers(idOffre);
    if (success) await loadOffers();
    return success;
  }

  Future<bool> addOffer(Map<String, dynamic> data) async {
    data['id_auteur'] = myId;
    bool success = await _dbService.addOffers(data);
    if (success) await loadOffers();
    return success;
  }

  bool canUserDeleteOffer(Map<String, dynamic> offer) {
    String idAutor = (offer['id_auteur'] ?? '').toString();
    return idAutor == myId || isAdmin;
  }
}