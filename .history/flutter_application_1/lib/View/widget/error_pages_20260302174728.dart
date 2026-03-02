import 'package:flutter/material.dart';
import '/View/screens/auth/login.dart';
import '/Model/core/theme/colors.dart';

class ErrorPage extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final VoidCallback? onRetry;

  const ErrorPage({
    super.key,
    this.title = "An Error Occurred",
    this.message = "Something went wrong. Please try again later.",
    this.icon = Icons.error_outline,
    this.onRetry,
  });

  factory ErrorPage.forbidden({VoidCallback? onRetry}) {
    return ErrorPage(
      title: "Access Denied (403)",
      message: "You do not have the required permissions to view this page.",
      icon: Icons.gpp_bad,
      onRetry: onRetry,
    );
  }

  factory ErrorPage.notFound({VoidCallback? onRetry}) {
    return ErrorPage(
      title: "Page Not Found (404)",
      message: "The page or data you are looking for does not exist.",
      icon: Icons.search_off,
      onRetry: onRetry,
    );
  }

  factory ErrorPage.networkError({VoidCallback? onRetry}) {
    return ErrorPage(
      title: "Network Error",
      message: "Unable to connect to the server. Please check your connection.",
      icon: Icons.wifi_off,
      onRetry: onRetry,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Error"),
        backgroundColor: Colors.red[800],
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 100, color: Colors.red[800]),
              const SizedBox(height: 20),
              Text(
                title,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                message,
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              if (onRetry != null)
                ElevatedButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh),
                  label: const Text("Recharger"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.ensiCyan,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
              const SizedBox(height: 10),
              ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Login()),
                );
              },
              child: const Text('Se connecter'),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Retour"),
              )
            ],
          ),
        ),
      ),
    );
  }
}