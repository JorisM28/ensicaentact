import 'package:flutter/foundation.dart';
import '../../Model/data/services/alumni_repository.dart';
import '../../service_locator.dart';

class AdminValidateViewModel extends ChangeNotifier {
  final AlumniRepository _repository = sl<AlumniRepository>();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<Map<String, dynamic>> _pendingRequests = [];
  List<Map<String, dynamic>> get pendingRequests => _pendingRequests;

  Future<void> fetchPendingRequests() async {
    _isLoading = true;
    notifyListeners();

    try {
      final list = await _repository.getPendingRequests();
      _pendingRequests = list.cast<Map<String, dynamic>>();
    } catch (e) {
      _pendingRequests = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deletePendingRequest(int id) async {
    try {
      await _repository.deletePendingRequest({'id_demande': id});
      await fetchPendingRequests();
    } catch (e) {
      // Handle error
    }
  }
}
