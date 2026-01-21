import 'dart:convert';
import 'package:http/http.dart' as http;
import 'alumnis.dart'; 

class DatabaseService {

  static const String apiUrl = 'http://localhost/api_alumni/get_alumni.php';

  Future<List<Alumnis>> getTousLesEleves() async {
    try {
      print("Tentative de connexion vers : $apiUrl");
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {

        List<dynamic> body = jsonDecode(response.body);
  
        return body.map((item) => Alumnis.fromMap(item)).toList();
      } else {
        throw Exception("Erreur serveur : ${response.statusCode}");
      }
    } catch (e) {
      print("Erreur critique : $e");

      return []; 
    }
  }
  Future<void> supprimerEleve(String nom, String prenom) async {
    try {
      
      final url = Uri.parse('http://localhost/api_alumni/delete_alumni.php');
      
      await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"nom": nom, "prenom": prenom}),
      );
      print("Demande de suppression envoyée pour $nom $prenom");
    } catch (e) {
      print("Erreur lors de la suppression : $e");
    }
  }



  Future<void> ajouterEleve(Map<String, dynamic> donneesEleve) async {
    try {
      final url = Uri.parse('http://localhost/api_alumni/add_alumni.php');
      
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
    final response = await http.get(Uri.parse('http://localhost/api_alumni/get_history.php'));
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
      final url = Uri.parse('http://localhost/api_alumni/update_alumni.php');
      print("Envoi modification pour ${donnees['nom']}..."); // Debug

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



}