import 'package:flutter/material.dart';
import 'package:flutter_application_ensicaentact/View/screens/employment/companies_directory_page.dart';
import 'package:flutter_application_ensicaentact/View/screens/event/event_page.dart';
import 'package:flutter_application_ensicaentact/View/screens/home_page.dart';
import 'package:url_launcher/url_launcher.dart';
import '/Model/core/theme/colors.dart';
import '/View/screens/event/news_page.dart';
import '/View/screens/alumni/directory_page.dart';
import '/View/screens/employment/job_page.dart';
import '/View/screens/admin/moderation_page.dart';
import '/View/screens/alumni/join_page.dart';
import '/View/widget/profil_badge.dart';
import 'event_proposition_widget.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Map<String, dynamic>? user;

  const CustomAppBar({super.key, this.user});

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
    bool isDesktop = MediaQuery.of(context).size.width > 900;
    final String role = user?['role'] ?? 'visiteur';
    final Map<String, dynamic> currentUser = user ?? {};

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
                    MaterialPageRoute(builder: (context) => HomePage(user: currentUser,))
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
              _buildMenuLink(context, "Accueil", () => _navigate(context, HomePage(user: currentUser))),
              _buildMenuLink(context, "Actualités", () => _navigate(context, NewsPage(user: currentUser))),
              _buildMenuLink(context, "Annuaire", () => _navigate(context, DirectoryPage(user: currentUser))),
              _buildMenuLink(context, "Evènements", () => _navigate(context, EventPage(user: currentUser))),
              _buildMenuLink(context, "Cartes des entreprises", () => _navigate(context, CompaniesDirectoryPage(user: currentUser))),
              _buildMenuLink(context, "Offres", () => _navigate(context, JobPage(user: currentUser))),
              _buildMenuLink(context, "ENSICAEN", _openSchoolWebsite),
              const Spacer(),

              if (role == 'admin') ...[
                _buildHeaderButton(Icons.admin_panel_settings, "Modération",
                        () => _navigate(context, PageModeration(user: user!))),
              ],

              if (role == 'alumni' || role == 'student') ...[
                _buildHeaderButton(
                    Icons.event_available,
                    "Proposer évènement",
                        () => _navigate(context, ProposeEventPage(user: user!))
                ),
                if (role == 'alumni') ...[
                  const SizedBox(width: 10),
                  _buildHeaderButton(
                      Icons.thumb_up_alt_outlined,
                      "Rejoindre",
                          () => _navigate(context, JoinPage(user: user!))
                  ),
                ],
              ],

              const SizedBox(width: 5),
              ProfileBadge(user: user)
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