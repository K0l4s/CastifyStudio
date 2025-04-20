import 'package:castify_studio/features/home/presentation/home_screen.dart';
import 'package:castify_studio/features/splash/presentation/splash_screen.dart';
import 'package:castify_studio/services/auth_service.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<StatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final authService = AuthService();
  bool loading = false;

  Future<void> _handleLogin() async {
    setState(() => loading = true);
    final success = await authService.login(
      emailCtrl.text.trim(), passwordCtrl.text.trim()
    );

    if (success && mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
            (Route<dynamic> route) => false, // xoá hết mọi route trước đó
      );
    }


    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          TextField(controller: emailCtrl, decoration: const InputDecoration(labelText: "Email")),
          TextField(controller: passwordCtrl, obscureText: true, decoration: const InputDecoration(labelText: "Password")),
          const SizedBox(height: 20),
          ElevatedButton(
              onPressed: loading ? null : _handleLogin,
              child: loading ? const CircularProgressIndicator() : const Text("Login")),
        ])
      ),
    );
  }
}