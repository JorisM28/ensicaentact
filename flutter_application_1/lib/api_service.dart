import 'dart:convert';
import 'package:http/http.dart' as http;
import 'alumni_model.dart'; // On va le créer juste après

class ApiService {
  // Puisque tu es sur Linux et que tu testes en version Desktop ou Web
  static const String url = "http://localhost/api_alumni/get_alumni.php";

  Future<List<Alumni>> fetchAlumni() async {
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        return body.map((dynamic item) => Alumni.fromJson(item)).toList();
      } else {
        throw Exception("Erreur serveur : ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Erreur de connexion : $e");
    }
  }
}