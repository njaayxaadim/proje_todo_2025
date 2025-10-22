// lib/screens/login_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import 'register_screen.dart';
import 'home_screen.dart';

final loginLoadingProvider = StateProvider<bool>((ref) => false);

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(loginLoadingProvider);
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Connexion')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.task_alt, size: 80, color: Colors.blue),
            const SizedBox(height: 32),
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Mot de passe',
                prefixIcon: Icon(Icons.lock),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () => _login(context, ref, emailController.text.trim(),
                        passwordController.text),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Se connecter',
                        style: TextStyle(fontSize: 16)),
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const RegisterScreen())),
              child: const Text('Pas de compte ? S\'inscrire'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _login(BuildContext context, WidgetRef ref, String email,
      String password) async {
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Veuillez remplir tous les champs')));
      return;
    }

    ref.read(loginLoadingProvider.notifier).state = true;

    try {
      final success =
          await ref.read(authProvider.notifier).login(email, password);
      if (success && context.mounted) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const HomeScreen()));
      } else if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Email ou mot de passe incorrect')));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Erreur: $e')));
      }
    } finally {
      if (context.mounted) {
        ref.read(loginLoadingProvider.notifier).state = false;
      }
    }
  }
}
