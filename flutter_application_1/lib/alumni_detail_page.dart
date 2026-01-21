import 'package:flutter/material.dart';
import 'colors.dart';
import 'alumnis.dart';
import 'database_service.dart';

class AlumniDetailPage extends StatefulWidget {
  final Alumnis alumni;

  const AlumniDetailPage({super.key, required this.alumni});

  @override
  State<AlumniDetailPage> createState() => _AlumniDetailPageState();
}

class _AlumniDetailPageState extends State<AlumniDetailPage> {
  // Variable pour savoir si on est en mode édition
  bool _enEdition = false;

  
  late TextEditingController _posteCtrl;
  late TextEditingController _entrepriseCtrl;
  late TextEditingController _villeCtrl;


  late String jobActuel;
  late String entrepriseActuelle;
  late String villeActuelle;

  @override
  void initState() {
    super.initState();
  
    jobActuel = widget.alumni.job;
    entrepriseActuelle = widget.alumni.entreprise;
    villeActuelle = widget.alumni.ville;

    _posteCtrl = TextEditingController(text: jobActuel);
    _entrepriseCtrl = TextEditingController(text: entrepriseActuelle);
    _villeCtrl = TextEditingController(text: villeActuelle);
  }

  @override
  void dispose() {
    // Nettoyage de la mémoire
    _posteCtrl.dispose();
    _entrepriseCtrl.dispose();
    _villeCtrl.dispose();
    super.dispose();
  }

  // Fonction pour sauvegarder les changements
  void _sauvegarder() async {

    await DatabaseService().modifierEleve({
      "nom": widget.alumni.nom,   
      "prenom": widget.alumni.prenom,
      "poste": _posteCtrl.text,
      "entreprise": _entrepriseCtrl.text,
      "ville": _villeCtrl.text,
    });

    setState(() {
      jobActuel = _posteCtrl.text;
      entrepriseActuelle = _entrepriseCtrl.text;
      villeActuelle = _villeCtrl.text;
      _enEdition = false; // On quitte le mode édition
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Profil mis à jour avec succès !"), backgroundColor: Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.alumni.nomComplet),
        backgroundColor: AppColors.ensiCyan,
        foregroundColor: Colors.white,
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

            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
          
                    ListTile(
                      leading: const Icon(Icons.work, color: Colors.blue),
                      title: const Text("Poste actuel"),
                      subtitle: _enEdition
                          ? TextField(controller: _posteCtrl, decoration: const InputDecoration(border: OutlineInputBorder()))
                          : Text(jobActuel, style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    const Divider(),

                 
                    ListTile(
                      leading: const Icon(Icons.business, color: Colors.indigo),
                      title: const Text("Entreprise"),
                      subtitle: _enEdition
                          ? TextField(controller: _entrepriseCtrl, decoration: const InputDecoration(border: OutlineInputBorder()))
                          : Text(entrepriseActuelle),
                    ),
                    const Divider(),
                    

                    ListTile(
                      leading: const Icon(Icons.location_on, color: Colors.red),
                      title: const Text("Ville"),
                      subtitle: _enEdition
                          ? TextField(controller: _villeCtrl, decoration: const InputDecoration(border: OutlineInputBorder()))
                          : Text(villeActuelle),
                    ),
                    
         
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.school, color: Colors.orange),
                      title: const Text("Filière"),
                      subtitle: Text(widget.alumni.filiere), 
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}