import 'package:flutter/material.dart';
import 'colors.dart';
import 'login.dart';
import 'profil.dart';

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
            width: _isHovered ? 125 : 40, 
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20), 
              border: Border.all(color: Colors.white, width: 1.5),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.login, color: Colors.white, size: 20),
                  if (_isHovered) ...[
                    const SizedBox(width: 8),
                    const Text(
                      "Se connecter", 
                      style: TextStyle(
                        color: Colors.white, 
                        fontWeight: FontWeight.bold,
                        fontSize: 13
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      );
    }

    // LOGIQUE CONNECTÉ
    String nom = widget.user['nom'] ?? "";
    String prenom = widget.user['prenom'] ?? "";
    String email = widget.user['email'] ?? "";
    
    String initiale = prenom.isNotEmpty ? prenom[0].toUpperCase() : "?";

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context, 
            MaterialPageRoute(builder: (context) => ProfilPage(user: widget.user))
          );
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.all(5),
          width: _isHovered ? 280 : 120, 
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
          child: Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.ensiCyan,
                child: Text(
                  initiale,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 10),
              
              Expanded(
                child: _isHovered
                    ? Column( 
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
                          ),
                          Text(
                            email,
                            style: TextStyle(color: Colors.grey[600], fontSize: 10),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            role.toUpperCase(),
                            style: const TextStyle(color: Colors.orange, fontSize: 8, fontWeight: FontWeight.bold),
                          ),
                        ],
                      )
                    : Text( 
                        nom,
                        style: const TextStyle(
                          color: AppColors.ensiCyan, 
                          fontWeight: FontWeight.bold, 
                          fontSize: 14
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}