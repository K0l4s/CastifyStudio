import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:castify_studio/features/auth/presentation/provider/auth_provider.dart';
import 'package:castify_studio/services/toast_service.dart';
import 'package:castify_studio/common/dialogs/error_dialog.dart';
import 'package:castify_studio/features/auth/presentation/components/my_button.dart';
import 'package:castify_studio/features/auth/presentation/components/my_text_field.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String token; // Nhận token từ ForgotScreen
  const ResetPasswordScreen({super.key, required this.token});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final newPasswordCtrl = TextEditingController();
  final confirmPasswordCtrl = TextEditingController();

  Future<void> _handleResetPassword(BuildContext context) async {
    final newPassword = newPasswordCtrl.text.trim();
    final confirmPassword = confirmPasswordCtrl.text.trim();

    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      showErrorDialog(context, "Please enter both password fields.");
      return;
    }

    if (newPassword != confirmPassword) {
      showErrorDialog(context, "Passwords do not match.");
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.resetPassword(newPassword);

    if (success && mounted) {
      ToastService.showToast("Password reset successfully.");
      Navigator.pop(context);  // Quay lại màn hình đăng nhập
    } else {
      showErrorDialog(context, authProvider.errorMessage);
    }
  }

  @override
  void dispose() {
    newPasswordCtrl.dispose();
    confirmPasswordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<AuthProvider>().isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text("Reset Password")),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 40),
          child: Column(
            children: [
              const SizedBox(height: 30),
              const Text(
                "Enter your new password",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 30),
              MyTextField(
                controller: newPasswordCtrl,
                hintText: "New Password",
                obscureText: true,
              ),
              const SizedBox(height: 20),
              MyTextField(
                controller: confirmPasswordCtrl,
                hintText: "Confirm Password",
                obscureText: true,
              ),
              const SizedBox(height: 20),
              MyButton(
                onTap: isLoading ? null : () => _handleResetPassword(context),
                text: isLoading ? "Resetting..." : "Reset Password",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
