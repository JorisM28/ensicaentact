import 'package:flutter/material.dart';
import 'colors.dart';
import 'login.dart';
import 'profile.dart';

class ProfileBadge extends StatefulWidget {
  final Map<String, dynamic> user;

  const ProfileBadge({super.key, required this.user});

  @override
  State<ProfileBadge> createState() => _ProfileBadgeState();
}

class _ProfileBadgeState extends State<ProfileBadge> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    // LOGIQUE INVITÉ
    String role = widget.user['role'] ?? 'guest';
    bool isGuest = role == 'guest';

    if (isGuest) {
      return MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Login())
            );
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 275),
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
                      const Text(
                        "Connexion",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13
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

    // LOGIQUE CONNECTÉ
    String nom = widget.user['family_name'] ?? "";
    String prenom = widget.user['name'] ?? "";
    String email = widget.user['email'] ?? "";
    String initiale = prenom.isNotEmpty ? prenom[0].toUpperCase() : "";

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfilePage(user: widget.user))
          );
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          width: _isHovered ? 220 : 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              if (_isHovered)
                BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4)
                )
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Avatar fixe à gauche
                SizedBox(
                  width: 50,
                  height: 50,
                  child: Center(
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: AppColors.ensiCyan,
                      child: Text(
                        initiale,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),

                if (_isHovered)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 15.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "$prenom $nom",
                            style: const TextStyle(
                                color: AppColors.ensiCyan,
                                fontWeight: FontWeight.bold,
                                fontSize: 12
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          Text(
                            email,
                            style: TextStyle(color: Colors.grey[600], fontSize: 10),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          Text(
                            role.toUpperCase(),
                            style: const TextStyle(color: Colors.orange, fontSize: 8, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}