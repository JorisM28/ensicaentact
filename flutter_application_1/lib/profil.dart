import 'package:flutter/material.dart';
import 'colors.dart';
import 'login.dart';

class ProfilPage extends StatelessWidget {
  final Map<String, dynamic> user;

  const ProfilPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    String prenom = user['prenom'] ?? "Guest";
    String nom = user['nom'] ?? "";
    String email = user['email'] ?? "Not specified";
    String role = user['role'] ?? "guest";

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Profil"),
        backgroundColor: AppColors.ensiCyan,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 50,
              backgroundColor: AppColors.ensiCyan,
              child: Text(
                prenom.isNotEmpty ? prenom[0].toUpperCase() : "?",
                style: const TextStyle(fontSize: 40, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "$prenom $nom",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Chip(
              label: Text(role.toUpperCase()),
              backgroundColor: Colors.grey[200],
            ),
            const Divider(height: 40),
            
            ListTile(
              leading: const Icon(Icons.email, color: AppColors.ensiCyan),
              title: const Text("Email"),
              subtitle: Text(email),
            ),
            
            const Spacer(),
            
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const Login()),
                    (route) => false,
                  );
                },
                icon: const Icon(Icons.logout),
                label: const Text("Log out"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}