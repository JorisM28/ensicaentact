import 'package:flutter/cupertino.dart';
import '/Model/alumnis.dart';
import 'api_service.dart';
import 'api_constants.dart';

class AlumniRepository {
  final ApiService _api = ApiService();

  Future<List<Alumnis>> getAllAlumnis() async {
    final List<dynamic> jsonList = await _api.get(ApiConstants.getAlumni);
    return jsonList.map((e) => Alumnis.fromMap(e)).toList();
  }

  Future<List<Map<String, dynamic>>> getEvents() async {
    final List<dynamic> jsonList = await _api.get(ApiConstants.getEvents);
    return List<Map<String, dynamic>>.from(jsonList);
  }
  Future<bool> deleteEvent(int id) async {
    try {
      Map<String, dynamic> data = {'id_event': id};

      final response = await _api.post(ApiConstants.deleteEvent, data);

      if (response != null) {
        return true;
      }
      return false;
    } catch (e) {
      debugPrint("Erreur lors de la suppression: $e");
      return false;
    }
  }

  Future<bool> editEvent(Map<String, dynamic> data) async {
    try {
      final response = await _api.post(ApiConstants.editEvent, data);
      if (response != null) {
        return true;
      }
      return false;
    } catch (e) {
      debugPrint("Erreur lors de la modification de l'évènement: $e");
      return false;
    }
  }

  Future<bool> addEvent(Map<String, dynamic> eventData) async {
    try {
      final response = await _api.post(ApiConstants.addEvent, eventData);

      if (response != null) {
        return true;
      }
      return false;
    } catch (e) {
      debugPrint("Erreur lors de l'ajout de l'évènement: $e");
      return false;
    }
  }

  Future<void> addAlumni(Map<String, dynamic> data, {bool isAdmin = false}) async {
    final url = isAdmin ? ApiConstants.addAlumni : ApiConstants.requestAlumni;
    await _api.post(url, data); 
  }

  Future<void> deleteAlumni(int id) async {
    await _api.post(ApiConstants.deleteAlumni, {'id': id});
  }

  Future<void> updateAlumni(Map<String, dynamic> data) async {
  debugPrint(data.toString());

  final response = await _api.post(ApiConstants.updateAlumni, data);

  debugPrint(response.toString());

  if (response == null) {
    throw Exception("Impossible de joindre le serveur ou erreur interne.");
  }

  if (response is Map<String, dynamic>) {
    if (response['status'] == 'error') {
      throw Exception(response['message'] ?? "Erreur refusée par le serveur.");
    }
  }
}

  Future<List<dynamic>> getHistory() async { 
    return await _api.get(ApiConstants.getHistory); 
  }

  Future<List<dynamic>> getCompanies(Map<String, dynamic> data) async => await _api.post(ApiConstants.getCompany, data);

  Future<void> updatePassword(Map<String, dynamic> data) async => await _api.post(ApiConstants.updatePassword, data);

  Future<List<Map<String, dynamic>>> getOffers() async {
    try {
      final response = await _api.post(ApiConstants.getOffer, {});
      if (response != null) {
        return List<Map<String, dynamic>>.from(response);
      }
      return [];
    } catch (e) {
      debugPrint("Erreur lors de la récupération des offres : $e");
      return [];
    }
  }


  Future<bool> updateOffer(Map<String, dynamic> offerData) async {
    try {
      final response = await _api.post(ApiConstants.updateOffer, offerData);
      if (response != null) {
        return true;
      }
      return false;
    } catch (e) {
      debugPrint("Error updating the offer: $e");
      return false;
    }
  }
  Future<bool> addOffer(Map<String, dynamic> offerData) async {
    try {
      final response = await _api.post(ApiConstants.addOffer, offerData);

      if (response != null) {
        return true;
      }
      return false;
    } catch (e) {
      debugPrint("Error adding the offer: $e");
      return false;
    }
  }
  Future<bool> deleteOffer(String idOffre) async {
    try {
      Map<String, dynamic> data = {'id_offre': idOffre};

      final response = await _api.post(ApiConstants.deleteOffer, data);

      if (response != null) {
        return true;
      }
      return false;
    } catch (e) {
      debugPrint("Erreur lors de la suppression de l'offre : $e");
      return false;
    }
  }

  Future<List<dynamic>> getPendingRequests() async {
    return await _api.get(ApiConstants.getPendingRequest); 
  }

  Future<void> deletePendingRequest(Map<String, dynamic> data) async {
    await _api.post(ApiConstants.deletePendingRequest, data);
  }

  Future<List<Map<String, dynamic>>> getNews() async {
    try {
      final response = await _api.post(ApiConstants.getNews, {});
      if (response != null) {
        return List<Map<String, dynamic>>.from(response);
      }
      return [];
    } catch (e) {
      debugPrint("Error fetching news: $e");
      return [];
    }
  }

  Future<bool> addNews(Map<String, dynamic> newsData) async {
    try {
      final response = await _api.post(ApiConstants.addNews, newsData);
      if (response != null) {
        return true;
      }
      return false;
    } catch (e) {
      debugPrint("Error adding news: $e");
      return false;
    }
  }

  Future<bool> deleteNews(int newsId) async {
    try {
      Map<String, dynamic> data = {'id_actu': newsId};

      final response = await _api.post(ApiConstants.deleteNews, data);

      if (response != null) {
        return true;

      }
      return false;
    } catch (e) {
      debugPrint("Error deleting news: $e");
      return false;
    }
  }
  Future<bool> requestEvent(Map<String, dynamic> requestData) async {
    try {
      final response = await _api.post(ApiConstants.requestEvent, requestData);
      if (response != null) {
        return true;
      }
      return false;
    } catch (e) {
      debugPrint("Error requesting event: $e");
      return false;
    }
  }
  
  Future<bool> validateEvent(int idDemande) async {
    try {
      final response = await _api.post(ApiConstants.validateEvent, {'id_demande': idDemande});
      return response != null;
    } catch (e) {
      debugPrint("Erreur lors de la validation de l'évènement: $e");
      return false;
    }
  }


}