import 'package:flutter/material.dart';
import 'colors.dart';
import 'login.dart';

class ProfilePage extends StatelessWidget {
  final Map<String, dynamic> user;

  const ProfilePage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    String prenom = user['name'] ?? "Utilisateur";
    String nom = user['family_name'] ?? "";
    String email = user['email'] ?? "";
    String role = user['role'] ?? "";
    String phone = user['phone'] ?? "";

    return Scaffold(
      appBar: AppBar(
        title: const Text("Mon Profil"),
        backgroundColor: AppColors.ensiCyan,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.ensiCyan, width: 4),
                ),
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: AppColors.ensiCyan.withOpacity(0.1),
                  child: Text(
                    prenom.isNotEmpty ? prenom[0].toUpperCase() : "?",
                    style: const TextStyle(fontSize: 40, color: AppColors.ensiCyan, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              Text(
                "$prenom $nom",
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const SizedBox(height: 5),

              Chip(
                label: Text(role.toUpperCase(), style: const TextStyle(fontSize: 12, color: Colors.white)),
                backgroundColor: role == 'admin' ? Colors.red : AppColors.ensiCyan,
              ),

              const SizedBox(height: 30),
              const Divider(),

              ListTile(
                leading: const Icon(Icons.email, color: AppColors.ensiCyan),
                title: const Text("Email"),
                subtitle: Text(email, style: const TextStyle(fontSize: 16)),
              ),

              if (phone.isNotEmpty) ...[
                const Divider(indent: 20, endIndent: 20),
                ListTile(
                  leading: const Icon(Icons.phone, color: AppColors.ensiCyan),
                  title: const Text("Téléphone"),
                  subtitle: Text(phone, style: const TextStyle(fontSize: 16)),
                ),
              ],

              const Divider(height: 40),
              const SizedBox(height: 20),

              SizedBox(
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const Login()),
                          (route) => false,
                    );
                  },
                  icon: const Icon(Icons.logout, color: Colors.white),
                  label: const Text("Se déconnecter", style: TextStyle(fontSize: 18, color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[400],
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}