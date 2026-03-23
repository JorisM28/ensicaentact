import 'package:flutter/material.dart';
import '/ViewModel/widget/profile_viewmodel.dart';
import '/View/screens/home_page.dart';
import '/View/theme/colors.dart';
import '/service_locator.dart';
import '/View/screens/auth/login.dart';
import '/View/screens/alumni/profile.dart';
import '/l10n/app_localizations.dart';

class ProfileBadge extends StatefulWidget {
  const ProfileBadge({super.key});

  @override
  State<ProfileBadge> createState() => _ProfileBadgeState();
}

class _ProfileBadgeState extends State<ProfileBadge> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final viewModel = sl<ProfileViewModel>();
    final traductions = AppLocalizations.of(context)!;


    if (viewModel.isGuest) {
      return MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const Login()),
            );
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
            width: _isHovered ? 135 : 40,
            height: 40,
            decoration: BoxDecoration(
              color: _isHovered ? AppColors.ensiCyan : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white, width: 1.5),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const NeverScrollableScrollPhysics(),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Icon(Icons.login, color: Colors.white, size: 20),
                    ),
                    if (_isHovered)
                      Padding(
                        padding: const EdgeInsets.only(right: 12.0),
                        child: Text(
                          traductions.loginBtn,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Theme(
      data: Theme.of(context).copyWith(
        popupMenuTheme: PopupMenuThemeData(
          color: Colors.white,
          elevation: 6,
          surfaceTintColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      child: PopupMenuButton(
        tooltip: "${traductions.accountOf} ${viewModel.firstName}",
        offset: const Offset(0, 55),
        constraints: const BoxConstraints(minWidth: 300, maxWidth: 300),


        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: _isHovered ? Colors.white.withOpacity(0.2) : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.white,
              child: CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.ensiCyan,
                child: Text(
                  viewModel.initial,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ),


        itemBuilder: (_) => [
          PopupMenuItem(
            enabled: false,
            padding: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const ProfilePage()),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
                          child: Text(
                            traductions.editProfile,
                            style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.ensiCyan,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          Navigator.pop(context);


                          await viewModel.logout();

                          if (mounted) {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (_) => const HomePage()),
                                  (route) => false,
                            );
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
                          child: Text(
                            traductions.profileLogout,
                            style: const TextStyle(fontSize: 12, color: Colors.black87),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 24),

                  CircleAvatar(
                    radius: 40,
                    backgroundColor: AppColors.ensiCyan,
                    child: Text(
                      viewModel.initial,
                      style: const TextStyle(fontSize: 32, color: Colors.white),
                    ),
                  ),

                  Text(
                    viewModel.role.toUpperCase(),
                    style: TextStyle(fontSize: 13, color: Colors.grey[600], fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 12),

                  Text(
                    "${viewModel.firstName} ${viewModel.lastName}",
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 4),

                  Text(
                    viewModel.email,
                    style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const ProfilePage()),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        side: BorderSide(color: Colors.grey.shade300),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                      child: Text(traductions.viewAccount, style: const TextStyle(color: Colors.black87)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}