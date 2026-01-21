import 'package:flutter/material.dart';
import 'package:flutter_application_ensicaentact/colors.dart';
import 'package:flutter_application_ensicaentact/alumni_detail_page.dart';
import 'filtre.dart';
import 'alumnis.dart';
import 'database_service.dart';


void main() {
  runApp(const MonReseauAlumni());
}

class MonReseauAlumni extends StatelessWidget {
  const MonReseauAlumni({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: AppColors.ensiCyan),
      home: const PageAnnuaire(),
    );
  }
}

class PageAnnuaire extends StatelessWidget {
  final bool estAdmin;

  const PageAnnuaire({super.key, this.estAdmin = true});
  @override
  Widget build(BuildContext context) {
    double largeurEcran = MediaQuery.of(context).size.width;
    bool estGrandEcran = largeurEcran > 800;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset('assets/logo_alumni.png', scale: 20),
            const SizedBox(width: 20),
            const Text("ENSIcaentact"),
            const Spacer(),
            const Icon(Icons.account_circle, size: 40),
          ],
        ),
        backgroundColor: AppColors.ensiCyan,
        foregroundColor: Colors.white,
        actions: [
        if (estAdmin) 
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: "Historique des actions",
            onPressed: () => _afficherHistorique(context),
          ),
        ],
      ),

      body: Column(
        children: <Widget>[
          
          Container(
            padding: const EdgeInsets.all(20),
            color: Colors.grey[100],
            child: estGrandEcran
                ? Row(
                    children: [
                      SizedBox(width: 400, child: _champRecherche()),
                      const Spacer(),
                      const FilterChipExample(), 
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Trouver un mentor", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 15),
                      _champRecherche(),
                      const SizedBox(height: 15),
                      const FilterChipExample(),
                    ],
                  ),
          ),

          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: estGrandEcran ? 2 : 1,
                  child: Container(
                    color: Colors.white,
                    child: FutureBuilder<List<Alumnis>>(
                      future: DatabaseService().getTousLesEleves(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError) {
                          return Center(child: Text("Erreur : ${snapshot.error}", style: const TextStyle(color: Colors.red)));
                        }
                        if (snapshot.hasData) {
                          final lesEleves = snapshot.data!;
                          if (lesEleves.isEmpty) return const Center(child: Text("Aucun résultat."));

                          return ListView.builder(
                            itemCount: lesEleves.length,
                            padding: const EdgeInsets.all(10),
                            itemBuilder: (context, index) {
                              return _carteEleve(context, lesEleves[index]);
                            },
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
                ),

                if (estGrandEcran) ...[
                  const VerticalDivider(width: 1, thickness: 1, color: Colors.grey),
                  Expanded(
                    flex: 1,
                    child: Container(
                      color: Colors.grey[50],
                      padding: const EdgeInsets.all(40),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const CircleAvatar(
                            radius: 60,
                            backgroundColor: AppColors.ensiCyan,
                            child: Icon(Icons.person, size: 60, color: Colors.white),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            "Sélectionnez un élève",
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Cliquez sur un profil à gauche pour voir les détails.",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                          ),
                          const SizedBox(height: 30),
                          ElevatedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.mail),
                            label: const Text("Envoyer un message"),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(15),
            color: AppColors.ensiCyan,
            child: const Column(
              children: [
                Text("© 2026 ENSICAEN Alumni", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),



floatingActionButton: estAdmin 
    ? FloatingActionButton(
        backgroundColor: AppColors.ensiCyan,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          // Contrôleurs pour tous les champs
          final nomCtrl = TextEditingController();
          final prenomCtrl = TextEditingController();
          final ageCtrl = TextEditingController();
          final posteCtrl = TextEditingController();
          final entrepriseCtrl = TextEditingController();
          final villeCtrl = TextEditingController();
          final stageCtrl = TextEditingController();
          final promoCtrl = TextEditingController();
          final filiereCtrl = TextEditingController();

          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("Nouvel Alumni"),
              content: SizedBox(
                width: 500,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text("Identité", style: TextStyle(fontWeight: FontWeight.bold)),
                      TextField(controller: nomCtrl, decoration: const InputDecoration(labelText: "Nom")),
                      TextField(controller: prenomCtrl, decoration: const InputDecoration(labelText: "Prénom")),
                      TextField(controller: ageCtrl, decoration: const InputDecoration(labelText: "Âge"), keyboardType: TextInputType.number),
                      const Divider(),
                      const Text("Parcours ENSI", style: TextStyle(fontWeight: FontWeight.bold)),
                      TextField(controller: promoCtrl, decoration: const InputDecoration(labelText: "Année Promo (ex: 2024)"), keyboardType: TextInputType.number),
                      TextField(controller: filiereCtrl, decoration: const InputDecoration(labelText: "Filière (Info, MC, GPSE)")),
                      TextField(controller: stageCtrl, decoration: const InputDecoration(labelText: "Sujet de stage (PFE)")),
                      const Divider(),
                      const Text("Poste Actuel", style: TextStyle(fontWeight: FontWeight.bold)),
                      TextField(controller: posteCtrl, decoration: const InputDecoration(labelText: "Intitulé du poste")),
                      TextField(controller: entrepriseCtrl, decoration: const InputDecoration(labelText: "Entreprise")),
                      TextField(controller: villeCtrl, decoration: const InputDecoration(labelText: "Ville")),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text("Annuler")),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.ensiCyan),
                  onPressed: () async {
                    if (nomCtrl.text.isNotEmpty && prenomCtrl.text.isNotEmpty) {
                      await DatabaseService().ajouterEleve({
                        "nom": nomCtrl.text,
                        "prenom": prenomCtrl.text,
                        "age": int.tryParse(ageCtrl.text) ?? 22,
                        "annee_promo": int.tryParse(promoCtrl.text) ?? 2024,
                        "filiere": filiereCtrl.text,
                        "sujet_stage": stageCtrl.text,
                        "poste": posteCtrl.text,
                        "entreprise": entrepriseCtrl.text,
                        "ville": villeCtrl.text,
                      });
                      Navigator.pop(context);
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const PageAnnuaire()));
                    }
                  },
                  child: const Text("Enregistrer", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          );
        },
      )
    : null,

    );
  }
  Widget _champRecherche() {
    return TextField(
      decoration: InputDecoration(
        hintText: "Rechercher...",
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }
  void _afficherHistorique(BuildContext context) async {
  // On récupère les logs depuis le service
  final logs = await DatabaseService().getHistorique();

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.history, color: AppColors.ensiCyan),
          SizedBox(width: 10),
          Text("Historique des actions"),
        ],
      ),
      content: SizedBox(
        width: 500,
        height: 400,
        child: logs.isEmpty
            ? const Center(child: Text("Aucune action enregistrée."))
            : ListView.builder(
                itemCount: logs.length,
                itemBuilder: (context, index) {
                  final log = logs[index];
                  final bool isDelete = log['action'] == 'SUPPRESSION';
                  
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: isDelete ? Colors.red[50] : Colors.green[50],
                      child: Icon(
                        isDelete ? Icons.delete_forever : Icons.person_add,
                        color: isDelete ? Colors.red : Colors.green,
                        size: 20,
                      ),
                    ),
                    title: Text(
                      "${log['prenom_alumni']} ${log['nom_alumni']}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      "${log['action']} le ${log['date_action']}",
                      style: const TextStyle(fontSize: 12),
                    ),
                  );
                },
              ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Fermer"),
        ),
      ],
    ),
  );
}
  // Ajoute 'BuildContext context' dans les paramètres
  Widget _carteEleve(BuildContext context, Alumnis eleve) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 15),
      clipBehavior: Clip.antiAlias, // Nécessaire pour que l'effet visuel du clic reste dans la carte
      child: InkWell( // InkWell ajoute un effet visuel au clic (vague)
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AlumniDetailPage(alumni: eleve),
            ),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const PageAnnuaire()),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: AppColors.ensiCyan,
                radius: 30,
                child: Text(
                  eleve.prenom.isNotEmpty ? eleve.prenom[0] : "?",
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      eleve.nomComplet,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    if (eleve.promo != null)
                      Text("'${eleve.promo.toString().substring(2)}", style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.bold)),
                    Text("${eleve.job} @ ${eleve.entreprise}", style: TextStyle(color: Colors.grey[800])),
                    const SizedBox(height: 5),
                    Wrap(
                      spacing: 5,
                      children: [
                        Chip(label: Text(eleve.filiere, style: const TextStyle(fontSize: 10)), backgroundColor: Colors.blue[50]),
                        Chip(avatar: const Icon(Icons.location_on, size: 14), label: Text(eleve.ville, style: const TextStyle(fontSize: 10)), backgroundColor: Colors.orange[50]),
                      ],
                    ),
                  ],
                ),
              ),
              estAdmin
              ? IconButton(
                icon : const Icon(Icons.delete, color: Colors.red),
                onPressed: () async {
                  bool confirmation = await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Supprimer ?"),
                      content: Text("Veux-tu vraiment supprimer ${eleve.nomComplet} ?"),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Non")),
                        TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("Oui")),
                      ]
                    ),
                  ) ?? false;

                  if (confirmation) {
                    await DatabaseService().supprimerEleve(eleve.nom, eleve.prenom);

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const PageAnnuaire())
                    );
                  }
                },
              )
            : IconButton (
              icon: const Icon(Icons.send, color : AppColors.ensiCyan),
              onPressed: () {},
            ),
            ],
          ),
        ),
      ),
    );
  }

}