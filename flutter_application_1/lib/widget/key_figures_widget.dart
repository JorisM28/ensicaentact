import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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

class KeyFiguresWidget extends StatefulWidget {
  final bool isAdmin;
  const KeyFiguresWidget({super.key, required this.isAdmin});

  @override
  State<KeyFiguresWidget> createState() => _KeyFiguresWidgetState();
}

class _KeyFiguresWidgetState extends State<KeyFiguresWidget> {
  bool _isEditing = false;
  bool _isLoading = true;
  bool _isSaving = false;
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

  Future<void> _saveData() async {
    setState(() => _isSaving = true);

    try {
      String jsonBody = json.encode(stats.map((e) => e.toJson()).toList());

      final response = await http.post(
        Uri.parse('https://alumni.theo-airey.fr/set_key_figures.php'),
        body: jsonBody,
        headers: {"Content-Type": "application/json"},
      );

      final result = json.decode(response.body);

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
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topRight,
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: _isEditing
                ? _buildAdminInterface()
                : _buildPublicInterface(),
          ),

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

  Widget _buildSimpleEditButton() {
    return Material(
      color: Colors.white,
      elevation: 4,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: _isSaving
            ? null
            : () {
          if (_isEditing) {
            _saveData();
          } else {
            setState(() => _isEditing = true);
          }
        },
        child: Container(
          width: 40,
          height: 40,
          alignment: Alignment.center,
          child: _isSaving
              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
              : Icon(
            _isEditing ? Icons.check : Icons.edit,
            color: _isEditing ? Colors.green : const Color(0xFFE30613),
            size: 20,
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
          ? Wrap(
        spacing: 15,
        runSpacing: 20,
        alignment: WrapAlignment.center,
        children: stats.map((s) {
          double itemWidth = (screenWidth - 60) / 2;
          return SizedBox(
            width: itemWidth,
            child: _buildStatCard(s, compactMode: true),
          );
        }).toList(),
      )
          : Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: stats.map((s) => _buildStatCard(s, compactMode: false)).toList(),
      ),
    );
  }

  Widget _buildStatCard(KeyFigure stat, {bool compactMode = false}) {
    IconData icon = availableIcons[stat.iconKey] ?? Icons.help;

    double iconSize = compactMode ? 30 : 40;
    double numberSize = compactMode ? 24 : 32;
    double labelSize = compactMode ? 12 : 14;

    return TweenAnimationBuilder<double>(
      key: ValueKey(stat.id),
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 800),
      builder: (context, val, child) {
        return Opacity(
          opacity: val,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - val)),
            child: Container(
              decoration: compactMode ? BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(10),
              ) : null,
              padding: compactMode ? const EdgeInsets.all(10) : EdgeInsets.zero,

              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.all(compactMode ? 8 : 12),
                    decoration: BoxDecoration(
                      color: stat.color.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: stat.color, size: iconSize),
                  ),
                  SizedBox(height: compactMode ? 8 : 10),

                  Text(
                    "${(stat.value * val).toInt()}${stat.suffix}",
                    style: TextStyle(
                      fontSize: numberSize,
                      fontWeight: FontWeight.bold,
                      height: 1.0,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: compactMode ? 4 : 5),

                  Text(
                    stat.label,
                    style: TextStyle(
                        fontSize: labelSize,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.bold
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
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

    if (isMobile) {
      return ListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
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
              const Chip(label: Text("Aperçu en direct")),
              const SizedBox(height: 35),
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