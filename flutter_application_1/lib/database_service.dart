import 'dart:convert';
import 'package:http/http.dart' as http;
import 'alumnis.dart';

class DatabaseService {
  // On pointe vers votre serveur PHP local temporaire
  final String apiUrl = 'http://localhost:8080/api.php';

  Future<List<Alumnis>> getTousLesEleves() async {
    try {
      print("Appel vers : $apiUrl");
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        return body.map((item) => Alumnis.fromMap(item)).toList();
      } else {
        throw Exception("Erreur serveur : ${response.statusCode}");
      }
    } catch (e) {
      print("Erreur : $e");
      return [];
    }
  }
}