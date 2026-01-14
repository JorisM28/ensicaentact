import 'package:flutter/material.dart';
import 'colors.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formkey = GlobalKey<FormState>();
  bool isForgotPassword = false; // État pour afficher la récupération

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              _buildTextField(Icons.email, "Email"),
              const SizedBox(height: 15),
              _buildTextField(Icons.key, "Password", isPassword: true),
              Padding(
                padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => setState(() => isForgotPassword = true),
                    child: const Text("Forget Password?"),
                  ),
                ),
              ),
              
              const SizedBox(height: 10),
              
              // BOUTON LOGIN
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () => _formkey.currentState!.validate(),
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
            onPressed: () { /* Logique Microsoft Connect */ },
            icon: const Icon(Icons.window, color: AppColors.ensiCyan),
            label: const Text("Connect with Microsoft 365", style: TextStyle(color: Colors.black87)),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.grey[300]!),
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
        const Text("Recovery", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 15),
        const Text("Enter your email to reset your password", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
        const SizedBox(height: 25),
        _buildTextField(Icons.email, "Recovery Email"),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: () => setState(() => isForgotPassword = false),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.ensiCyan),
            child: const Text("SEND RESET LINK", style: TextStyle(color: Colors.white)),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: TextButton(
            onPressed: () => setState(() => isForgotPassword = false),
            child: const Text("Back to Login"),
          ),
        )
      ],
    );
  }

  Widget _buildTextField(IconData icon, String label, {bool isPassword = false}) {
    return TextFormField(
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.ensiCyan),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.grey[50],
      ),
    );
  }
}