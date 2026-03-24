import 'package:flutter/material.dart';
import '/View/screens/alumni/join_page.dart';
import '/View/screens/event/event_page.dart';
import '/View/screens/employment/companies_directory_page.dart';
import 'package:url_launcher/url_launcher.dart';
import '/View/screens/employment/job_page.dart';
import '/View/screens/alumni/directory_page.dart';
import '/View/screens/event/news_page.dart';
import '/View/screens/admin/moderation_page.dart';
import '/View/theme/colors.dart';
import '/View/widget/event_proposition_widget.dart';
import '/service_locator.dart';
import '/l10n/app_localizations.dart'; 
import '/Model/data/services/auth_service.dart';
import '/View/widget/language_switcher.dart';
import '/View/widget/profil_badge.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  Future<void> _ouvrirSiteEcole() async {
    final Uri url = Uri.parse('https://www.ensicaen.fr');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      debugPrint('Impossible de lancer $url');
    }
  }

  void _naviguer(BuildContext context, Widget page) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => page));
  }

  @override
  Widget build(BuildContext context) {
    final traductions = AppLocalizations.of(context)!;
    final currentUser = sl<AuthService>().currentUser;
    final bool isConnected = sl<AuthService>().isLoggedIn; 

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(color: AppColors.ensiCyan),
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 20,
              bottom: 20,
            ),
            child: Center(
              child: Text(
                  traductions.drawerMenu,
                  style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)
              ),
            ),
          ),
          if (isConnected)
            ListTile(leading: const Icon(Icons.people), title: Text(traductions.drawerDirectory), onTap: () => _naviguer(context, DirectoryPage())),
          
          if (isConnected)
            ListTile(leading: const Icon(Icons.map), title: Text(traductions.drawerMap), onTap: () => _naviguer(context, CompaniesDirectoryPage())),
          
          if (isConnected)
            ListTile(leading: const Icon(Icons.work), title: Text(traductions.drawerOffers), onTap: () => _naviguer(context, JobPage())),

          ListTile(leading: const Icon(Icons.newspaper), title: Text(traductions.drawerNews), onTap: () => _naviguer(context, NewsPage())), 
          
          if (isConnected)
          ListTile(leading: const Icon(Icons.event), title: Text(traductions.eventsTab), onTap: () => _naviguer(context, EventPage())), 

          ListTile(leading: const Icon(Icons.school), title: Text(traductions.drawerSchoolSite), onTap: _ouvrirSiteEcole),
          
          if ( currentUser != null && (currentUser.role== 'student' || currentUser.role == 'alumni')) ...[
            const Divider(),
            ListTile(leading: const Icon(Icons.event_note), title: Text(traductions.drawerProposeEvent), onTap: () => _naviguer(context, ProposeEventPage())),
          ],
          if (!isConnected) ...[
              ListTile(leading: const Icon(Icons.thumb_up), title: Text(traductions.drawerJoin), onTap: () => _naviguer(context, JoinPage())),
            ],

          if (currentUser != null && currentUser.role == 'admin') ...[
            const Divider(),
            ListTile(leading: const Icon(Icons.security), title: Text(traductions.drawerModeration), onTap: () => _naviguer(context, PageModeration())),
          ],
          
          Container(
            color: AppColors.ensiCyan,
            child: Column(
              children: [
                const SizedBox(height: 10),
                const LanguageSwitcher(), 
                const Divider(color: Colors.white54),
                ProfileBadge(),
                const SizedBox(height: 10),
              ],
            ),
          )
        ],
      ),
    );
  }
}