import 'dart:convert';
import 'package:http/http.dart' as http;
import 'alumnis.dart'; // On garde son modèle

class DatabaseService {
  // 1. C'est ICI qu'on met TON adresse de serveur Linux
  // Note : Sur Linux Desktop ou Chrome, localhost fonctionne.
  static const String apiUrl = 'http://localhost/api_alumni/get_alumni.php';

  Future<List<Alumnis>> getTousLesEleves() async {
    try {
      print("Tentative de connexion vers : $apiUrl");
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        // 2. Décodage des données
        List<dynamic> body = jsonDecode(response.body);
        
        // 3. On transforme le JSON en objets "Alumnis"
        return body.map((item) => Alumnis.fromMap(item)).toList();
      } else {
        throw Exception("Erreur serveur : ${response.statusCode}");
      }
    } catch (e) {
      print("Erreur critique : $e");
      // On renvoie une liste vide pour ne pas faire planter l'appli, 
      // mais regarde ta console pour voir l'erreur !
      return []; 
    }
  }
}