import 'dart:convert';
import 'package:http/http.dart' as http;
import 'alumnis.dart';

class DatabaseService {

  static const String apiUrl = 'https://alumni.theo-airey.fr';

  Future<List<Alumnis>> getTousLesEleves() async {
    try {
      String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      final urlString = '$apiUrl?t=$timestamp';

      print("Tentative de connexion (No-Cache) : $urlString");
      
      final response = await http.get(Uri.parse("$apiUrl/get_alumni.php?t=$timestamp"));

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
      final url = Uri.parse("$apiUrl/delete_alumni.php");
      
    
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
      final url = Uri.parse("$apiUrl/add_alumni.php");
      
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
      final response = await http.get(Uri.parse("$apiUrl/get_history.php"));
      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(jsonDecode(response.body));
      }
    } catch (e) {
      print("Erreur historique: $e");
    }
    return [];

  }

  Future<List<Map<String, dynamic>>> getEntreprise() async {
    try {
      final response = await http.get(Uri.parse("$apiUrl/get_entreprise.php"));
      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(jsonDecode(response.body));
      }
    } catch (e) {
      print("Erreur entreprise: $e");
    }
    return [];

  }


  Future<void> modifierEleve(Map<String, dynamic> donnees) async {
    try {
      final url = Uri.parse("$apiUrl/update_alumni.php");
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

  Future<Map<String, dynamic>> updatePassword(String email, String oldPassword, String newPassword) async {
    try {
      final response = await http.post(
        Uri.parse("$apiUrl/update_password.php"),
        body: {
          "email": email,
          "old_password": oldPassword,
          "new_password": newPassword,
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {"status": "error", "message": "Erreur serveur ${response.statusCode}"};
      }
    } catch (e) {
      return {"status": "error", "message": "Erreur de connexion : $e"};
    }
  }

  Future<void> demanderAjoutEleve(Map<String, dynamic> donneesEleve) async {
    try {
      final url = Uri.parse("$apiUrl/request_alumni.php");
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

  Future<List<Map<String, dynamic>>> getOffres() async {
    try {
      final response = await http.get(Uri.parse("$apiUrl/offer/get_offers.php"));
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
        Uri.parse("$apiUrl/offer/add_offer.php"),
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
      final url = Uri.parse("$apiUrl/offer/delete_offer.php");
      
      String payload = jsonEncode({"id_offre": idOffre});

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: payload,
      );


      if (response.statusCode == 200) {
        var res = jsonDecode(response.body);
        return res['status'] == 'success';
      }
    } catch (e) {
      print("❌ Erreur supprimerOffre: $e");
    }
    return false;
  }

  Future<List<Map<String, dynamic>>> getDemandesEnAttente() async {
    try {
      final response = await http.get(Uri.parse("$apiUrl/get_request.php"));
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
      final url = Uri.parse("$apiUrl/delete_request.php");
      print("Appel Suppression pour ID : $idDemande");

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"id_demande": idDemande}), 
      );

      print("Réponse Suppression : ${response.body}");
    } catch (e) {
      print("Erreur suppression demande: $e");
    }
  }



  Future<List<Map<String, dynamic>>> getEvenements() async {
    try {
      final response = await http.get(
        Uri.parse("$apiUrl/events/get_evenements.php"),
        headers: {"Content-Type": "application/json"},
      );

      print("📥 RÉPONSE ÉVÉNEMENTS : ${response.body}");

      if (response.statusCode == 200) {
        String responseBody = utf8.decode(response.bodyBytes);
        List<dynamic> data = jsonDecode(responseBody);
        return data.map((item) => item as Map<String, dynamic>).toList();
      }
    } catch (e) {
      print("❌ Erreur getEvenements: $e");
    }
    return [];
  }

  Future<bool> proposerEvenement(Map<String, dynamic> data) async {
    try {
      final url = Uri.parse("$apiUrl/events/proposer_evenements.php");
      
      print("📤 ENVOI PROPOSITION : ${jsonEncode(data)}");

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );

      print("📥 RÉPONSE SERVEUR (Proposer) : ${response.body}");

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        // Gestion souple du retour (success ou status)
        return result['success'] == true || result['status'] == 'success';
      }
    } catch (e) {
      print("❌ Erreur proposerEvenement: $e");
    }
    return false;
  }


  Future<List<Map<String, dynamic>>> getDemandesEvenements() async {
    try {
      final response = await http.get(
        Uri.parse("$apiUrl/events/get_request_evenements.php"),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        String responseBody = utf8.decode(response.bodyBytes);
        return List<Map<String, dynamic>>.from(jsonDecode(responseBody));
      }
    } catch (e) {
      print("❌ Erreur getDemandesEvenements: $e");
    }
    return [];
  }

  Future<bool> validerEvenement(int idDemande) async {
    try {
      final response = await http.post(
        Uri.parse("$apiUrl/events/validate_evenements.php"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"id_demande": idDemande}),
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        return result['success'] == true;
      }
    } catch (e) {
      print("❌ Erreur validerEvenement: $e");
    }
    return false;
  }
  


  Future<bool> supprimerEvenement(int idEvent) async {
    try {
      final response = await http.post(
        Uri.parse("$apiUrl/events/delete_evenements.php"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"id_event": idEvent}),
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        return result['status'] == 'success';
      }
    } catch (e) {
      print("❌ Erreur supprimerEvenement: $e");
    }
    return false;
  }

  Future<bool> modifierEvenement(Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse("$apiUrl/events/update_evenements.php"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        return result['status'] == 'success';
      }
    } catch (e) {
      print("❌ Erreur modifierEvenement: $e");
    }
    return false;
  }


  Future<bool> ajouterEvenementDirect(Map<String, dynamic> data) async {
    try {
      final url = Uri.parse("$apiUrl/events/add_evenements.php");
      
      print("📤 ENVOI AJOUT DIRECT : ${jsonEncode(data)}");

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );

      print("📥 RÉPONSE SERVEUR : ${response.body}");

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        return result['success'] == true;
      }
    } catch (e) {
      print("❌ Erreur ajouterEvenementDirect: $e");
    }
    return false;
  }



  Future<List<Map<String, dynamic>>> getActualites() async {
    try {
      final url = Uri.parse("$apiUrl/actualities/get_actualities.php");
      
      final response = await http.get(
        url,
        headers: {"Content-Type": "application/json"},
      );

      print("📥 RÉPONSE ACTUALITÉS : ${response.body}");

      if (response.statusCode == 200) {
        String responseBody = utf8.decode(response.bodyBytes);
        List<dynamic> data = jsonDecode(responseBody);
        return data.map((item) => item as Map<String, dynamic>).toList();
      } else {
        print("❌ Erreur Serveur Actualités : Code ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Erreur getActualites: $e");
    }
    return [];
  }


  Future<bool> supprimerActualite(int idActu) async {
    try {
      final response = await http.post(
        Uri.parse("$apiUrl/actualities/delete_actualities.php"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"id_actu": idActu}),
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        return result['status'] == 'success';
      }
    } catch (e) {
      print("❌ Erreur supprimerActualite: $e");
    }
    return false;
  }

  

  Future<bool> ajouterActualite(Map<String, dynamic> actu) async {
      try {
        print("📤 ENVOI AJOUT : ${jsonEncode(actu)}"); 

        final response = await http.post(
          Uri.parse("$apiUrl/actualities/add_actualities.php"),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(actu),
        );

        print("📥 CODE RETOUR : ${response.statusCode}");
        print("📥 RÉPONSE SERVEUR : ${response.body}"); 

        if (response.statusCode == 200) {
          final res = jsonDecode(response.body);
          return res['status'] == 'success';
        }
      } catch (e) {
        print("❌ Erreur ajouterActualite: $e");
      }
      return false;
    }



  


}

