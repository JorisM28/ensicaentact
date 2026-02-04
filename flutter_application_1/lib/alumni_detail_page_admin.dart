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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.alumni.nomComplet),
        backgroundColor: AppColors.ensiCyan,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, _modifiee);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(_enEdition ? Icons.save : Icons.edit),
            tooltip: _enEdition ? "Enregistrer" : "Modifier",
            onPressed: () {
              if (_enEdition) {
                _sauvegarder();
              } else {
                setState(() {
                  _enEdition = true;
                });
              }
            },
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
            const SizedBox(height: 20),
            Text(
              widget.alumni.nomComplet,
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            Text(
              "Promo ${widget.alumni.promo}",
              style: const TextStyle(fontSize: 20, color: Colors.grey),
            ),
            const Divider(height: 40),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Card(
                    elevation: 2,
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Informations Pro",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        ListTile(
                          leading: const Icon(Icons.work, color: Colors.blue),
                          title: const Text("Poste actuel"),
                          subtitle: _enEdition
                              ? TextField(
                            controller: _posteCtrl,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                          )
                              : Text(posteActuel),
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading: const Icon(
                            Icons.school,
                            color: Colors.orange,
                          ),
                          title: const Text("Filière"),
                          subtitle: _enEdition
                              ? TextField(
                            controller: _filiereCtrl,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                          )
                              : Text(filiereActuelle),
                        ),
                        const Divider(height: 1),

                        ListTile(
                          leading: const Icon(
                            Icons.business,
                            color: Colors.indigo,
                          ),
                          title: const Text("Entreprise"),
                          subtitle: _enEdition
                              ? TextField(
                            controller: _entrepriseCtrl,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                          )
                              : Text(entrepriseActuelle),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(width: 10),
                const SizedBox(width: 10),

                Expanded(
                  child: Card(
                    elevation: 2,
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Coordonnées",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),

                        ListTile(
                          leading: const Icon(
                            Icons.location_on,
                            color: Colors.red,
                          ),
                          title: const Text("Ville"),
                          subtitle: _enEdition
                              ? TextField(
                            controller: _villeCtrl,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                          )
                              : Text(villeActuelle),
                        ),

                        if (widget.alumni.autor == 1 &&
                            widget.alumni.decede == 0) ...[
                          const Divider(height: 1),
                          ListTile(
                            leading: const Icon(
                              Icons.email,
                              color: Colors.green,
                            ),
                            title: const Text("Email"),
                            subtitle: _enEdition
                                ? TextField(
                              controller: _emailCtrl,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                            )
                                : Text(emailActuel),
                          ),
                          const Divider(height: 1),
                          ListTile(
                            leading: const Icon(
                              Icons.phone,
                              color: Colors.amber,
                            ),
                            title: const Text("Téléphone"),
                            subtitle: _enEdition
                                ? TextField(
                              controller: _telCtrl,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                            )
                                : Text(telActuel),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
