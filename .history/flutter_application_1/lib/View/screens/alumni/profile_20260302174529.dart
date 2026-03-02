import 'package:flutter/material.dart';
import '/View/screens/home_page.dart';
import '/Model/core/theme/colors.dart';
import '/service_locator.dart';
import '/Model/data/services/alumni_repository.dart';
import '/Model/data/services/auth_service.dart';

class ProfilePage extends StatefulWidget {

  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  void _showChangePasswordDialog(BuildContext context) {
    final TextEditingController _oldPassController = TextEditingController();
    final TextEditingController _newPassController = TextEditingController();
    final TextEditingController _confirmPassController = TextEditingController();
    final _formKey = GlobalKey<FormState>();
    bool _isLoading = false;
    final currentUser = sl<AuthService>().currentUser;


    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Modifier le mot de passe"),
              content: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: _oldPassController,
                      obscureText: true,
                      decoration: const InputDecoration(labelText: "Ancien mot de passe"),
                      validator: (val) => val!.isEmpty ? "Requis" : null,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _newPassController,
                      obscureText: true,
                      decoration: const InputDecoration(labelText: "Nouveau mot de passe"),
                      validator: (val) => val!.length < 6 ? "Minimum 6 caractères" : null,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _confirmPassController,
                      obscureText: true,
                      decoration: const InputDecoration(labelText: "Confirmer nouveau"),
                      validator: (val) {
                        if (val != _newPassController.text) return "Les mots de passe ne correspondent pas";
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Annuler"),
                ),
                ElevatedButton(
                  onPressed: _isLoading ? null : () async {
                    if (_formKey.currentState!.validate()) {
                      setState(() => _isLoading = true);

                      try {
                          await sl<AlumniRepository>().updatePassword({
                            'email': currentUser!['email'],
                            'old_password': _oldPassController.text,
                            'new_password': _newPassController.text
                          });

                          setState(() => _isLoading = false);
                          Navigator.pop(context);

                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Mot de passe modifié avec succès"),
                                backgroundColor: Colors.green,
                              ),
                            );
                          }
                      } catch (e) {
                        setState(() => _isLoading = false);
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Erreur : Impossible de modifier le mot de passe"),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    }
                  },
                  child: _isLoading
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Text("Valider"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = sl<AuthService>().currentUser;

    String firstName =currentUser!['prenom'] ??currentUser['name'] ?? "Utilisateur";
    String lastName =currentUser['nom'] ??currentUser['family_name'] ?? "";
    String email =currentUser['email'] ?? "";
    String role =currentUser['role'] ?? "";
    String phone =currentUser['phone'] ?? "";


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
                    firstName.isNotEmpty ? firstName[0].toUpperCase() : "?",
                    style: const TextStyle(fontSize: 40, color: AppColors.ensiCyan, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              Text(
                "$firstName $lastName",
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

              const Divider(indent: 20, endIndent: 20),
              ListTile(
                leading: const Icon(Icons.lock_reset, color: AppColors.ensiCyan),
                title: const Text("Sécurité"),
                subtitle: const Text("Modifier mon mot de passe"),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () => _showChangePasswordDialog(context),
              ),

              const Divider(height: 40),
              const SizedBox(height: 20),

              SizedBox(
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const HomePage()),
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