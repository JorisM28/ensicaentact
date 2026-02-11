import 'package:flutter/material.dart';
import 'package:flutter_application_ensicaentact/widget/event_proposition_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'page_emploi.dart';
import 'page_annuaire.dart'; 
import 'page_actualités.dart';
import 'colors.dart'; 
import 'widget/actuality_widget.dart';
import 'widget/event_widget.dart';
import 'widget/joboffert_widget.dart';
import 'profileBadge.dart';
import 'widget/key_figures_widget.dart';
import 'add_alumni.dart';
import'page_rejoindre.dart';

class PageAccueil extends StatelessWidget {
  final Map<String, dynamic> user;

  const PageAccueil({super.key, required this.user});

  final Color headerColor = AppColors.ensiCyan;
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
    

    return Scaffold(
      backgroundColor: contentColor,
      
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Container(
          color: headerColor,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SafeArea(
            child: Row(
              children: [
                Image.asset('assets/logo_alumni_1.png', height: 40), 
                const SizedBox(width: 10),
                
                _buildBrandIdentity(),

                if (isDesktop) ...[
                  const Spacer(),
                  _buildLienMenu(context, "Actualités", () => _naviguer(context, PageActualites(user: user))),
                  _buildLienMenu(context, "Annuaire", () => _naviguer(context, PageAnnuaire(user: user))),
                  _buildLienMenu(context, "Offres", () => _naviguer(context, PageEmploi(user: user))),
                  _buildLienMenu(context, "ENSICAEN", _ouvrirSiteEcole),

                  const SizedBox(width: 20), 


                  if (user['role'] == 'admin') ...[
                    _buildHeaderButton(Icons.admin_panel_settings, "Modération", 
                        () => _naviguer(context, PageModeration(user: user))),
                  ],


                  if (user['role'] == 'alumni') ...[
                    _buildHeaderButton(
                      Icons.thumb_up_alt_outlined, 
                      "Rejoindre", 
                      () => _naviguer(context, PageRejoindre(user: user))
                    ), 
                    const SizedBox(width: 10), 
                    _buildHeaderButton(
                      Icons.event_available, 
                      "Proposer évènement",
                      () => _naviguer(context, PageProposerEvenement(user: user))
                    ),
                  ],


                ],

                if (!isDesktop)
                  Builder(builder: (ctx) => IconButton(
                    icon: const Icon(Icons.menu, color: Colors.white, size: 30),
                    onPressed: () => Scaffold.of(ctx).openEndDrawer(),
                  )),
              ],
            ),
          ),
        ),
      ),

      endDrawer: !isDesktop ? _buildMobileDrawer(context) : null,

      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20,),
            KeyFiguresWidget(),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10), 
              child: isDesktop ? _buildDesktopLayout() : _buildMobileLayout(),
            ),

            const Divider(height: 1, thickness: 1),

            JobOfferWidget(user: user), 
 
            _buildFooter(),
          ],
        ),
      ),
    );
  }


  Widget _buildBrandIdentity() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text("ENSICAEN", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
        Text("ALUMNI", style: TextStyle(color: Colors.white70, fontSize: 12, letterSpacing: 3.0)),
      ],
    );
  }



  Widget _buildDesktopLayout() {
    return Row( 
      crossAxisAlignment: CrossAxisAlignment.start, 
      children: [
        Expanded(flex: 2, child: ActualityWidget(user: user)), 
        const SizedBox(width: 20), 
        Expanded(flex: 1, child: EventWidget(user: user)),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Column( 
      children: [
        ActualityWidget(user: user), 
        const SizedBox(height: 20),
        EventWidget(user: user),
      ],
    );
  }

  Widget _buildHeaderButton(IconData icon, String label, VoidCallback action) {
    return ElevatedButton.icon(
      onPressed: action,
      icon: Icon(icon, size: 18, color: headerColor),
      label: Text(label, style: TextStyle(color: headerColor, fontWeight: FontWeight.bold)),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
    );
  }

  Widget _buildLienMenu(BuildContext context, String titre, VoidCallback action) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: TextButton(
        onPressed: action,
        child: Text(titre, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildMobileDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: headerColor),
            child: const Center(child: Text("Menu Alumni", style: TextStyle(color: Colors.white, fontSize: 24))),
          ),
          ListTile(leading: const Icon(Icons.newspaper), title: const Text("Actualités"), onTap: () => _naviguer(context, PageActualites(user: user))),
          ListTile(leading: const Icon(Icons.people), title: const Text("Annuaire"), onTap: () => _naviguer(context, PageAnnuaire(user: user))),
          ListTile(leading: const Icon(Icons.work), title: const Text("Offres"), onTap: () => _naviguer(context, PageEmploi(user: user))),
          ListTile(leading: const Icon(Icons.school), title: const Text("Site École"), onTap: _ouvrirSiteEcole),
          const Divider(),
          ListTile(leading: const Icon(Icons.thumb_up), title: const Text("Rejoindre"), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => Scaffold(appBar: AppBar(title: const Text("Rejoindre"), backgroundColor: headerColor), body: AddAlumniForm(onSuccess: () => Navigator.pop(c)))))),
          ListTile(leading: const Icon(Icons.event), title: const Text("Proposer un évènement"), onTap: () => _naviguer(context, PageProposerEvenement(user: user))),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(20),
      color: Colors.grey[900],
      width: double.infinity,
      child: const Text("© 2026 ENSICAEN Alumni", style: TextStyle(color: Colors.white, fontSize: 12), textAlign: TextAlign.center),
    );
  }
}