import 'package:castify_studio/common/dialogs/error_dialog.dart';
import 'package:castify_studio/features/auth/presentation/components/my_button.dart';
import 'package:castify_studio/features/auth/presentation/components/my_text_field.dart';
import 'package:castify_studio/features/auth/presentation/provider/auth_provider.dart';
import 'package:castify_studio/features/auth/presentation/provider/user_provider.dart';
import 'package:castify_studio/features/auth/presentation/screens/verify_screen.dart';
import 'package:castify_studio/features/main/presentation/main_screen.dart';
import 'package:castify_studio/services/auth_service.dart';
import 'package:castify_studio/services/toast_service.dart';
import 'package:castify_studio/services/user_service.dart';
import 'package:castify_studio/utils/shared_prefs.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final emailCtrl = TextEditingController();
  final repeatEmailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final confirmPasswordCtrl = TextEditingController();
  final usernameCtrl = TextEditingController();
  final firstNameCtrl = TextEditingController();
  final middleNameCtrl = TextEditingController();
  final lastNameCtrl = TextEditingController();

  final authService = AuthService();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  Future<void> _handleRegister(BuildContext context) async {
    if (emailCtrl.text.trim() != repeatEmailCtrl.text.trim()) {
      showErrorDialog(context, "Emails do not match.");
      return;
    }

    if (passwordCtrl.text != confirmPasswordCtrl.text) {
      showErrorDialog(context, "Passwords do not match.");
      return;
    }

    if (passwordCtrl.text.length < 8) {
      showErrorDialog(context, "Password must be at least 8 characters.");
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.register(
      emailCtrl.text.trim(),
      repeatEmailCtrl.text.trim(),
      passwordCtrl.text.trim(),
      confirmPasswordCtrl.text.trim(),
      usernameCtrl.text.trim(),
      firstNameCtrl.text.trim(),
      middleNameCtrl.text.trim(),
      lastNameCtrl.text.trim(),
    );

    if (success && mounted) {
      ToastService.showToast("Registration successful");

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const VerifyScreen(token: '',)),
            (Route<dynamic> route) => false,
      );
    } else {
      showErrorDialog(context, authProvider.errorMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<AuthProvider>().isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text("Register")),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 30),
          child: Column(
            children: [
              Image.asset('lib/assets/images/logo.png', height: 100),
              const SizedBox(height: 20),
              MyTextField(controller: firstNameCtrl, hintText: "First Name", obscureText: false),
              const SizedBox(height: 12),
              MyTextField(controller: middleNameCtrl, hintText: "Middle Name", obscureText: false),
              const SizedBox(height: 12),
              MyTextField(controller: lastNameCtrl, hintText: "Last Name", obscureText: false),
              const SizedBox(height: 12),
              MyTextField(controller: usernameCtrl, hintText: "Username", obscureText: false),
              const SizedBox(height: 12),
              MyTextField(controller: emailCtrl, hintText: "Email", obscureText: false),
              const SizedBox(height: 12),
              MyTextField(controller: repeatEmailCtrl, hintText: "Repeat Email", obscureText: false),
              const SizedBox(height: 12),
              MyTextField(
                controller: passwordCtrl,
                hintText: "Password",
                obscureText: _obscurePassword,
                suffixIcon: IconButton(
                  icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                  onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                ),
              ),
              const SizedBox(height: 12),
              MyTextField(
                controller: confirmPasswordCtrl,
                hintText: "Confirm Password",
                obscureText: _obscureConfirmPassword,
                suffixIcon: IconButton(
                  icon: Icon(_obscureConfirmPassword ? Icons.visibility_off : Icons.visibility),
                  onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                ),
              ),
              const SizedBox(height: 20),
              MyButton(
                onTap: isLoading ? null : () => _handleRegister(context),
                text: isLoading ? "Registering..." : "Register",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
