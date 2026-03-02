import 'package:aad_oauth/aad_oauth.dart';
import 'package:aad_oauth/model/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_ensicaentact/View/screens/home_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../Model/connection/auth_strategy.dart';
import '../../../Model/connection/ensicaen_auth_adapter.dart';
import '../../../Model/connection/i_auth_strategy.dart';
import '../../../Model/connection/microsoft_auth_adapter.dart';
import '../../../Model/data/services/auth_service.dart';
import '../../navigation.dart';
import '../../theme/colors.dart';
import '../alumni/directory_page.dart';
import 'package:flutter_application_ensicaentact/service_locator.dart';
import '../../../Model/user_model.dart';


class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formkey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  MicrosoftAuthAdapter? _microsoftAdapter;

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
    if (!isMicrosoftConnection && !_formkey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    AuthResult result;
    final authRepo = sl<AuthRepository>();

    if (isMicrosoftConnection) {
      try {
        if (_microsoftAdapter == null) {
          final Config config = Config(
            tenant: dotenv.env['AZURE_TENANT_ID'] ?? "",
            clientId: dotenv.env['AZURE_CLIENT_ID'] ?? "",
            scope: "openid profile User.Read",
            redirectUri: dotenv.env['AZURE_REDIRECT_URI'] ?? "http://localhost:39019/redirect.html",
            navigatorKey: navigatorKey,
            webUseRedirect: false,
          );
          _microsoftAdapter = MicrosoftAuthAdapter(AadOAuth(config));
        }

        authRepo.setStrategy(_microsoftAdapter!);
        result = await authRepo.login();
      } catch (e) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Erreur Microsoft : $e"), backgroundColor: Colors.red));
        return;
      }
    } else {
      authRepo.setStrategy(EnsiCaenAuthAdapter());
      result = await authRepo.login(
          email: _emailController.text.trim(),
          password: _passwordController.text
      );
    }

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (result.isSuccess && result.user != null) {
      final user = result.user!;

      if (user.role == 'admin' || user.role == 'student' || user.role == 'alumni') {
        String tokenToSave = result.token ?? 'microsoft_session_token';
        await sl<AuthService>().saveSession(user, tokenToSave);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => DirectoryPage(user: user)));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Connexion Impossible !"), backgroundColor: Colors.red));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result.errorMessage ?? "Erreur inconnue"), backgroundColor: Colors.red),
      );
    }
  }


}