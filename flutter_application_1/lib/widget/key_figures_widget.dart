import 'dart:convert';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// --- MODELE DE DONNEES ---
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

final Map<String, IconData> availableIcons = {
  'school': Icons.school,
  'public': Icons.public,
  'calendar': Icons.calendar_today,
  'business': Icons.business,
  'euro': Icons.euro_symbol,
  'science': Icons.science,
  'computer': Icons.computer,
  'groups': Icons.groups,
  'rocket': Icons.rocket_launch,
  'event': Icons.event,
  'work': Icons.work,
};

// --- WIDGET PRINCIPAL ---
class KeyFiguresWidget extends StatefulWidget {
  final bool isAdmin;
  const KeyFiguresWidget({super.key, required this.isAdmin});

  @override
  State<KeyFiguresWidget> createState() => _KeyFiguresWidgetState();
}

class _KeyFiguresWidgetState extends State<KeyFiguresWidget> {
  bool _isEditing = false;
  bool _isLoading = true; // Chargement initial (GET)
  bool _isSaving = false; // Chargement sauvegarde (POST)
  List<KeyFigure> stats = [];

  @override
  void initState() {
    super.initState();
    _fetchStats();
  }

  Future<void> _fetchStats() async {
    try {
      final response = await http.get(Uri.parse('https://alumni.theo-airey.fr/get_key_figures.php'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          if (mounted) {
            setState(() {
              stats = (data['data'] as List).map((i) => KeyFigure.fromJson(i)).toList();
              _isLoading = false;
            });
          }
        }
      }
    } catch (e) {
      print("Erreur de connexion : $e");
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // --- LOGIQUE DE SAUVEGARDE CORRIGÉE ---
  Future<void> _saveData() async {
    // 1. On active l'état "Sauvegarde en cours" pour afficher le loader
    setState(() => _isSaving = true);

    try {
      String jsonBody = json.encode(stats.map((e) => e.toJson()).toList());

      final response = await http.post(
        Uri.parse('https://alumni.theo-airey.fr/set_key_figures.php'),
        body: jsonBody,
        headers: {"Content-Type": "application/json"},
      );

      final result = json.decode(response.body);

      // 2. Si succès UNIQUEMENT, on ferme le mode édition
      if (result['status'] == 'success') {
        if (mounted) {
          setState(() {
            _isEditing = false;
            _isSaving = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Mise à jour réussie !"), backgroundColor: Colors.green),
          );
        }
      } else {
        throw Exception(result['message']);
      }
    } catch (e) {
      // 3. Si erreur, on reste en mode édition pour laisser l'utilisateur réessayer
      if (mounted) {
        setState(() => _isSaving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erreur sauvegarde : $e"), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
          height: 200,
          color: Colors.white,
          child: const Center(child: CircularProgressIndicator())
      );
    }

    return Container(
      color: _isEditing ? Colors.grey[50] : Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      child: Stack(
        clipBehavior: Clip.none, // Permet aux ombres de ne pas être coupées
        alignment: Alignment.topRight,
        children: [
          // CONTENU PRINCIPAL (Admin ou Public)
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: _isEditing
                ? _buildAdminInterface()
                : _buildPublicInterface(),
          ),

          // BOUTON FLOTTANT SIMPLIFIÉ
          if (widget.isAdmin)
            Positioned(
              top: 0,
              right: 0,
              child: _buildSimpleEditButton(),
            ),
        ],
      ),
    );
  }

  // --- NOUVEAU DESIGN DU BOUTON ---
  Widget _buildSimpleEditButton() {
    return Material(
      color: Colors.white,
      elevation: 4, // L'ombre demandée
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: _isSaving
            ? null // Désactivé pendant la sauvegarde
            : () {
          if (_isEditing) {
            _saveData();
          } else {
            setState(() => _isEditing = true);
          }
        },
        child: Container(
          width: 50,
          height: 50,
          alignment: Alignment.center,
          // Si sauvegarde : Loader, Si Edition : Check vert, Sinon : Crayon gris/rouge
          child: _isSaving
              ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))
              : Icon(
            _isEditing ? Icons.check : Icons.edit,
            color: _isEditing ? Colors.green : const Color(0xFFE30613),
            size: 24,
          ),
        ),
      ),
    );
  }

  Widget _buildPublicInterface() {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isMobile = screenWidth < 800;

    return Center(
      key: const ValueKey("Public"),
      child: isMobile
          ? Column(children: stats.map((s) => Padding(padding: const EdgeInsets.only(bottom: 40), child: _buildStatCard(s))).toList())
          : Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: stats.map((s) => _buildStatCard(s)).toList()
      ),
    );
  }

  Widget _buildStatCard(KeyFigure stat) {
    IconData icon = availableIcons[stat.iconKey] ?? Icons.help;

    return TweenAnimationBuilder<double>(
      key: ValueKey(stat.value),
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 800),
      builder: (context, val, child) {
        return Opacity(
          opacity: val,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - val)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: stat.color, size: 40),
                const SizedBox(height: 10),
                Text(
                  "${(stat.value * val).toInt()}${stat.suffix}",
                  style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                Text(stat.label, style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAdminInterface() {
    double width = MediaQuery.of(context).size.width;
    bool isMobile = width < 900;

    var formSection = Column(
      children: stats.asMap().entries.map((entry) {
        int idx = entry.key;
        KeyFigure stat = entry.value;
        return Card(
          margin: const EdgeInsets.only(bottom: 15),
          elevation: 2,
          child: ExpansionTile(
            initiallyExpanded: idx == 0,
            leading: Icon(availableIcons[stat.iconKey], color: stat.color),
            title: Text("Bloc ${idx + 1} : ${stat.label}", style: const TextStyle(fontWeight: FontWeight.bold)),
            children: [
              Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: TextFormField(
                            initialValue: stat.value.toString(),
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(labelText: "Chiffre", border: OutlineInputBorder()),
                            onChanged: (val) => setState(() => stat.value = int.tryParse(val) ?? 0),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            initialValue: stat.suffix,
                            decoration: const InputDecoration(labelText: "Suffixe", border: OutlineInputBorder()),
                            onChanged: (val) => setState(() => stat.suffix = val),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      initialValue: stat.label,
                      decoration: const InputDecoration(labelText: "Titre (Label)", border: OutlineInputBorder()),
                      onChanged: (val) => setState(() => stat.label = val),
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: availableIcons.containsKey(stat.iconKey) ? stat.iconKey : 'school',
                      decoration: const InputDecoration(labelText: "Icône", border: OutlineInputBorder()),
                      items: availableIcons.entries.map((e) => DropdownMenuItem(
                        value: e.key,
                        child: Row(children: [Icon(e.value, size: 20), const SizedBox(width: 10), Text(e.key)]),
                      )).toList(),
                      onChanged: (val) => setState(() => stat.iconKey = val!),
                    )
                  ],
                ),
              )
            ],
          ),
        );
      }).toList(),
    );

    // On ajoute un padding en bas pour éviter que le dernier élément soit caché par le clavier ou le scroll
    if (isMobile) {
      return ListView(
          shrinkWrap: true, // Important si dans une Column parente
          physics: const NeverScrollableScrollPhysics(), // Scroll géré par la page principale
          children: [formSection, const SizedBox(height: 20)]
      );
    } else {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 4, child: formSection),
          const VerticalDivider(width: 50),
          Expanded(flex: 6, child: Column(
            children: [
              const Chip(label: Text("APERÇU EN DIRECT")),
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: stats.map((s) => _buildSimplePreview(s)).toList(),
              ),
            ],
          )),
        ],
      );
    }
  }

  Widget _buildSimplePreview(KeyFigure stat) {
    return Column(
      children: [
        Icon(availableIcons[stat.iconKey], color: stat.color, size: 40),
        Text("${stat.value}${stat.suffix}", style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
        Text(stat.label),
      ],
    );
  }
}