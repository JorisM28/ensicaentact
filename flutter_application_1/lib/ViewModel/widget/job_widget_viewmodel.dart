import 'package:flutter/foundation.dart';
import '/Model/data/services/alumni_repository.dart';
import '/service_locator.dart';

class JobOfferWidgetViewModel extends ChangeNotifier {
  final AlumniRepository _repository = sl<AlumniRepository>();

  List<Map<String, dynamic>> _offers = [];
  bool _isLoading = true;

  List<Map<String, dynamic>> get offers => _offers;
  bool get isLoading => _isLoading;

  Future<void> loadOffers() async {
    _isLoading = true;
    notifyListeners();
    try {
      _offers = await _repository.getOffers();
    } catch (e) {
      _offers = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}