import 'package:castify_studio/common/dialogs/error_dialog.dart';
import 'package:castify_studio/features/auth/presentation/components/my_button.dart';
import 'package:castify_studio/features/auth/presentation/components/my_text_field.dart';
import 'package:castify_studio/features/auth/presentation/provider/auth_provider.dart';
import 'package:castify_studio/features/auth/presentation/screens/forgot_screen.dart';
import 'package:castify_studio/features/auth/presentation/screens/privacy_screen.dart';
import 'package:castify_studio/features/main/presentation/main_screen.dart';
import 'package:castify_studio/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<StatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final authService = AuthService();

  bool _obscurePassword = true;

  Future<void> _handleLogin(BuildContext context) async {
    // Validate
    if (emailCtrl.text.trim().isEmpty) {
      showErrorDialog(context, "Please enter your email.");
      return;
    }

    if (passwordCtrl.text.trim().length < 8) {
      showErrorDialog(context, "Password must be at least 8 characters.");
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    final success = await authProvider.login(
      emailCtrl.text.trim(),
      passwordCtrl.text.trim(),
    );

    if (success && mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const MainScreen()),
            (Route<dynamic> route) => false, // xoá hết mọi route trước đó
      );
    } else {
      showErrorDialog(context, authProvider.errorMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<AuthProvider>().isLoading;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 10,
              left: 10,
              child: IconButton(
                icon: const Icon(Icons.help_outline),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const PrivacyScreen()),
                  );
                },
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      // logo
                      Image.asset(
                        'lib/assets/images/logo.png',
                        height: 100,
                      ),

                      const SizedBox(height: 10),
                      Text(
                        "Welcome back, Sir !",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 20
                        ),
                      ),
                      const SizedBox(height: 30),

                      MyTextField(
                        controller: emailCtrl,
                        hintText: "Email",
                        obscureText: false,
                      ),
                      const SizedBox(height: 12),
                      MyTextField(
                        controller: passwordCtrl,
                        hintText: "Password",
                        obscureText: _obscurePassword,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility_off : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      MyButton(
                        onTap: isLoading ? null : () => _handleLogin(context),
                        text: isLoading ? "Logging in..." : "Login",
                      ),
                      const SizedBox(height: 60),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Forgot your password?",
                            style: TextStyle(color: Theme.of(context).colorScheme.primary),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const ForgotScreen()),
                              );
                            },
                            child: Text(
                              " Click here",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.inversePrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      )

                    ]
                ),
              ),
            )
          ],
        ),

      ),
    );
  }
}