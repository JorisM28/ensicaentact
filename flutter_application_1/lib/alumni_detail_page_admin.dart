import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Nécessaire pour inputFormatters
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

  late TextEditingController _nomCtrl;
  late TextEditingController _prenomCtrl;
  late TextEditingController _promoCtrl;
  late TextEditingController _posteCtrl;
  late TextEditingController _entrepriseCtrl;
  late TextEditingController _villeCtrl;
  late TextEditingController _emailCtrl;
  late TextEditingController _telCtrl;
  late TextEditingController _filiereCtrl;

  late bool _autorSwitch;
  late bool _decedeSwitch;

  late String nomActuel;
  late String prenomActuel;
  late int promoActuelle;
  late String posteActuel;
  late String entrepriseActuelle;
  late String filiereActuelle;
  late String villeActuelle;
  late String emailActuel;
  late String telActuel;

  @override
  void initState() {
    super.initState();

    nomActuel = widget.alumni.nom;
    prenomActuel = widget.alumni.prenom;
    promoActuelle = widget.alumni.promo;
    posteActuel = widget.alumni.job;
    entrepriseActuelle = widget.alumni.entreprise;
    villeActuelle = widget.alumni.ville;
    filiereActuelle = widget.alumni.filiere;
    emailActuel = widget.alumni.email;
    telActuel = widget.alumni.tel;

    _nomCtrl = TextEditingController(text: nomActuel);
    _prenomCtrl = TextEditingController(text: prenomActuel);
    _promoCtrl = TextEditingController(text: promoActuelle.toString());
    _posteCtrl = TextEditingController(text: posteActuel);
    _entrepriseCtrl = TextEditingController(text: entrepriseActuelle);
    _villeCtrl = TextEditingController(text: villeActuelle);
    _emailCtrl = TextEditingController(text: emailActuel);
    _telCtrl = TextEditingController(text: telActuel);
    _filiereCtrl = TextEditingController(text: filiereActuelle);

    _autorSwitch = widget.alumni.autor == 1;
    _decedeSwitch = widget.alumni.decede == 1;
  }

  @override
  void dispose() {
    _nomCtrl.dispose();
    _prenomCtrl.dispose();
    _promoCtrl.dispose();
    _posteCtrl.dispose();
    _entrepriseCtrl.dispose();
    _villeCtrl.dispose();
    _emailCtrl.dispose();
    _telCtrl.dispose();
    _filiereCtrl.dispose();
    super.dispose();
  }

  void _sauvegarder() async {
    int promoInt = int.tryParse(_promoCtrl.text) ?? promoActuelle;
    int autorInt = _autorSwitch ? 1 : 0;
    int decedeInt = _decedeSwitch ? 1 : 0;

    await DatabaseService().modifierEleve({
      "id": widget.alumni.id,
      "nom": _nomCtrl.text.trim(),
      "prenom": _prenomCtrl.text.trim(),
      "promo": promoInt,
      "autor": autorInt,
      "decede": decedeInt,
      "poste": _posteCtrl.text.trim(),
      "entreprise": _entrepriseCtrl.text.trim(),
      "ville": _villeCtrl.text.trim(),
      "filiere": _filiereCtrl.text.trim(),
      "email": _emailCtrl.text.trim(),
      "tel": _telCtrl.text.trim(),
    });

    if (widget.onSave != null) {
      widget.onSave!();
    }
    
    if (!mounted) return;

    setState(() {
      nomActuel = _nomCtrl.text.trim();
      prenomActuel = _prenomCtrl.text.trim();
      promoActuelle = promoInt;
      posteActuel = _posteCtrl.text.trim();
      entrepriseActuelle = _entrepriseCtrl.text.trim();
      villeActuelle = _villeCtrl.text.trim();
      filiereActuelle = _filiereCtrl.text.trim();
      emailActuel = _emailCtrl.text.trim();
      telActuel = _telCtrl.text.trim();
      
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
        title: Text(_enEdition ? "Modifier Alumni" : "$prenomActuel $nomActuel"),
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
                prenomActuel.isNotEmpty ? prenomActuel[0] : "?",
                style: const TextStyle(fontSize: 50, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),

            if (_enEdition) ...[
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _prenomCtrl,
                      decoration: const InputDecoration(labelText: "Prénom", border: OutlineInputBorder()),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _nomCtrl,
                      decoration: const InputDecoration(labelText: "Nom", border: OutlineInputBorder()),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _promoCtrl,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(labelText: "Promo (Année)", border: OutlineInputBorder()),
              ),
            ] else ...[
              Text(
                "$prenomActuel $nomActuel",
                style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              Text(
                "Promo $promoActuelle",
                style: const TextStyle(fontSize: 20, color: Colors.grey),
              ),
            ],

            const Divider(height: 40),

            if (_enEdition)
              Card(
                color: Colors.grey[100],
                elevation: 0,
                margin: const EdgeInsets.only(bottom: 20),
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("Statut Administrateur", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54)),
                    ),
                    SwitchListTile(
                      title: const Text("Autorisation des données"),
                      subtitle: Text(_autorSwitch ? "L'alumni accepte d'apparaître" : "L'alumni refuse/n'a pas répondu"),
                      activeColor: Colors.green,
                      value: _autorSwitch,
                      onChanged: (val) => setState(() => _autorSwitch = val),
                    ),
                    const Divider(height: 1),
                    SwitchListTile(
                      title: const Text("Décédé"),
                      subtitle: const Text("Marquer ce profil comme décédé"),
                      activeColor: Colors.red,
                      value: _decedeSwitch,
                      onChanged: (val) => setState(() => _decedeSwitch = val),
                    ),
                  ],
                ),
              ),

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
                              ? TextField(controller: _posteCtrl, decoration: const InputDecoration(isDense: true))
                              : Text(posteActuel),
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading: const Icon(Icons.school, color: Colors.orange),
                          title: const Text("Filière"),
                          subtitle: _enEdition
                              ? TextField(controller: _filiereCtrl, decoration: const InputDecoration(isDense: true))
                              : Text(filiereActuelle),
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading: const Icon(Icons.business, color: Colors.indigo),
                          title: const Text("Entreprise"),
                          subtitle: _enEdition
                              ? TextField(controller: _entrepriseCtrl, decoration: const InputDecoration(isDense: true))
                              : Text(entrepriseActuelle),
                        ),
                      ],
                    ),
                  ),
                ),
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
                          leading: const Icon(Icons.location_on, color: Colors.red),
                          title: const Text("Ville"),
                          subtitle: _enEdition
                              ? TextField(controller: _villeCtrl, decoration: const InputDecoration(isDense: true))
                              : Text(villeActuelle),
                        ),
                        
                       if (_enEdition || (_autorSwitch && !_decedeSwitch)) ...[
                          const Divider(height: 1),
                          ListTile(
                            leading: const Icon(Icons.email, color: Colors.green),
                            title: const Text("Email"),
                            subtitle: _enEdition
                                ? TextField(controller: _emailCtrl, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(isDense: true))
                                : Text(emailActuel),
                          ),
                          const Divider(height: 1),
                          ListTile(
                            leading: const Icon(Icons.phone, color: Colors.amber),
                            title: const Text("Téléphone"),
                            subtitle: _enEdition
                                ? TextField(controller: _telCtrl, keyboardType: TextInputType.phone, decoration: const InputDecoration(isDense: true))
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