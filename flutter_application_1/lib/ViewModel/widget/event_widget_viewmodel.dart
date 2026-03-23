import 'package:flutter/foundation.dart';
import '/Model/data/services/alumni_repository.dart';
import '/service_locator.dart';

class EventWidgetViewModel extends ChangeNotifier {
  final AlumniRepository _repository = sl<AlumniRepository>();

  List<Map<String, dynamic>> _events = [];
  bool _isLoading = false;

  List<Map<String, dynamic>> get events => _events;
  bool get isLoading => _isLoading;

  Future<void> loadEvents() async {
    _isLoading = true;
    notifyListeners();
    try {
      _events = await _repository.getEvents();
    } catch (e) {
      _events = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> deleteEvent(int id) async {
    try {
      bool success = await _repository.deleteEvent(id);
      if (success) {
        _events.removeWhere((element) => element['id_event'] == id);
        notifyListeners();
      }
      return success;
    } catch (e) {
      return false;
    }
  }

  Future<bool> proposeEvent(Map<String, dynamic> proposition) async {
    _isLoading = true;
    notifyListeners();
    try {
      return await _repository.requestEvent(proposition);
    } catch (e) {
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}