import 'package:flutter/foundation.dart';
import '../../Model/data/services/alumni_repository.dart';
import '../../service_locator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddAlumniViewModel extends ChangeNotifier {
  final AlumniRepository _repository = sl<AlumniRepository>();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<Map<String, double>?> obtenirCoordonnees(String ville, String pays) async {
    if (ville.isEmpty) return null;

    String query = "$ville, $pays";
    var url = Uri.parse("https://nominatim.openstreetmap.org/search?q=$query&format=json&limit=1");

    try {
      var response = await http.get(url, headers: {
        'User-Agent': 'AlumniEnsiApp/1.0 (votre_email@exemple.com)' 
      });

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data is List && data.isNotEmpty) {
          return {
            "lat": double.parse(data[0]['lat']),
            "lon": double.parse(data[0]['lon']),
          };
        }
      }
    } catch (e) {
      debugPrint("Erreur géocodage: $e");
    }
    return null;
  }


  Future<bool> submitForm(Map<String, dynamic> data, bool isAdmin, int? requestId) async {
    _isLoading = true;
    notifyListeners();
    try {
        if (isAdmin) {
            await _repository.addAlumni(data, isAdmin: true);
            if (requestId != null) {
                 await _repository.deletePendingRequest({'id_demande': requestId});
            }
        } else {
             await _repository.addAlumni(data, isAdmin: false);
        }
        return true;
    } catch(e) {
        return false;
    } finally {
        _isLoading = false;
        notifyListeners();
    }
  }

  Future<void> rejectRequest(int requestId) async {
      _isLoading = true;
      notifyListeners();
      try {
        await _repository.deletePendingRequest({'id_demande': requestId});
      } finally {
        _isLoading = false;
        notifyListeners();
      }
  }
}
