import 'package:flutter/material.dart';
import '/Model/data/services/alumni_repository.dart';
import '/service_locator.dart';

class JobViewModel extends ChangeNotifier {
  final AlumniRepository _repository = sl<AlumniRepository>();

  List<Map<String, dynamic>> _everyOffer = [];
  bool _isLoading = true;


  List<Map<String, dynamic>> get everyOffer => _everyOffer;
  bool get isLoading => _isLoading;


  Future<void> loadOffers() async {
    _isLoading = true;
    notifyListeners();

    try {
      _everyOffer = await _repository.getOffers();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


  Future<bool> deleteOffer(String id) async {
    bool success = await _repository.deleteOffer(id);
    if (success) {
      await loadOffers();
    }
    return success;
  }

  Future<bool> saveOffer(Map<String, dynamic> data, bool isEditing) async {
    bool success;
    if (isEditing) {
      success = await _repository.updateOffer(data);
    } else {
      success = await _repository.addOffer(data);
    }

    if (success) {
      await loadOffers();
    }
    return success;
  }
}