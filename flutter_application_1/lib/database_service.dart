import 'dart:convert';
import 'package:http/http.dart' as http;
import 'alumnis.dart'; 

class DatabaseService {

  static const String apiUrl = 'https://alumni.theo-airey.fr/get_alumni.php';

  Future<List<Alumnis>> getTousLesEleves() async {
    try {
      String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      final urlString = '$apiUrl?t=$timestamp';
      
      print("Tentative de connexion (No-Cache) : $urlString");
      
      final response = await http.get(Uri.parse(urlString));

      if (response.statusCode == 200) {
        String responseBody = utf8.decode(response.bodyBytes);
        List<dynamic> body = jsonDecode(responseBody);
        return body.map((item) => Alumnis.fromMap(item)).toList();
      } else {
        throw Exception("Erreur serveur : ${response.statusCode}");
      }
    } catch (e) {
      print("Erreur critique : $e");
      return []; 
    }
  }
Future<bool> supprimerEleve(String nom, String prenom) async {
    try {
      final url = Uri.parse('https://alumni.theo-airey.fr/delete_alumni.php');
      
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"nom": nom, "prenom": prenom}),
      );

      print("Code retour HTTP : ${response.statusCode}");
      print("Réponse du serveur (Suppression) : ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> result = jsonDecode(response.body);
        return result['status'] == 'success';
      }
      return false;

    } catch (e) {
      print("Erreur critique lors de la suppression : $e");
      return false;
    }
  }

  Future<void> ajouterEleve(Map<String, dynamic> donneesEleve) async {
    try {
      final url = Uri.parse('https://alumni.theo-airey.fr/add_alumni.php');
      
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(donneesEleve),
      );

      print("Réponse ajout : ${response.body}");
    } catch (e) {
      print("Erreur lors de l'ajout : $e");
    }
  }

  Future<List<Map<String, dynamic>>> getHistorique() async {
  try {
    final response = await http.get(Uri.parse('https://alumni.theo-airey.fr/get_history.php'));
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(response.body));
    }
  } catch (e) {
    print("Erreur historique: $e");
  }
  return [];
}


Future<void> modifierEleve(Map<String, dynamic> donnees) async {
    try {
      final url = Uri.parse('https://alumni.theo-airey.fr/update_alumni.php');
      print("Envoi modification pour ${donnees['nom']}...");

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(donnees),
      );
      
 
      print("Code retour: ${response.statusCode}");
      print("Réponse serveur: ${response.body}"); 

    } catch (e) {
      print("Erreur modification critique : $e");
    }
  }

  Future<void> demanderAjoutEleve(Map<String, dynamic> donneesEleve) async {
    try {
      final url = Uri.parse('https://alumni.theo-airey.fr/request_alumni.php');
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(donneesEleve),
      );
      print("Réponse Demande : ${response.body}");
      if (response.statusCode != 200) throw Exception("Erreur serveur");
    } catch (e) {
      print("Erreur Demande : $e");
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getDemandesEnAttente() async {
    try {
      final response = await http.get(Uri.parse('https://alumni.theo-airey.fr/get_requests.php'));
      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(jsonDecode(response.body));
      }
    } catch (e) {
      print("Erreur getDemandes: $e");
    }
    return [];
  }

  Future<void> supprimerDemande(int idDemande) async {
    try {
      await http.post(
        Uri.parse('https://alumni.theo-airey.fr/delete_request.php'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"id_demande": idDemande}),
      );
    } catch (e) {
      print("Erreur suppression demande: $e");
    }
  }
}
