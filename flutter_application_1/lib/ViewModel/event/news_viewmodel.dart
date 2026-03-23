import 'package:flutter/foundation.dart';
import '../../Model/data/services/alumni_repository.dart';
import '../../Model/data/services/auth_service.dart';
import '../../Model/user_model.dart';
import '../../service_locator.dart';

class NewsViewModel extends ChangeNotifier {
  final AlumniRepository _repository = sl<AlumniRepository>();
  final AuthService _authService = sl<AuthService>();

  List<Map<String, dynamic>> _news = [];
  List<Map<String, dynamic>> get news => _news;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  String _searchQuery = "";
  String get searchQuery => _searchQuery;
  User? get currentUser => _authService.currentUser;


  bool get isAdmin => _authService.isAdmin;

  List<Map<String, dynamic>> get filteredNews {
    if (_searchQuery.isEmpty) return _news;
    return _news.where((e) => 
      (e['titre'] ?? '').toLowerCase().contains(_searchQuery.toLowerCase()) ||
      (e['description'] ?? '').toLowerCase().contains(_searchQuery.toLowerCase())
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
      _news = await _repository.getNews();
    } catch (e) {
      _news = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> deleteNews(int id) async {
    bool success = await _repository.deleteNews(id);
    if (success) {
      await loadData();
    }
    return success;
  }

  Future<bool> addNews(Map<String, dynamic> data) async {
    bool success = await _repository.addNews(data);
    if (success) {
      await loadData();
    }
    return success;
  }
}
