import 'package:flutter/foundation.dart';
import '/Model/data/services/alumni_repository.dart';
import '/service_locator.dart';

class AdminValidateViewModel extends ChangeNotifier {
  final AlumniRepository _repository = sl<AlumniRepository>();

  bool isLoading = false;
  List<Map<String, dynamic>> pendingRequests = [];


  Future<void> fetchPendingRequests() async {
    isLoading = true;
    notifyListeners();

    try {
      final list = await _repository.getPendingRequests();
      pendingRequests = list.cast<Map<String, dynamic>>();
    } catch (e) {
      pendingRequests = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }



  Future<bool> rejectRequest(int id) async {
    try {
      await _repository.deletePendingRequest({'id_demande': id});
      await fetchPendingRequests();
      return true;
    } catch (e) {
      return false;
    }
  }


  Future<bool> approveRequest(int id, String type) async {
    try {
      if (type == 'EVENEMENT') {
        await _repository.validateEvent(id);
      } else if (type == 'OFFRE' || type == 'EMPLOI') {
      }
      await fetchPendingRequests();
      return true;
    } catch (e) {
      return false;
    }
  }
}