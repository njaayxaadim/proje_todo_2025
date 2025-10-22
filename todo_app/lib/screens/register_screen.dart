// lib/screens/register_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import 'login_screen.dart';

final registerLoadingProvider = StateProvider<bool>((ref) => false);

class RegisterScreen extends ConsumerWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(registerLoadingProvider);
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final confirmController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Inscription')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.person_add, size: 80, color: Colors.green),
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
              const SizedBox(height: 16),
              TextField(
                controller: confirmController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Confirmer mot de passe',
                  prefixIcon: Icon(Icons.lock_outline),
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
                      : () => _register(
                            context,
                            ref,
                            emailController.text.trim(),
                            passwordController.text,
                            confirmController.text,
                          ),
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('S\'inscrire',
                          style: TextStyle(fontSize: 16)),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (_) => const LoginScreen())),
                child: const Text('Déjà un compte ? Se connecter'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _register(BuildContext context, WidgetRef ref, String email,
      String password, String confirm) async {
    if (email.isEmpty || password.isEmpty || confirm.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Veuillez remplir tous les champs')));
      return;
    }
    if (password != confirm) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Les mots de passe ne correspondent pas')));
      return;
    }
    if (password.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content:
              Text('Le mot de passe doit contenir au moins 2 caractères')));
      return;
    }

    ref.read(registerLoadingProvider.notifier).state = true;

    try {
      final success =
          await ref.read(authProvider.notifier).register(email, password);
      if (success && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Inscription réussie !')));
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const LoginScreen()));
      } else if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content:
                Text('Erreur d\'inscription - Email peut-être déjà utilisé')));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Erreur: $e')));
      }
    } finally {
      if (context.mounted) {
        ref.read(registerLoadingProvider.notifier).state = false;
      }
    }
  }
}
