import 'package:app_links/app_links.dart';
import 'package:castify_studio/features/auth/presentation/provider/user_provider.dart';
import 'package:castify_studio/features/main/presentation/main_screen.dart';
import 'package:castify_studio/services/auth_service.dart';
import 'package:castify_studio/services/toast_service.dart';
import 'package:castify_studio/services/user_service.dart';
import 'package:castify_studio/utils/shared_prefs.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:provider/provider.dart';

class VerifyScreen extends StatefulWidget {
  final String token;
  const VerifyScreen({super.key, required this.token});

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  final authService = AuthService();
  bool _isVerifying = false;

  @override
  void initState() {
    super.initState();
    _verify();
  }

  Future<void> _verify() async {
    final isVerified = await authService.verifyAccount(widget.token);

    if (mounted) {
      if (isVerified) {
        final userInfo = await UserService().getSelfUserInfo();
        if (userInfo != null) {
          await SharedPrefs.saveUser(userInfo);

          final userProvider = Provider.of<UserProvider>(context, listen: false);
          userProvider.updateUser(userInfo);
          ToastService.showToast("Welcome");
        }

        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const MainScreen()),
              (Route<dynamic> route) => false, // xoá hết mọi route trước đó
        );
      } else {
        ToastService.showToast("Failed to verify email.");
        setState(() => _isVerifying = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _isVerifying
            ? const CircularProgressIndicator()
            : const Text("Please check your email to verify your account..."),
      ),
    );
  }
}
