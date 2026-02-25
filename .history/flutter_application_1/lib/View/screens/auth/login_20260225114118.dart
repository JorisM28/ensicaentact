import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../Model/core/theme/colors.dart';
import '../../../ViewModel/admin/login_check.dart';
import '../alumni/directory_page.dart';
import 'package:flutter_application_ensicaentact/service_locator.dart';
import 'package:flutter_application_ensicaentact/Model/data/services/auth_service.dart';


class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formkey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isPresentationMode = true;
  bool _isLoading = false;
  bool _isObscure = true;

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
            child: _buildLoginForm(),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
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
                "Email",
                controller: _emailController,
                textColor: AppColors.ensiCyan,
                validator: (value) {
                  if (value == null || value.isEmpty) return "Email required";
                  if (!value.contains('@')) return "Invalid email";
                  return null;
                },
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 15),

              _buildTextField(
                Icons.key,
                "Password",
                isPassword: true,
                controller: _passwordController,
                textColor: AppColors.ensiCyan,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Enter a password";
                  } else if (value.length < 6) {
                    return "Password too short";
                  }
                  return null;
                },
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _submitLogin(),
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
                    child: const Text("Forget Password ?", style : TextStyle(color: AppColors.ensiCyan,),),
                  ),
                ),
              ),
              
              const SizedBox(height: 10),
              
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : () => _submitLogin(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.ensiCyan,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text("LOGIN", style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ),
            ],
          ),
        ),

        if (!_isPresentationMode) ...[
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Row(
              children: [
                Expanded(child: Divider()),
                Padding(padding: EdgeInsets.symmetric(horizontal: 10), child: Text("OR", style: TextStyle(color: Colors.grey))),
                Expanded(child: Divider()),
              ],
            ),
          ),

          SizedBox(
            width: double.infinity,
            height: 50,
            child: OutlinedButton.icon(
              onPressed: _isLoading ? null : () => _submitLogin(isMicrosoftConnection: true),
              icon: const Icon(Icons.window, color: Colors.white),
              label: const Text("Connect with Microsoft 365", style: TextStyle(color:  Colors.white)),
              style: OutlinedButton.styleFrom(
                backgroundColor: AppColors.microsoftCyan,
                foregroundColor: Colors.white,
                side: BorderSide(color: const Color.fromARGB(0, 224, 224, 224)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildTextField(IconData icon, String label, {
    bool isPassword = false, Color? textColor,
    TextEditingController? controller,
    String? Function(String?)? validator,
    TextInputAction? textInputAction,
    Function(String)? onSubmitted,}) {
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
          borderSide: const BorderSide(
            color: Colors.grey,
            width: 1.0,
          )
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: textColor ?? AppColors.ensiCyan,
            width: 2.0,
          ),
        ),

        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 1.0,
          ),
        ),

        filled: true,
        fillColor: Colors.grey[50],
      ),
    );
  }

  void _submitLogin({bool isMicrosoftConnection = false}) async {
    if (_isLoading) return;

    Map<String, dynamic>? userData;
    if (isMicrosoftConnection) {
      setState(() => _isLoading = true);
      userData = await MicrosoftConnection().signIn();
    } else {
      if (_formkey.currentState!.validate()) {
        setState(() => _isLoading = true);
        userData = await EnsiCaenConnection().signIn(
            _emailController.text.trim(),
            _passwordController.text
        );
      } else {
        return;
      }
    }

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (userData == null) return;

    if (userData['status'] == 'success') {
      String role = userData['role'] ?? 'guest';

      if (role == 'admin' || role == 'student' || role == 'alumni') {
        String token = userData['token'] ?? 'microsoft_session_token';
        await sl<AuthService>().saveSession(userData, token);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => DirectoryPage(user: userData!)));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Connexion Impossible !"), backgroundColor: Colors.red));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(userData['message'] ?? "Erreur inconnue"), backgroundColor: Colors.red),
      );
    }
  }
}