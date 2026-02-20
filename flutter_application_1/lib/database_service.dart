import 'dart:convert';
import 'package:http/http.dart' as http;
import 'alumnis.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  static const String apiUrl = 'https://alumni.theo-airey.fr';


  Future<dynamic> _get(String endpoint) async {
    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      final uri = Uri.parse('$apiUrl/$endpoint${endpoint.contains('?') ? '&' : '?'}t=$timestamp');

      print("GET: $uri");
      final response = await http.get(uri, headers: {"Content-Type": "application/json"});
      return _processResponse(response);
    } catch (e) {
      print("Erreur connexion GET ($endpoint): $e");
      return null;
    }
  }

  Future<dynamic> _post(String endpoint, Map<String, dynamic> data) async {
    try {
      final uri = Uri.parse('$apiUrl/$endpoint');
      print("POST: $uri | Données: ${jsonEncode(data)}");

      final response = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );
      return _processResponse(response);
    } catch (e) {
      print("Erreur connexion POST ($endpoint): $e");
      return null;
    }
  }

  dynamic _processResponse(http.Response response) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      try {
        String body = utf8.decode(response.bodyBytes);
        return jsonDecode(body);
      } catch (e) {
        if (response.body.contains("success")) return {"status": "success"};
        print("Erreur décodage JSON: $e | Body: ${response.body}");
        return null;
      }
    } else {
      print("Erreur Serveur: Status ${response.statusCode} | Body: ${response.body}");
      return null;
    }
  }

  bool _isSuccess(dynamic res) {
    if (res == null) return false;
    if (res is Map) {
      return res['status'] == 'success' || res['success'] == true;
    }
    return false;
  }

  Future<List<Map<String, dynamic>>> getActualites() async {
    final res = await _get("actualities/get_actualities.php");
    if (res is List) return List<Map<String, dynamic>>.from(res);
    if (res is Map && res.containsKey('data')) return List<Map<String, dynamic>>.from(res['data']);
    return [];
  }

  Future<bool> ajouterActualite(Map<String, dynamic> actu) async {
    // Ton PHP attend "description" mais l'insère dans "contenu"
    final res = await _post("actualities/add_actualities.php", actu);
    return _isSuccess(res);
  }

  Future<bool> supprimerActualite(dynamic idActu) async {
    final res = await _post("actualities/delete_actualities.php", {"id_actu": idActu.toString()});
    return _isSuccess(res);
  }

  Future<List<Map<String, dynamic>>> getEvenements() async {
    final res = await _get("events/get_evenements.php");
    if (res is List) return List<Map<String, dynamic>>.from(res);
    return [];
  }

  Future<bool> proposerEvenement(Map<String, dynamic> data) async {
    final res = await _post("events/proposer_evenements.php", data);
    return _isSuccess(res);
  }

  Future<bool> ajouterEvenementDirect(Map<String, dynamic> data) async {
    final res = await _post("events/add_evenements.php", data);
    return _isSuccess(res);
  }

  Future<bool> modifierEvenement(Map<String, dynamic> data) async {
    final res = await _post("events/update_evenements.php", data);
    return _isSuccess(res);
  }

  Future<bool> supprimerEvenement(dynamic idEvent) async {
    final res = await _post("events/delete_evenements.php", {"id_event": idEvent.toString()});
    return _isSuccess(res);
  }

  Future<List<Map<String, dynamic>>> getDemandesEvenements() async {
    final res = await _get("events/get_request_evenements.php");
    if (res is List) return List<Map<String, dynamic>>.from(res);
    return [];
  }

  Future<bool> validerEvenement(dynamic idDemande) async {
    final res = await _post("events/validate_evenements.php", {"id_demande": idDemande.toString()});
    return _isSuccess(res);
  }


  Future<List<Alumnis>> getTousLesEleves() async {
    final res = await _get("get_alumni.php");
    if (res is List) {
      return res.map((item) => Alumnis.fromMap(item)).toList();
    }
    return [];
  }

  Future<bool> ajouterEleve(Map<String, dynamic> donneesEleve) async {
    final res = await _post("add_alumni.php", donneesEleve);
    return _isSuccess(res);
  }

  Future<bool> modifierEleve(Map<String, dynamic> donnees) async {
    final res = await _post("update_alumni.php", donnees);
    return _isSuccess(res);
  }

  Future<bool> supprimerEleve(String nom, String prenom) async {
    final res = await _post("delete_alumni.php", {"nom": nom, "prenom": prenom});
    return _isSuccess(res);
  }

  Future<bool> demanderAjoutEleve(Map<String, dynamic> donneesEleve) async {
    final res = await _post("request_alumni.php", donneesEleve);
    return _isSuccess(res);
  }

  Future<Map<String, dynamic>> updatePassword(String email, String oldPassword, String newPassword) async {
    final res = await _post("update_password.php", {
      "email": email,
      "old_password": oldPassword,
      "new_password": newPassword,
    });
    if (res is Map<String, dynamic>) return res;
    return {"status": "error", "message": "Erreur inattendue"};
  }


  Future<List<Map<String, dynamic>>> getOffres() async {
    final res = await _get("offer/get_offers.php");
    if (res is List) return List<Map<String, dynamic>>.from(res);
    return [];
  }

  Future<bool> ajouterOffre(Map<String, dynamic> offre) async {
    final res = await _post("offer/add_offer.php", offre);
    return _isSuccess(res);
  }

  Future<bool> modifierOffre(Map<String, dynamic> data) async {
    final res = await _post("offer/update_offer.php", data);
    return _isSuccess(res);
  }

  Future<bool> supprimerOffre(dynamic idOffre) async {
    final res = await _post("offer/delete_offer.php", {"id_offre": idOffre.toString()});
    return _isSuccess(res);
  }

  Future<List<Map<String, dynamic>>> getHistorique() async {
    final res = await _get("get_history.php");
    if (res is List) return List<Map<String, dynamic>>.from(res);
    return [];
  }

  Future<List<Map<String, dynamic>>> getEntreprise() async {
    final res = await _get("get_entreprise.php");
    if (res is List) return List<Map<String, dynamic>>.from(res);
    return [];
  }

  Future<List<Map<String, dynamic>>> getDemandesEnAttente() async {
    final res = await _get("get_request.php");
    if (res is List) return List<Map<String, dynamic>>.from(res);
    return [];
  }

  Future<bool> supprimerDemande(dynamic idDemande) async {
    final res = await _post("delete_request.php", {"id_demande": idDemande.toString()});
    return _isSuccess(res);
  }
}