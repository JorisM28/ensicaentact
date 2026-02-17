import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'page_emploi.dart';
import 'page_annuaire.dart';
import 'page_actualités.dart';
import 'page_moderation.dart';
import 'add_alumni.dart';
import 'colors.dart';
import 'database_service.dart';
import 'widget/actuality_widget.dart';
import 'widget/event_widget.dart';
import 'widget/joboffert_widget.dart';
import 'widget/event_proposition_widget.dart';
import 'widget/key_figures_widget.dart';
import 'widget/custom_app_bar.dart';

class PageAccueil extends StatelessWidget {
  final Map<String, dynamic>? user;


  const PageAccueil({super.key, this.user});

  final Color contentColor = const Color(0xFFF8F9FA);

  Future<void> _ouvrirSiteEcole() async {
    final Uri url = Uri.parse('https://www.ensicaen.fr');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      debugPrint('Impossible de lancer $url');
    }
  }

  void _naviguer(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (c) => page));
  }

  @override
  Widget build(BuildContext context) {
    bool isDesktop = MediaQuery.of(context).size.width > 900;
    // TEST POUR VERIFIER LES FONCTIONALITES.
    //final Map<String, dynamic> currentUser = user ?? {}
    final Map<String, dynamic> userTest = {
      'id_user': '1',
      'role': 'admin', // Change en 'alumni' ou 'student' pour tester d'autres vues
      'name': 'Admin',
      'family_name': 'Test',
      'email': 'admin@test.fr',
    };
    final Map<String, dynamic> currentUser = user ?? userTest;
    final String role = currentUser['role'] ?? 'guest';

    return Scaffold(
      backgroundColor: contentColor,

      appBar: CustomAppBar(user: currentUser),

      endDrawer: !isDesktop ? _buildMobileDrawer(context) : null,

      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20,),

            KeyFiguresWidget(isAdmin: role == "admin"),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: isDesktop
                  ? _buildDesktopLayout(context, currentUser)
                  : _buildMobileLayout(context, currentUser),
            ),

            const Divider(height: 1, thickness: 1),

            JobOfferWidget(user: currentUser),

            _buildFooter(),
          ],
        ),
      ),
    );
  }


  Widget _buildDesktopLayout(BuildContext context, Map<String, dynamic> user) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 2,
              child: ActualityWidget(
                user: user,
                onAddPress: () => _afficherDialogAjoutActu(context),
              ),
            ),

            const VerticalDivider(width: 60, thickness: 1, color: Colors.white),

            Expanded(
              flex: 1,
              child: EventWidget(
                user: user,
                onAddPress: () => _afficherDialogAjoutEvent(context, user),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context, Map<String, dynamic> user) {
    return Column(
      children: [
        Container(
          height: 520,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
          ),
          padding: const EdgeInsets.all(15),
          child: ActualityWidget(
            user: user,
            onAddPress: () => _afficherDialogAjoutActu(context),
          ),
        ),

        const SizedBox(height: 20),

        Container(
          height: 520,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
          ),
          padding: const EdgeInsets.all(15),
          child: EventWidget(
            user: user,
            onAddPress: () => _afficherDialogAjoutEvent(context, user)
          ),
        ),
      ],
    );
  }

  // --- Drawer Mobile ---

  Widget _buildMobileDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(color: AppColors.ensiCyan),
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 20,
              bottom: 20,
            ),
            child: const Center(
              child: Text(
                  "Menu",
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)
              ),
            ),
          ),
          ListTile(leading: const Icon(Icons.newspaper), title: const Text("Actualités"), onTap: () => _naviguer(context, PageActualites(user: user ?? {}))),
          ListTile(leading: const Icon(Icons.people), title: const Text("Annuaire"), onTap: () => _naviguer(context, PageAnnuaire(user: user ?? {}))),
          ListTile(leading: const Icon(Icons.work), title: const Text("Offres"), onTap: () => _naviguer(context, PageEmploi(user: user ?? {}))),
          ListTile(leading: const Icon(Icons.school), title: const Text("Site École"), onTap: _ouvrirSiteEcole),

          // On vérifie que user n'est pas null avant de vérifier le rôle
          if (user != null && (user!['role'] == 'student' || user!['role'] == 'alumni')) ...[
            const Divider(),
            ListTile(leading: const Icon(Icons.event), title: const Text("Proposer un évènement"), onTap: () => _naviguer(context, PageProposerEvenement(user: user ?? {}))),
            if (user!['role'] == 'alumni') ...[
              ListTile(leading: const Icon(Icons.thumb_up), title: const Text("Rejoindre"), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => Scaffold(appBar: AppBar(title: const Text("Rejoindre"), backgroundColor: AppColors.ensiCyan), body: AddAlumniForm(onSuccess: () => Navigator.pop(c)))))),
            ],
          ],

          if (user != null && user!['role'] == 'admin') ...[
            const Divider(),
            ListTile(leading: const Icon(Icons.security), title: const Text("Modération"), onTap: () => _naviguer(context, PageModeration(user: user ?? {}))),
          ],
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(20),
      color: AppColors.ensiCyan,
      width: double.infinity,
      child: const Text("©2026 ENSICAEN Alumni", style: TextStyle(color: Colors.white, fontSize: 18), textAlign: TextAlign.center),
    );
  }

  // --- Logique d'ajout d'actualité ---

  void _afficherDialogAjoutActu(BuildContext context) {
    // Si pas connecté, on empêche l'action
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veuillez vous connecter pour publier une actualité.")),
      );
      return;
    }

    final titleCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final imgCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Nouvelle Actualité"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: "Titre")),
            TextField(controller: descCtrl, decoration: const InputDecoration(labelText: "Description"), maxLines: 3),
            TextField(controller: imgCtrl, decoration: const InputDecoration(labelText: "URL Image (optionnel)")),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Annuler")),
          ElevatedButton(
            onPressed: () async {
              if (titleCtrl.text.isEmpty) return;

              await DatabaseService().ajouterActualite({
                "titre": titleCtrl.text,
                "description": descCtrl.text,
                "image": imgCtrl.text,
                "auteur_id": user!['id_user'] ?? "0", // Ici on peut utiliser ! car on a vérifié null au début de la fonction
              });

              Navigator.pop(ctx);

              Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => PageAccueil(user: user)));
            },
            child: const Text("Publier"),
          ),
        ],
      ),
    );
  }

  void _afficherDialogAjoutEvent(BuildContext context, Map<String, dynamic> currentUser) {
    final titreCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final lieuCtrl = TextEditingController();
    final dateCtrl = TextEditingController(); // Idéalement un DatePicker

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Nouvel Évènement"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: titreCtrl, decoration: const InputDecoration(labelText: "Titre")),
              TextField(controller: descCtrl, decoration: const InputDecoration(labelText: "Description"), maxLines: 3),
              TextField(controller: lieuCtrl, decoration: const InputDecoration(labelText: "Lieu")),
              TextField(
                controller: dateCtrl,
                decoration: const InputDecoration(labelText: "Date (YYYY-MM-DD)"),
                onTap: () async {
                  FocusScope.of(context).requestFocus(FocusNode()); // Fermer le clavier
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    dateCtrl.text = picked.toIso8601String().split('T')[0];
                  }
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Annuler")),
          ElevatedButton(
            onPressed: () async {
              if (titreCtrl.text.isEmpty) return;

              await DatabaseService().proposerEvenement({ // Ou une fonction ajouterEvenementDirectement si tu en as une pour admin
                "titre": titreCtrl.text,
                "description": descCtrl.text,
                "lieu": lieuCtrl.text,
                "date_event": dateCtrl.text,
                "auteur_id": currentUser['id_user'] ?? "1",
                // Si admin, on peut imaginer un champ "valide" à 1 directement
                "valide": 1
              });

              Navigator.pop(ctx);
              // Rafraichir la page
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => PageAccueil(user: currentUser)));
            },
            child: const Text("Publier"),
          ),
        ],
      ),
    );
  }
}