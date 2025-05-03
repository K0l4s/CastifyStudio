import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:castify_studio/features/auth/presentation/screens/reset_password_screen.dart';
import 'package:castify_studio/common/dialogs/error_dialog.dart';
import 'package:castify_studio/features/auth/presentation/components/my_button.dart';
import 'package:castify_studio/features/auth/presentation/components/my_text_field.dart';
import 'package:castify_studio/features/auth/presentation/provider/auth_provider.dart';
import 'package:castify_studio/features/auth/presentation/screens/verify_screen.dart';
import 'package:castify_studio/services/toast_service.dart';

class ForgotScreen extends StatefulWidget {
  const ForgotScreen({super.key});

  @override
  State<ForgotScreen> createState() => _ForgotScreenState();
}

class _ForgotScreenState extends State<ForgotScreen> {
  final emailCtrl = TextEditingController();

  Future<void> _handleForgotPassword(BuildContext context) async {
    final email = emailCtrl.text.trim();

    if (email.isEmpty) {
      showErrorDialog(context, "Please enter your email.");
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.forgotPassword(email);

    if (success && mounted) {
      ToastService.showToast("Verification code sent to your email");

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ResetPasswordScreen(token: ''), // Chuyển token ở đây nếu cần
        ),
      );
    } else {
      showErrorDialog(context, authProvider.errorMessage);
    }
  }

  @override
  void dispose() {
    emailCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<AuthProvider>().isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text("Forgot Password")),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 40),
          child: Column(
            children: [
              Image.asset('lib/assets/images/logo.png', height: 100),
              const SizedBox(height: 30),
              const Text(
                "Enter your email and we’ll send you a verification code",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 30),
              MyTextField(
                controller: emailCtrl,
                hintText: "Email",
                obscureText: false,
              ),
              const SizedBox(height: 20),
              MyButton(
                onTap: isLoading ? null : () => _handleForgotPassword(context),
                text: isLoading ? "Sending..." : "Send Code",
              ),
            ],
          ),
        ),
      ),
    );
  }
}