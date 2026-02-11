import 'package:flutter/material.dart';

// ==========================================
// 1. LE MODÈLE DE DONNÉES & CONFIGURATION
// ==========================================

class KeyFigure {
  String label;
  int value;
  String suffix;
  String iconKey;
  Color color;

  KeyFigure({
    required this.label,
    required this.value,
    this.suffix = "",
    required this.iconKey,
    required this.color,
  });
}

// Liste des icônes disponibles dans le menu déroulant
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
};

// ==========================================
// 2. LE WIDGET PRINCIPAL
// ==========================================

class KeyFiguresWidget extends StatefulWidget {
  final bool isAdmin;

  const KeyFiguresWidget({super.key, this.isAdmin = false});

  @override
  State<KeyFiguresWidget> createState() => _KeyFiguresWidgetState();
}

class _KeyFiguresWidgetState extends State<KeyFiguresWidget> {
  // État local : est-on en train de modifier ?
  bool _isEditing = false;

  // Données initiales (Simule ta Base de Données)
  List<KeyFigure> stats = [
    KeyFigure(label: "DIPLÔMÉS", value: 8000, suffix: "+", iconKey: "school", color: const Color(0xFFE30613)),
    KeyFigure(label: "PAYS", value: 45, suffix: "", iconKey: "public", color: Colors.blue[700]!),
    KeyFigure(label: "ÉVÉNEMENTS", value: 150, suffix: "", iconKey: "calendar", color: Colors.green[700]!),
    KeyFigure(label: "ENTREPRISES", value: 300, suffix: "+", iconKey: "business", color: Colors.teal[700]!),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      // Changement de fond subtil en mode édition pour bien différencier
      color: _isEditing ? Colors.grey[50] : Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      child: Stack(
        alignment: Alignment.topRight,
        children: [

          // A. LE CONTENU (Basculer entre Vue Admin et Vue Publique)
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: _isEditing
                ? _buildAdminInterface()  // Si on édite
                : _buildPublicInterface(), // Vue normale
          ),

          // B. LE BOUTON MAGIQUE (Visible SEULEMENT si isAdmin = true)
          if (widget.isAdmin)
            FloatingActionButton.extended(
              onPressed: () {
                if (_isEditing) {
                  // Action : Sauvegarder
                  _saveData();
                } else {
                  // Action : Entrer en mode édition
                  setState(() => _isEditing = true);
                }
              },
              // Le bouton change d'aspect selon l'état
              backgroundColor: _isEditing ? Colors.green : Colors.redAccent,
              icon: Icon(_isEditing ? Icons.check : Icons.edit, color: Colors.white),
              label: Text(
                  _isEditing ? "Valider" : "Modifier",
                  style: const TextStyle(color: Colors.white)
              ),
            ),
        ],
      ),
    );
  }

  // --- LOGIQUE DE SAUVEGARDE ---
  void _saveData() {
    // ICI : Tu ferais ton appel API vers ta base de données
    // ex: await api.updateStats(stats);

    setState(() => _isEditing = false); // On quitte le mode édition

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Modifications enregistrées !"), backgroundColor: Colors.green),
    );
  }

  // ==========================================
  // 3. VUE PUBLIQUE (Lecture Seule + Animation)
  // ==========================================
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
    // Petite protection si l'icône n'existe pas
    IconData icon = availableIcons[stat.iconKey] ?? Icons.help;

    return TweenAnimationBuilder<double>(
      key: ValueKey(stat.value), // Relance l'anim si la valeur change
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

  // ==========================================
  // 4. VUE ADMIN (Formulaire + Aperçu Live)
  // ==========================================
  Widget _buildAdminInterface() {
    // On affiche une grille responsive : Formulaire à gauche (ou haut), Aperçu à droite (ou bas)
    double width = MediaQuery.of(context).size.width;
    bool isMobile = width < 900;

    var formSection = Column(
      children: stats.asMap().entries.map((entry) {
        int idx = entry.key;
        KeyFigure stat = entry.value;
        return Card(
          margin: const EdgeInsets.only(bottom: 15),
          child: ExpansionTile(
            initiallyExpanded: idx == 0, // Le premier ouvert par défaut
            leading: Icon(availableIcons[stat.iconKey], color: stat.color),
            title: Text("Bloc ${idx + 1} : ${stat.label}", style: const TextStyle(fontWeight: FontWeight.bold)),
            children: [
              Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    // Ligne 1 : Valeur + Suffixe
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
                    // Ligne 2 : Titre
                    TextFormField(
                      initialValue: stat.label,
                      decoration: const InputDecoration(labelText: "Titre (Label)", border: OutlineInputBorder()),
                      onChanged: (val) => setState(() => stat.label = val),
                    ),
                    const SizedBox(height: 10),
                    // Ligne 3 : Menu déroulant Icône
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

    // On retourne la mise en page selon l'écran
    if (isMobile) {
      return ListView(children: [formSection, const SizedBox(height: 80)]); // 80px pour le bouton flottant
    } else {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 4, child: SingleChildScrollView(child: formSection)),
          const VerticalDivider(width: 50),
          Expanded(flex: 6, child: Column(
            children: [
              const Chip(label: Text("APERÇU EN DIRECT")),
              const SizedBox(height: 50),
              // On réutilise _buildStatCard mais sans l'animation d'entrée pour éviter les clignotements
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

  // Version simplifiée pour l'aperçu (sans animation lourde)
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