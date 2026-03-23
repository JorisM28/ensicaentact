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
import '/l10n/app_localizations.dart'; 
import '/Model/data/services/auth_service.dart';
import '/View/widget/base_layout.dart';
import '/ViewModel/home/home_viewmodel.dart';

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
    bool isDesktop = MediaQuery
        .of(context)
        .size
        .width > 900;
    final traductions = AppLocalizations.of(context)!;
    final String role = currentUser?.role ?? 'guest';

  return BaseLayout(
    body: SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20,),

            KeyFiguresWidget(isAdmin: role == "admin"),

            Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 10),
                child: isDesktop
                    ? _buildDesktopLayout(context)
                    : _buildMobileLayout(context, traductions)
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
    final traductions = AppLocalizations.of(context)!;
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4)),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 2,
              child: ActualityWidget(
                onAddPress: () => showAddNewsDialog(context, traductions),
              ),
            ),

            const VerticalDivider(width: 60, thickness: 1, color: Colors.white),

            Expanded(
              flex: 1,
              child: EventWidget(
                onAddPress: () => showAddEventDialog(context, traductions),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context, traductions) {
    return Column(
      children: [
        Container(
          height: 520,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)
            ],
          ),
          padding: const EdgeInsets.all(15),
          child: ActualityWidget(
            onAddPress: () => showAddNewsDialog(context, traductions),
          ),
        ),

        const SizedBox(height: 20),

        Container(
          height: 520,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)
            ],
          ),
          padding: const EdgeInsets.all(15),
          child: EventWidget(
              onAddPress: () => showAddEventDialog(context, traductions)
          ),
        ),
      ],
    );
  }

  Widget _buildMobileDrawer(BuildContext context,
      AppLocalizations traductions) {
    final currentUser = sl<AuthService>().currentUser;
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(color: AppColors.ensiCyan),
            padding: EdgeInsets.only(
              top: MediaQuery
                  .of(context)
                  .padding
                  .top + 20,
              bottom: 20,
            ),
            child: Center(
              child: Text(
                  traductions.drawerMenu,
                  style: const TextStyle(color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold)
              ),
            ),
          ),

          ListTile(leading: const Icon(Icons.people),
              title: Text(traductions.drawerDirectory),
              onTap: () => _naviguer(context, DirectoryPage())),
          ListTile(leading: const Icon(Icons.work),
              title: Text(traductions.drawerOffers),
              onTap: () => _naviguer(context, JobPage())),
          ListTile(leading: const Icon(Icons.school),
              title: Text(traductions.drawerSchoolSite),
              onTap: _ouvrirSiteEcole),
          ListTile(leading: const Icon(Icons.newspaper),
              title: Text(traductions.drawerNews),
              onTap: () => _naviguer(context, NewsPage())),
          if ( currentUser != null && (currentUser.role == 'student' ||
              currentUser.role == 'alumni')) ...[
            const Divider(),
            ListTile(leading: const Icon(Icons.event),
                title: Text(traductions.drawerProposeEvent),
                onTap: () => _naviguer(context, ProposeEventPage())),
            if (currentUser.role == 'alumni') ...[
              ListTile(leading: const Icon(Icons.thumb_up),
                  title: Text(traductions.drawerJoin),
                  onTap: () =>
                      Navigator.push(context, MaterialPageRoute(
                      builder: (c) =>
                          Scaffold(appBar: AppBar(title: Text(
                              traductions.drawerJoin),
                              backgroundColor: AppColors.ensiCyan),
                              body: AddAlumniForm(onSuccess: () =>
                                  Navigator.pop(c)))))),
            ],
          ],

          if (currentUser != null && currentUser.role == 'admin') ...[
            const Divider(),
            ListTile(leading: const Icon(Icons.security),
                title: Text(traductions.drawerModeration),
                onTap: () => _naviguer(context, PageModeration())),
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
      child: const Text("©2026 ENSICAEN Alumni",
          style: TextStyle(color: Colors.white, fontSize: 18),
          textAlign: TextAlign.center),
    );
  }


}