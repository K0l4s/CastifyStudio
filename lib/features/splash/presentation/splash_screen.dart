import 'package:castify_studio/features/auth/presentation/screens/login_screen.dart';
import 'package:castify_studio/features/home/presentation/home_screen.dart';
import 'package:castify_studio/services/api_service.dart';
import 'package:castify_studio/services/auth_service.dart';
import 'package:castify_studio/utils/shared_prefs.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<StatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final authService = AuthService();

  @override
  void initState() {
    super.initState();
    _initApp();
  }

  Future<void> _initApp() async {
    final accessToken = await SharedPrefs.getAccessToken();
    print(accessToken);

    if (accessToken != null) {
      ApiService().setToken(accessToken);
      final refreshed = await authService.refreshToken();
      if (refreshed) {
        _goToHome();
      } else {
        await SharedPrefs.clearTokens();
        _goToLogin;
      }
    } else {
      _goToLogin();
    }
  }

  void _goToLogin() {
    Navigator.pushReplacement(context,
      MaterialPageRoute(builder: (_) => const LoginScreen()));
  }

  void _goToHome() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const HomeScreen()),
          (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }

}