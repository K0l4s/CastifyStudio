import 'package:castify_studio/core/themes/light_mode.dart';
import 'package:castify_studio/features/auth/presentation/provider/auth_provider.dart';
import 'package:castify_studio/features/auth/presentation/provider/user_provider.dart';
import 'package:castify_studio/features/splash/presentation/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  await dotenv.load();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Castify Studio',
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
      theme: lightMode,
    );
  }
}