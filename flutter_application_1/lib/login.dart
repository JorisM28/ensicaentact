import 'package:flutter/material.dart';
import 'colors.dart';
import 'login_check.dart';
import 'admin_page.dart';
import 'research.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formkey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool isForgotPassword = false;
  bool _isLoading = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.grey[100],),
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
            child: isForgotPassword ? _buildRecoveryForm() : _buildLoginForm(),
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
              ),
              const SizedBox(height: 15),

              _buildTextField(
                Icons.key,
                "Password",
                isPassword: true,
                controller: _passwordController,
                textColor: AppColors.ensiCyan,
                validator: (value) {
                  if (value == null || value.length < 6) {
                    return "Password too short";
                  }
                  return null;
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => setState(() => isForgotPassword = true),
                    child: const Text("Forget Password ?", style : TextStyle(color: AppColors.ensiCyan,),),
                  ),
                ),
              ),
              
              const SizedBox(height: 10),
              
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : () async {
                    setState(() => _isLoading = true);
                    final connection = await EnsiCaenConnection().signIn(_emailController.text.trim(), _passwordController.text);

                    if (connection['status'] == 'success') {
                      if (!mounted) {
                        return;
                      }
                      
                      String role = connection['role'];
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Bienvenue ! Mode : $role")),
                      );

                      if (role == 'admin') {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => AdminPage()));
                      } else {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => PageAnnuaire()));
                      }

                    } else {
                      if (!mounted) {
                        return;
                      }  
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(connection['message'] ?? "Erreur inconnue"),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                    setState(() => _isLoading = false);
                  },
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
            onPressed: _isLoading ? null : () async { 
              setState(() => _isLoading = true);
              final connection = MicrosoftConnection();
              final userData = await connection.signIn();
              setState(() => _isLoading = false);

              if (userData != null && userData['status'] == 'success') {
                String name = userData['name']!;
                String role = userData['role']!;
                if (mounted) {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: ((_) => PageAnnuaire())));
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Welcome $name, $role"),));
                } else {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Failed or abort connection..."),));
                  }
                }
                String email = userData['email']!;               
              }
            },

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
    );
  }

  // --- FORMULAIRE DE RÉCUPÉRATION ---
  Widget _buildRecoveryForm() {
    return Column(
      key: const ValueKey(2),
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          "Recovery", 
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)
        ),
        
        const SizedBox(height: 15),
        
        const Text(
          "Enter your email to reset your password", 
          textAlign: TextAlign.center, 
          style: TextStyle(color: Colors.grey, fontSize: 15),
        ),
        
        const SizedBox(height: 30),
        
        _buildTextField(
          Icons.email, 
          "Recovery Email", 
          textColor: AppColors.ensiCyan
        ),
        
        const SizedBox(height: 25),
        
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: () {
              setState(() => isForgotPassword = false);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.ensiCyan,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 2,
            ),
            child: const Text(
              "Send Reset Link", 
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)
            ),
          ),
        ),
        
        const SizedBox(height: 10),
        
        Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: TextButton(
            onPressed: () => setState(() => isForgotPassword = false),
            style: TextButton.styleFrom(
              foregroundColor: Colors.grey[600],
            ),
            child: const Text(
              "Back to Login",
              style: TextStyle(decoration: TextDecoration.underline),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildTextField(IconData icon, String label, {bool isPassword = false, Color? textColor, 
  TextEditingController? controller, String? Function(String?)? validator,}) {
    return TextFormField(
      controller: controller,
      validator: validator,
      obscureText: isPassword,
      style: TextStyle(color: textColor ?? Colors.black),
      cursorColor: textColor ?? Colors.black,
      cursorWidth: 1.5,
      cursorRadius: const Radius.circular(15.0),

      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: textColor),
        prefixIcon: Icon(icon, color: textColor),

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
}