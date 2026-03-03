import 'package:flutter/material.dart';
import '/Model/core/theme/colors.dart';
import '/View/screens/auth/login.dart';
import '/View/screens/alumni/profile.dart';
import 'package:flutter_application_ensicaentact/service_locator.dart';
import 'package:flutter_application_ensicaentact/Model/data/services/auth_service.dart';

class ProfileBadge extends StatefulWidget {
  final Map<String, dynamic>? user;

  const ProfileBadge({super.key, this.user});

  @override
  State<ProfileBadge> createState() => _ProfileBadgeState();
}

class _ProfileBadgeState extends State<ProfileBadge> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final String role = widget.user?['role'] ?? 'guest';
    final bool isGuest = widget.user == null || role == 'guest';

   if (isGuest) {
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
                      const Padding(
                        padding: EdgeInsets.only(right: 12.0),
                        child: Text(
                          "Se connecter",
                          style: TextStyle(
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




    final String lastName = widget.user?['family_name'] ?? "";
    final String firstName = widget.user?['name'] ?? "";
    final String email = widget.user?['email'] ?? "";
    final String initial = firstName.isNotEmpty ? firstName[0].toUpperCase() : "?";

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
        tooltip: "Compte de $firstName",
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
                  initial,
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
                            MaterialPageRoute(builder: (_) => ProfilePage(user: widget.user!)),
                          );
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
                          child: Text(
                            "Modifier le profil",
                            style: TextStyle(
                                fontSize: 12,
                                color: AppColors.ensiCyan,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      ),

                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (_) => const Login()),
                                (route) => false,
                          );
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
                          child: Text(
                            "Se déconnecter",
                            style: TextStyle(fontSize: 12, color: Colors.black87),
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
                      initial,
                      style: const TextStyle(fontSize: 32, color: Colors.white),
                    ),
                  ),
                  Text(role.toUpperCase(),
                        style: TextStyle(fontSize: 13, color: Colors.grey[600], fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,),

                  const SizedBox(height: 12),

                  Text(
                    "$firstName $lastName",
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 4),

                  Text(
                    email,
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
                          MaterialPageRoute(builder: (_) => ProfilePage(user: widget.user!)),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        side: BorderSide(color: Colors.grey.shade300),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                      child: const Text("Afficher le compte", style: TextStyle(color: Colors.black87)),
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