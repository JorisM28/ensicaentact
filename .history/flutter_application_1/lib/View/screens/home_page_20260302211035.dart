import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '/View/screens/alumni/add_alumni.dart';
import 'employment/job_page.dart';
import '/View/screens/alumni/directory_page.dart';
import 'event/news_page.dart';
import 'admin/moderation_page.dart';
import '/View/theme/colors.dart';
import '/View/widget/actuality_widget.dart';
import '/View/widget/event_widget.dart';
import '/View/widget/job_offer_widget.dart';
import '/View/widget/event_proposition_widget.dart';
import '/View/widget/key_figures_widget.dart';
import '/View/widget/custom_app_bar.dart';
import '/service_locator.dart';
import '/Model/data/services/alumni_repository.dart';
import '/Model/data/services/auth_service.dart';

class HomePage extends StatelessWidget {

  const HomePage({super.key});

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
    final currentUser = sl<AuthService>().currentUser;
    bool isDesktop = MediaQuery.of(context).size.width > 900;
    
    final String role = currentUser?.role ?? 'guest';

    return Scaffold(
      backgroundColor: contentColor,

      appBar: CustomAppBar(),

      endDrawer: !isDesktop ? _buildMobileDrawer(context) : null,

      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20,),

            KeyFiguresWidget(isAdmin: role == "admin"),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: isDesktop
                  ? _buildDesktopLayout(context)
                  : _buildMobileLayout(context),
            ),

            const Divider(height: 1, thickness: 1),

            JobOfferWidget(),

            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
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
                onAddPress: () => _showAddNewsDialog(context),
              ),
            ),

            const VerticalDivider(width: 60, thickness: 1, color: Colors.white),

            Expanded(
              flex: 1,
              child: EventWidget(
                onAddPress: () => _showAddEventDialog(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
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
            onAddPress: () => _showAddNewsDialog(context),
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
            onAddPress: () => _showAddEventDialog(context)
          ),
        ),
      ],
    );
  }

  Widget _buildMobileDrawer(BuildContext context) {
    final currentUser = sl<AuthService>().currentUser;
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
          ListTile(leading: const Icon(Icons.newspaper), title: const Text("Actualités"), onTap: () => _naviguer(context, NewsPage())),
          ListTile(leading: const Icon(Icons.people), title: const Text("Annuaire"), onTap: () => _naviguer(context, DirectoryPage())),
          ListTile(leading: const Icon(Icons.work), title: const Text("Offres"), onTap: () => _naviguer(context, JobPage())),
          ListTile(leading: const Icon(Icons.school), title: const Text("Site École"), onTap: _ouvrirSiteEcole),

          if ( currentUser != null && (currentUser.role== 'student' || currentUser.role == 'alumni')) ...[
            const Divider(),
            ListTile(leading: const Icon(Icons.event), title: const Text("Proposer un évènement"), onTap: () => _naviguer(context, ProposeEventPage())),
            if (currentUser.role == 'alumni') ...[
              ListTile(leading: const Icon(Icons.thumb_up), title: const Text("Rejoindre"), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => Scaffold(appBar: AppBar(title: const Text("Rejoindre"), backgroundColor: AppColors.ensiCyan), body: AddAlumniForm(onSuccess: () => Navigator.pop(c)))))),
            ],
          ],

          if (currentUser != null && currentUser.role == 'admin') ...[
            const Divider(),
            ListTile(leading: const Icon(Icons.security), title: const Text("Modération"), onTap: () => _naviguer(context, PageModeration())),
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

  void _showAddNewsDialog(BuildContext context) {
    final currentUser = sl<AuthService>().currentUser;
    if (currentUser == null) {
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

              await sl<AlumniRepository>().addNews({
                "titre": titleCtrl.text,
                "description": descCtrl.text,
                "image": imgCtrl.text,
                "auteur_id": currentUser.role,
              });

              Navigator.pop(ctx);

              Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => const HomePage()));
            },
            child: const Text("Publier"),
          ),
        ],
      ),
    );
  }

  void _showAddEventDialog(BuildContext context) {
    final titreCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final lieuCtrl = TextEditingController();
    final dateCtrl = TextEditingController();
    final currentUser = sl<AuthService>().currentUser;

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
                decoration: const InputDecoration(labelText: "Date et heure"),
                readOnly: true,
                onTap: () async {
                  FocusScope.of(context).requestFocus(FocusNode());

                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );

                  if (pickedDate != null) {
                    TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: const TimeOfDay(hour: 00, minute: 0),
                      builder: (BuildContext context, Widget? child) {
                        return MediaQuery(
                          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
                          child: child!,
                        );
                      },
                    );

                    if (pickedTime != null) {
                      String formattedDate = pickedDate.toIso8601String().split('T')[0];
                      String formattedHour = pickedTime.hour.toString().padLeft(2, '0');
                      String formattedMinute = pickedTime.minute.toString().padLeft(2, '0');

                      dateCtrl.text = "$formattedDate $formattedHour:$formattedMinute:00";
                    }
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

              await sl<AlumniRepository>().addEvent({
                "titre": titreCtrl.text,
                "description": descCtrl.text,
                "lieu": lieuCtrl.text,
                "date_event": dateCtrl.text,
                "auteur_id": currentUser?.id,
                "valide": 1
              });

              Navigator.pop(ctx);
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => const HomePage()));
            },
            child: const Text("Publier"),
          ),
        ],
      ),
    );
  }
}