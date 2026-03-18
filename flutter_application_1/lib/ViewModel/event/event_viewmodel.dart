import 'package:flutter/foundation.dart';
import '../../Model/data/services/alumni_repository.dart';
import '../../Model/data/services/auth_service.dart';
import '../../Model/user_model.dart';
import '../../service_locator.dart';

class EventViewModel extends ChangeNotifier {
  final AlumniRepository _repository = sl<AlumniRepository>();
  final AuthService _authService = sl<AuthService>();

  List<Map<String, dynamic>> _events = [];
  List<Map<String, dynamic>> get events => _events;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  String _searchQuery = "";

  User? get currentUser => _authService.currentUser;

  bool get isAdmin => _authService.isAdmin;

  List<Map<String, dynamic>> get filteredEvents {
    if (_searchQuery.isEmpty) return _events;
    return _events.where((e) =>
      (e['titre'] ?? '').toLowerCase().contains(_searchQuery.toLowerCase()) ||
      (e['lieu'] ?? '').toLowerCase().contains(_searchQuery.toLowerCase())
    ).toList();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Future<void> loadData() async {
    _isLoading = true;
    notifyListeners();
    try {
      _events = await _repository.getEvents();
    } catch (e) {
      // Handle error gracefully
      _events = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> deleteEvent(int id) async {
    bool success = await _repository.deleteEvent(id);
    if (success) {
      await loadData();
    }
    return success;
  }

  Future<bool> saveEvent(Map<String, dynamic> data, bool isEdit) async {
    bool success;
    if (isEdit) {
      success = await _repository.editEvent(data);
    } else {
      success = await _repository.addEvent(data);
    }
    if (success) {
      await loadData();
    }
    return success;
  }
}
