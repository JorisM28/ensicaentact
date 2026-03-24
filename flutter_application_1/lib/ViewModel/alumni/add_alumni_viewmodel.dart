import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '/Model/data/services/alumni_repository.dart';
import '/service_locator.dart';

class AddAlumniViewModel extends ChangeNotifier {
  final AlumniRepository _repository = sl<AlumniRepository>();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> submitForm({
    required Map<String, dynamic> alumniData,
    required List<Map<String, dynamic>> internshipsData,
    required bool isAdmin,
    int? requestId,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      var coordsPoste = await _getCoordonnees(
          alumniData['ville'] ?? '',
          alumniData['pays'] ?? '',
          alumniData['code_postal'] ?? ''
      );

      if (coordsPoste != null) {
        alumniData['latitude'] = coordsPoste['lat'];
        alumniData['longitude'] = coordsPoste['lon'];
      }

      List<Map<String, dynamic>> finalInternships = [];
      for (var internshipMap in internshipsData) {
        var coordsInternship = await _getCoordonnees(
            internshipMap['ville'] ?? '',
            internshipMap['pays'] ?? '',
            internshipMap['code_postal'] ?? ''
        );

        if (coordsInternship != null) {
          internshipMap['latitude'] = coordsInternship['lat'];
          internshipMap['longitude'] = coordsInternship['lon'];
        }
        finalInternships.add(internshipMap);
      }

      if (finalInternships.isNotEmpty) {
        alumniData["stages"] = finalInternships;
      }

      if (isAdmin) {
        await _repository.addAlumni(alumniData, isAdmin: true);
        if (requestId != null) {
          await _repository.deletePendingRequest({'id_demande': requestId});
        }
      } else {
        await _repository.addAlumni(alumniData, isAdmin: false);
      }
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

  Future<Map<String, double>?> _getCoordonnees(String city, String country, String postalCode) async {
    if (city.isEmpty) return null;

    String query = postalCode.isNotEmpty ? "$postalCode $city, $country" : "$city, $country";
    var url = Uri.parse("https://nominatim.openstreetmap.org/search?q=${Uri.encodeComponent(query)}&format=json&limit=1");

    try {
      var response = await http.get(url, headers: {
        'User-Agent': 'AlumniEnsiApp/1.0'
      });

      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        if (data is List && data.isNotEmpty) {
          return {
            "lat": double.parse(data[0]['lat'].toString()),
            "lon": double.parse(data[0]['lon'].toString()),
          };
        } else if (postalCode.isNotEmpty) {
          return await _getCoordonnees(city, country, "");
        }
      }
    } catch (e) {
      return null;
    }
    return null;
  }
}