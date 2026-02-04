import 'package:flutter/material.dart';
import 'colors.dart';
import 'alumnis.dart';
import 'database_service.dart';

class AlumniDetailPageAdmin extends StatefulWidget {
  final Alumnis alumni;
  final VoidCallback? onSave;

  const AlumniDetailPageAdmin({super.key, required this.alumni, this.onSave});

  @override
  State<AlumniDetailPageAdmin> createState() => _AlumniDetailPageAdminState();
}

class _AlumniDetailPageAdminState extends State<AlumniDetailPageAdmin> {
  bool _enEdition = false;
  bool _modifiee = false;

  late TextEditingController _posteCtrl;
  late TextEditingController _entrepriseCtrl;
  late TextEditingController _villeCtrl;
  late TextEditingController _emailCtrl;
  late TextEditingController _telCtrl;
  late TextEditingController _filiereCtrl;

  late String posteActuel;
  late String entrepriseActuelle;
  late String filiereActuelle;
  late String villeActuelle;
  late String emailActuel;
  late String telActuel;

  @override
  void initState() {
    super.initState();

    posteActuel = widget.alumni.job;
    entrepriseActuelle = widget.alumni.entreprise;
    villeActuelle = widget.alumni.ville;
    filiereActuelle = widget.alumni.filiere;
    emailActuel = widget.alumni.email;
    telActuel = widget.alumni.tel;

    _posteCtrl = TextEditingController(text: posteActuel);
    _entrepriseCtrl = TextEditingController(text: entrepriseActuelle);
    _villeCtrl = TextEditingController(text: villeActuelle);
    _emailCtrl = TextEditingController(text: emailActuel);
    _telCtrl = TextEditingController(text: telActuel);
    _filiereCtrl = TextEditingController(text: filiereActuelle);
  }

  @override
  void dispose() {
    _posteCtrl.dispose();
    _entrepriseCtrl.dispose();
    _villeCtrl.dispose();
    _emailCtrl.dispose();
    _telCtrl.dispose();
    _filiereCtrl.dispose();
    super.dispose();
  }

  void _sauvegarder() async {
    await DatabaseService().modifierEleve({
      "id": widget.alumni.id,
      "nom": widget.alumni.nom,
      "prenom": widget.alumni.prenom,
      "poste": _posteCtrl.text,
      "entreprise": _entrepriseCtrl.text,
      "ville": _villeCtrl.text,
      "filiere": _filiereCtrl.text,
      "email": _emailCtrl.text,
      "tel": _telCtrl.text,
    });

    if (widget.onSave != null) {
      print("Appel du callback de rechargement...");
      widget.onSave!();
    }
    if (!mounted) return;

    setState(() {
      posteActuel = _posteCtrl.text;
      entrepriseActuelle = _entrepriseCtrl.text;
      villeActuelle = _villeCtrl.text;
      filiereActuelle = _filiereCtrl.text;
      emailActuel = _emailCtrl.text;
      telActuel = _telCtrl.text;
      _enEdition = false;
      _modifiee = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Profil mis à jour avec succès !"),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget _buildInfoCard(String titre, List<Widget> children) {
    return Card(
      elevation: 2,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(titre, style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          ...children,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool estGrand = screenWidth > 800;



    List<Widget> proTiles = [
      _buildListTile(Icons.work, "Poste actuel", _posteCtrl, posteActuel, Colors.blue),
      const Divider(height: 1),
      _buildListTile(Icons.school, "Filière", _filiereCtrl, filiereActuelle, Colors.orange),
      const Divider(height: 1),
      _buildListTile(Icons.business, "Entreprise", _entrepriseCtrl, entrepriseActuelle, Colors.indigo),
    ];

    List<Widget> coordonneeTiles = [
      _buildListTile(Icons.location_on, "Ville", _villeCtrl, villeActuelle, Colors.red),
      if (widget.alumni.autor == 1 && widget.alumni.decede == 0) ...[
        const Divider(height: 1),
        _buildListTile(Icons.email, "Email", _emailCtrl, emailActuel, Colors.green),
        const Divider(height: 1),
        _buildListTile(Icons.phone, "Téléphone", _telCtrl, telActuel, Colors.amber),
      ],
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.alumni.nomComplet),
        backgroundColor: AppColors.ensiCyan,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(_enEdition ? Icons.save : Icons.edit),
            onPressed: () => _enEdition ? _sauvegarder() : setState(() => _enEdition = true),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 60,
              backgroundColor: AppColors.ensiCyan,
              child: Text(
                widget.alumni.prenom.isNotEmpty ? widget.alumni.prenom[0] : "?",
                style: const TextStyle(fontSize: 50, color: Colors.white),
              ),
            ),
            const SizedBox(height: 10),
            Text(widget.alumni.nomComplet, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
            Text("Promo ${widget.alumni.promo}", style: const TextStyle(fontSize: 20, color: Colors.grey)),
            const Divider(height: 40),

            if (estGrand)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildInfoCard("Informations Pro", proTiles)),
                  const SizedBox(width: 20),
                  Expanded(child: _buildInfoCard("Coordonnées", coordonneeTiles)),
                ],
              )
            else
              Column(
                children: [
                  _buildInfoCard("Informations Pro", proTiles),
                  const SizedBox(height: 20),
                  _buildInfoCard("Coordonnées", coordonneeTiles),
                ],
              ),
          ],
        ),
      ),
    );
  }


  Widget _buildListTile(IconData icon, String label, TextEditingController ctrl, String valeurActuelle, Color color) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(label),
      subtitle: _enEdition
          ? TextField(controller: ctrl, decoration: const InputDecoration(border: OutlineInputBorder()))
          : Text(valeurActuelle),
    );
  }
}