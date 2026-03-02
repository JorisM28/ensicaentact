import 'package:flutter/material.dart';
import '/View/screens/employment/companies_directory_page.dart';
import '/View/screens/event/event_page.dart';
import '/View/screens/home_page.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Model/user_model.dart';
import '/View/theme/colors.dart';
import '/View/screens/event/news_page.dart';
import '/View/screens/alumni/directory_page.dart';
import '/View/screens/employment/job_page.dart';
import '/View/screens/admin/moderation_page.dart';
import '/View/screens/alumni/join_page.dart';
import '/View/widget/profil_badge.dart';
import 'event_proposition_widget.dart';
import '/Model/data/services/auth_service.dart';
import '/service_locator.dart';
import '/View/screens/auth/login.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {

  const CustomAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(80);

  Future<void> _openSchoolWebsite() async {
    final Uri url = Uri.parse('https://www.ensicaen.fr');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      debugPrint('Impossible de lancer $url');
    }
  }

  void _navigate(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (c) => page));
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = sl<AuthService>().currentUser;
    bool isDesktop = MediaQuery.of(context).size.width > 900;
    final String role = currentUser?.role?? 'visiteur';
    final bool isConnected = sl<AuthService>().isLoggedIn;

    return Container(
      color: AppColors.ensiCyan,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SafeArea(
        child: Row(
          children: [
            InkWell(
              onTap: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage())
                );
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset('assets/logo_alumni_1.png', height: 40),
                  const SizedBox(width: 10),
                  _buildBrandIdentity(),
                ],
              ),
            ),
            if (isDesktop) ...[
              const Spacer(),

              _buildMenuLink(context, "Accueil", () => _navigate(context, HomePage())),
              _buildMenuLink(context, "Actualités", () => _navigate(context, NewsPage())),
              _buildMenuLink(context, "Annuaire", () {Navigator.push(context,MaterialPageRoute(builder: (context) => isConnected ? DirectoryPage(): const Login(),),);}),
              _buildMenuLink(context, "Evènements", (){Navigator.push(context,MaterialPageRoute(builder: (context) => isConnected ? EventPage(): const Login(),),);}),
              _buildMenuLink(context, "Cartes", () => _navigate(context, CompaniesDirectoryPage())),
              _buildMenuLink(context, "Offres", () {Navigator.push(context,MaterialPageRoute(builder: (context) => isConnected ? JobPage(): const Login(),),);}),
              _buildMenuLink(context, "ENSICAEN", _openSchoolWebsite),



              const Spacer(),

              if (user.isAdmin) ...[
                _buildHeaderButton(Icons.admin_panel_settings, "Modération",
                        () => _navigate(context, PageModeration())),
              ],

              if (role == 'alumni' || role == 'student') ...[
                _buildHeaderButton(
                    Icons.event_available,
                    "Proposer évènement",
                        () => _navigate(context, ProposeEventPage())
                ),
                if (role == 'alumni') ...[
                  const SizedBox(width: 10),
                  _buildHeaderButton(
                      Icons.thumb_up_alt_outlined,
                      "Rejoindre",
                          () => _navigate(context, JoinPage())
                  ),
                ],
              ],

              const SizedBox(width: 5),
              ProfileBadge()
            ],
            if (!isDesktop) ...[
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.menu, color: Colors.white70, size: 30),
                onPressed: () => Scaffold.of(context).openEndDrawer(),
              ),
            ],
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
        Text("ENSICAEN", style: TextStyle(color: Colors.white70, fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
        Text("ALUMNI", style: TextStyle(color: Colors.white70, fontSize: 12, letterSpacing: 3.0)),
      ],
    );
  }

  Widget _buildHeaderButton(IconData icon, String label, VoidCallback action) {
    return ElevatedButton.icon(
      onPressed: action,
      icon: Icon(icon, size: 18, color: AppColors.ensiCyan),
      label: Text(label, style: TextStyle(color: AppColors.ensiCyan, fontWeight: FontWeight.bold)),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
    );
  }

  Widget _buildMenuLink(BuildContext context, String titre, VoidCallback action) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: TextButton(
        onPressed: action,
        child: Text(titre, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 17)),
      ),
    );
  }
}