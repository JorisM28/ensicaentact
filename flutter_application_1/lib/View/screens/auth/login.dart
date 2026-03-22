import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../Model/connection/i_auth_strategy.dart';
import '../../../ViewModel/auth_viewmodel.dart';
import '/l10n/app_localizations.dart';
import '/View/theme/colors.dart';
import '/View/screens/alumni/directory_page.dart';
import '/service_locator.dart';
import '/Model/connection/auth_strategy.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formkey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthViewModel _viewModel = sl<AuthViewModel>();

  bool _isPresentationMode = true;
  bool _isObscure = true;

  void _handleAuthResult(AuthResult result) {
    final traductions = AppLocalizations.of(context)!;

    if (result.isSuccess && result.user != null) {
      if (['admin', 'student', 'alumni'].contains(result.user!.role)) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => DirectoryPage()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(traductions.loginErrorConnection), backgroundColor: Colors.red)
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result.errorMessage ?? traductions.loginErrorUnknown), backgroundColor: Colors.red)
      );
    }
  }

  Future<void> _submitEmailLogin() async {
    if (!_formkey.currentState!.validate()) return;

    final result = await _viewModel.loginWithEmail(
        _emailController.text.trim(),
        _passwordController.text
    );

    if (mounted) {
      _handleAuthResult(result);
    }
  }

  Future<void> _submitMicrosoftLogin() async {
    final traductions = AppLocalizations.of(context)!;
    try {
      final result = await _viewModel.loginWithMicrosoft();
      if (mounted) {
        _handleAuthResult(result);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("${traductions.microsoftError} $e"), backgroundColor: Colors.red)
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        elevation: 0,
        actions: [
          Row(
            children: [
              Switch(
                value: _isPresentationMode,
                activeThumbColor: AppColors.ensiCyan,
                onChanged: (value) {
                  setState(() {
                    _isPresentationMode = value;
                  });
                },
              ),
              const SizedBox(width: 10),
            ],
          )
        ],
      ),
      backgroundColor: Colors.grey[100],
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.8),
                blurRadius: 20,
                offset: const Offset(0, 10),
              )
            ],
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: ListenableBuilder(
                listenable: _viewModel,
                builder: (context, _) {
                  return _buildLoginForm();
                }
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    final traductions = AppLocalizations.of(context)!;
    return Column(
      key: const ValueKey(1),
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset('assets/logo_alumni.png', height: 80),
        const SizedBox(height: 25),

        Form(
          key: _formkey,
          child: Column(
            children: [
              _buildTextField(
                Icons.email,
                traductions.emailLabel,
                controller: _emailController,
                textColor: AppColors.ensiCyan,
                validator: (value) {
                  if (value == null || value.isEmpty) return traductions.loginEmailRequired;
                  if (!value.contains('@')) return traductions.loginInvalidEmail;
                  return null;
                },
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 15),

              _buildTextField(
                Icons.key,
                traductions.loginPasswordLabel,
                isPassword: true,
                controller: _passwordController,
                textColor: AppColors.ensiCyan,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return traductions.loginPasswordRequired;
                  } else if (value.length < 6) {
                    return traductions.loginPasswordTooShort;
                  }
                  return null;
                },
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _submitEmailLogin(),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () async {
                      final Uri url = Uri.parse("https://monpasse.ensicaen.fr/?action=sendtoken");
                      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
                        throw Exception('Impossible de lancer $url');
                      }
                    },
                    child: Text(traductions.loginForgetPassword, style: const TextStyle(color: AppColors.ensiCyan)),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _viewModel.isLoading ? null : _submitEmailLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.ensiCyan,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _viewModel.isLoading && _isPresentationMode
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(traductions.loginSubmitButton, style: const TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ),
            ],
          ),
        ),

        if (!_isPresentationMode) ...[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Row(
              children: [
                const Expanded(child: Divider()),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(traductions.loginOrDivider, style: const TextStyle(color: Colors.grey))
                ),
                const Expanded(child: Divider()),
              ],
            ),
          ),

          SizedBox(
            width: double.infinity,
            height: 50,
            child: OutlinedButton.icon(
              onPressed: _viewModel.isLoading ? null : _submitMicrosoftLogin,
              icon: const Icon(Icons.window, color: Colors.white),
              label: Text(traductions.loginMicrosoftButton, style: const TextStyle(color: Colors.white)),
              style: OutlinedButton.styleFrom(
                backgroundColor: AppColors.microsoftCyan,
                foregroundColor: Colors.white,
                side: const BorderSide(color: Color.fromARGB(0, 224, 224, 224)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildTextField(IconData icon, String label, {
    bool isPassword = false,
    Color? textColor,
    TextEditingController? controller,
    String? Function(String?)? validator,
    TextInputAction? textInputAction,
    Function(String)? onSubmitted,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      obscureText: isPassword ? _isObscure : false,
      textInputAction: textInputAction,
      onFieldSubmitted: onSubmitted,
      style: TextStyle(color: textColor ?? Colors.black),
      cursorColor: textColor ?? Colors.black,
      cursorWidth: 1.5,
      cursorRadius: const Radius.circular(15.0),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: textColor),
        prefixIcon: Icon(icon, color: textColor),
        suffixIcon: isPassword
            ? IconButton(
          icon: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(opacity: animation, child: child);
            },
            child: Icon(
              _isObscure ? Icons.visibility_off : Icons.visibility,
              key: ValueKey<bool>(_isObscure),
              color: Colors.grey,
            ),
          ),
          onPressed: () {
            setState(() {
              _isObscure = !_isObscure;
            });
          },
        ): null,
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.grey, width: 1.0)
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: textColor ?? AppColors.ensiCyan, width: 2.0),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 1.0),
        ),
        filled: true,
        fillColor: Colors.grey[50],
      ),
    );
  }
}