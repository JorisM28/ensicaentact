import '../../alumnis.dart';
import 'api_service.dart';
import 'api_constants.dart';

class AlumniRepository {
  final ApiService _api = ApiService();

  Future<List<Alumnis>> getAllAlumnis() async {
    final List<dynamic> jsonList = await _api.get(ApiConstants.getAlumni);
    return jsonList.map((e) => Alumnis.fromMap(e)).toList();
  }

  Future<void> addAlumni(Map<String, dynamic> data, {bool isAdmin = false}) async {
    final url = isAdmin ? ApiConstants.addAlumni : ApiConstants.requestAlumni;
    await _api.post(url, data); 
  }

  Future<void> deleteAlumni(int id) async {
    await _api.post(ApiConstants.deleteAlumni, {'id': id});
  }

  Future<void> updateAlumni(Map<String, dynamic> data) async {
    await _api.post(ApiConstants.updateAlumni, data);
  }

  Future<List<dynamic>> getHistory() async { return await _api.get(ApiConstants.getHistory); }
  Future<List<dynamic>> getCompanies(Map<String, dynamic> data) async => await _api.post(ApiConstants.getCompany, data);
  Future<void> updatePassword(Map<String, dynamic> data) async => await _api.post(ApiConstants.updatePassword, data);
  
  Future<List<dynamic>> getOffers(Map<String, dynamic> data) async => await _api.post(ApiConstants.getOffer, data);
  Future<void> addOffer(Map<String, dynamic> data) async => await _api.post(ApiConstants.addOffer, data);
  Future<void> deleteOffer(Map<String, dynamic> data) async => await _api.post(ApiConstants.deleteOffer, data);

  Future<List<dynamic>> getPendingRequests() async {
    return await _api.get(ApiConstants.getPendingRequest); 
  }

  Future<void> deletePendingRequest(Map<String, dynamic> data) async {
    await _api.post(ApiConstants.deletePendingRequest, data);
  }
}