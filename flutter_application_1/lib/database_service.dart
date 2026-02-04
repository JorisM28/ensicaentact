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



  
  Future<List<Map<String, dynamic>>> getOffres() async {
    try {
      final response = await http.get(Uri.parse('https://alumni.theo-airey.fr/offer/get_offers.php'));
      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(jsonDecode(response.body));
      }
    } catch (e) {
      print("Erreur getOffres: $e");
    }
    return [];
  }


  Future<bool> ajouterOffre(Map<String, dynamic> offre) async {
    try {
      final response = await http.post(
        Uri.parse('https://alumni.theo-airey.fr/offer/add_offer.php'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(offre),
      );

      print("Réponse serveur : ${response.body}");
      
      if (response.statusCode == 200) {
        var res = jsonDecode(response.body);
        return res['status'] == 'success';
      }
    } catch (e) {
      print("Erreur ajouterOffre: $e");
    }
    return false;
  }

  Future<bool> supprimerOffre(String idOffre) async {
    try {
      final url = Uri.parse('https://alumni.theo-airey.fr/offer/delete_offer.php');
      
      // 1. On affiche ce qu'on va envoyer
      String payload = jsonEncode({"id_offre": idOffre});
      print("📤 ENVOI VERS PHP : $payload");

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: payload,
      );

      // 2. On affiche ce que le serveur répond VRAIMENT
      print("📥 RÉPONSE DU PHP : ${response.body}");

      if (response.statusCode == 200) {
        var res = jsonDecode(response.body);
        return res['status'] == 'success';
      }
    } catch (e) {
      print("❌ Erreur supprimerOffre: $e");
    }
    return false;
  }


  Future<List<Map<String, dynamic>>> getActualites() async {
    try {
      final url = Uri.parse('https://alumni.theo-airey.fr/actualities/get_actualities.php');
      
      final response = await http.get(
        url,
        headers: {"Content-Type": "application/json"},
      );

      print("📥 RÉPONSE ACTUALITÉS : ${response.body}");

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((item) => item as Map<String, dynamic>).toList();
      }
    } catch (e) {
      print("❌ Erreur getActualites: $e");
    }
    return [];
  }

  Future<List<Map<String, dynamic>>> getEvenements() async {
    try {
      final url = Uri.parse('https://alumni.theo-airey.fr/events/get_evenements.php');
      
      final response = await http.get(
        url,
        headers: {"Content-Type": "application/json"},
      );

      print("📥 RÉPONSE ÉVÉNEMENTS : ${response.body}");

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((item) => item as Map<String, dynamic>).toList();
      }
    } catch (e) {
      print("❌ Erreur getEvenements: $e");
    }
    return [];
  }



  Future<bool> proposerEvenement(Map<String, dynamic> data) async {
    try {
      final url = Uri.parse("https://alumni.theo-airey.fr/events/add_evenement.php");
      
      
      final String bodyData = json.encode(data);

      print("📤 ENVOI PROPOSITION : $bodyData");

      final response = await http.post(
        url, 
        body: bodyData,
        headers: {"Content-Type": "application/json"},
      );

      print("📥 RÉPONSE SERVEUR (Proposer) : ${response.body}");

      if (response.statusCode == 200) {
        final result = json.decode(response.body);

        return result['success'] == true;
      } else {
        print("❌ Erreur Serveur : Code ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("❌ Erreur lors de la proposition : $e");
      return false;
    }
  }
}
