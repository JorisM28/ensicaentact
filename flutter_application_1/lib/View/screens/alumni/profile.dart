import 'package:flutter/material.dart';
import '/ViewModel/widget/profile_viewmodel.dart';
import '/service_locator.dart';
import '/l10n/app_localizations.dart';
import '/View/screens/home_page.dart';
import '/View/theme/colors.dart';
import '/Model/data/services/auth_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ProfileViewModel _viewModel = sl<ProfileViewModel>();

  void _showChangePasswordDialog(BuildContext context) {
    final traductions = AppLocalizations.of(context)!;
    final currentUser = sl<AuthService>().currentUser!;
    final TextEditingController oldPassController = TextEditingController();
    final TextEditingController newPassController = TextEditingController();
    final TextEditingController confirmPassController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (contextDialog) {
        return AlertDialog(
          title: Text(traductions.modifyPassword),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: oldPassController,
                  obscureText: true,
                  decoration: InputDecoration(labelText: traductions.lastPassword),
                  validator: (val) => val!.isEmpty ? traductions.required : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: newPassController,
                  obscureText: true,
                  decoration: InputDecoration(labelText: traductions.newPassword),
                  validator: (val) => val!.length < 6 ? traductions.minCharacters : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: confirmPassController,
                  obscureText: true,
                  decoration: InputDecoration(labelText: traductions.confirmNewPassword),
                  validator: (val) {
                    if (val != newPassController.text) return traductions.passwordsDoNotMatch;
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(contextDialog),
              child: Text(traductions.cancel),
            ),
            ListenableBuilder(
                listenable: _viewModel,
                builder: (context, _) {
                  return ElevatedButton(
                    onPressed: _viewModel.isLoading ? null : () async {
                      if (formKey.currentState!.validate()) {
                        bool success = await _viewModel.changePassword(
                          currentUser.email,
                          oldPassController.text,
                          newPassController.text,
                        );

                        if (mounted) {
                          Navigator.pop(contextDialog);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(success ? traductions.passwordChangedSuccess : traductions.passwordChangedError),
                              backgroundColor: success ? Colors.green : Colors.red,
                            ),
                          );
                        }
                      }
                    },
                    child: _viewModel.isLoading
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                        : Text(traductions.validate),
                  );
                }
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = sl<AuthService>().currentUser;
    final traductions = AppLocalizations.of(context)!;
    String firstName = currentUser!.firstname;
    String lastName = currentUser.lastname;
    String email = currentUser.email;
    String role = currentUser.role;
    String phone = currentUser.phone;

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
                  onPressed: () async {
                    await _viewModel.logout();
                    if (mounted) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const HomePage()),
                            (route) => false,
                      );
                    }
                  },
                  icon: const Icon(Icons.logout, color: Colors.white),
                  label: Text(traductions.profileLogout, style: const TextStyle(fontSize: 18, color: Colors.white)),
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