import 'package:flutter/material.dart';
import '../../../Model/core/theme/colors.dart';
import '../auth/login.dart';
import '../../../service_locator.dart';
import '../../../Model/data/services/alumni_repository.dart';
import '../../../l10n/app_localizations.dart'; 

class ProfilePage extends StatefulWidget {
  final Map<String, dynamic> user;

  const ProfilePage({super.key, required this.user});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  void _showChangePasswordDialog(BuildContext context) {
    final traductions = AppLocalizations.of(context)!;
    final TextEditingController _oldPassController = TextEditingController();
    final TextEditingController _newPassController = TextEditingController();
    final TextEditingController _confirmPassController = TextEditingController();
    final _formKey = GlobalKey<FormState>();
    bool _isLoading = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(traductions.modifyPassword),
              content: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: _oldPassController,
                      obscureText: true,
                      decoration: InputDecoration(labelText: traductions.lastPassword),
                      validator: (val) => val!.isEmpty ? traductions.required : null,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _newPassController,
                      obscureText: true,
                      decoration: InputDecoration(labelText: traductions.newPassword),
                      validator: (val) => val!.length < 6 ? traductions.minCharacters : null,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _confirmPassController,
                      obscureText: true,
                      decoration: InputDecoration(labelText: traductions.confirmNewPassword),
                      validator: (val) {
                        if (val != _newPassController.text) return traductions.passwordsDoNotMatch;
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(traductions.cancel),
                ),
                ElevatedButton(
                  onPressed: _isLoading ? null : () async {
                    if (_formKey.currentState!.validate()) {
                      setState(() => _isLoading = true);

                      try {
                          await sl<AlumniRepository>().updatePassword({
                            'email': widget.user['email'],
                            'old_password': _oldPassController.text,
                            'new_password': _newPassController.text
                          });

                          setState(() => _isLoading = false);
                          Navigator.pop(context);

                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(traductions.passwordChangedSuccess),
                                backgroundColor: Colors.green,
                              ),
                            );
                          }
                      } catch (e) {
                        setState(() => _isLoading = false);
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(traductions.passwordChangedError),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    }
                  },
                  child: _isLoading
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                      : Text(traductions.validate),
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
    final traductions = AppLocalizations.of(context)!;
    String firstName = widget.user['prenom'] ?? widget.user['name'] ?? "Utilisateur";
    String lastName = widget.user['nom'] ?? widget.user['family_name'] ?? "";
    String email = widget.user['email'] ?? "";
    String role = widget.user['role'] ?? "";
    String phone = widget.user['phone'] ?? "";


    return Scaffold(
      appBar: AppBar(
        title: Text(traductions.profileTitle),
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
                title: Text(traductions.profileEmail),
                subtitle: Text(email, style: const TextStyle(fontSize: 16)),
              ),

              if (phone.isNotEmpty) ...[
                const Divider(indent: 20, endIndent: 20),
                ListTile(
                  leading: const Icon(Icons.phone, color: AppColors.ensiCyan),
                  title: Text(traductions.profilePhone),
                  subtitle: Text(phone, style: const TextStyle(fontSize: 16)),
                ),
              ],

              const Divider(indent: 20, endIndent: 20),
              ListTile(
                leading: const Icon(Icons.lock_reset, color: AppColors.ensiCyan),
                title: Text(traductions.profileSecurity),
                subtitle: Text(traductions.modifyPassword),
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
                      MaterialPageRoute(builder: (context) => const Login()),
                          (route) => false,
                    );
                  },
                  icon: const Icon(Icons.logout, color: Colors.white),
                  label: Text(traductions.profileLogout, style: TextStyle(fontSize: 18, color: Colors.white)),
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