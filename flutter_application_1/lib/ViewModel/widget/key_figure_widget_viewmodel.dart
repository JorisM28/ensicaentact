import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class KeyFigure {
  int id;
  String label;
  int value;
  String suffix;
  String iconKey;
  Color color;
  String colorHex;

  KeyFigure({
    required this.id,
    required this.label,
    required this.value,
    this.suffix = "",
    required this.iconKey,
    required this.color,
    required this.colorHex,
  });

  factory KeyFigure.fromJson(Map<String, dynamic> json) {
    String rawColor = json['color_hex'] ?? '#000000';
    String hexColor = rawColor.replaceAll('#', '');
    Color colorParsed;
    try {
      colorParsed = Color(int.parse('0xFF$hexColor'));
    } catch (e) {
      colorParsed = Colors.black;
    }

    return KeyFigure(
      id: int.parse(json['id'].toString()),
      label: json['label'],
      value: int.parse(json['stat_value'].toString()),
      suffix: json['suffix'] ?? "",
      iconKey: json['icon_key'],
      colorHex: rawColor,
      color: colorParsed,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'stat_value': value,
      'suffix': suffix,
      'icon_key': iconKey,
      'color_hex': colorHex,
    };
  }
}

class KeyFiguresViewModel extends ChangeNotifier {
  List<KeyFigure> _stats = [];
  bool _isLoading = true;
  bool _isSaving = false;

  List<KeyFigure> get stats => _stats;
  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;

  Future<void> fetchStats() async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await http.get(Uri.parse('https://alumni.theo-airey.fr/get_key_figures.php'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          _stats = (data['data'] as List).map((i) => KeyFigure.fromJson(i)).toList();
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> saveData() async {
    _isSaving = true;
    notifyListeners();

    try {
      String jsonBody = json.encode(_stats.map((e) => e.toJson()).toList());
      const storage = FlutterSecureStorage();
      String? token = await storage.read(key: 'jwt_token');

      final response = await http.post(
        Uri.parse('https://alumni.theo-airey.fr/set_key_figures.php'),
        body: jsonBody,
        headers: {
          "Content-Type": "application/json",
          "X-Authorization": "Bearer $token",
        },
      );

      final result = json.decode(response.body);

      if (result['status'] == 'success') {
        _isSaving = false;
        notifyListeners();
        return true;
      } else {
        throw Exception(result['message']);
      }
    } catch (e) {
      _isSaving = false;
      notifyListeners();
      rethrow;
    }
  }

  void refreshUI() {
    notifyListeners();
  }
}