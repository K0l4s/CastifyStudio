import 'package:app_links/app_links.dart';
import 'package:castify_studio/core/themes/light_mode.dart';
import 'package:castify_studio/features/auth/presentation/provider/auth_provider.dart';
import 'package:castify_studio/features/auth/presentation/provider/user_provider.dart';
import 'package:castify_studio/features/auth/presentation/screens/verify_screen.dart';
import 'package:castify_studio/features/content/presentation/provider/podcast_provider.dart';
import 'package:castify_studio/features/manage_comment/provider/comment_provider.dart';
import 'package:castify_studio/features/splash/presentation/splash_screen.dart';
import 'package:castify_studio/features/upload/provider/upload_podcast_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  await dotenv.load();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => PodcastProvider()),
        ChangeNotifierProvider(create: (_) => CommentProvider()),
        ChangeNotifierProvider(create: (_) => UploadPodcastProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AppLinks _appLinks = AppLinks();
  final logger = Logger();
  @override
  void initState() {
    super.initState();
    _handleInitialLink(); // khi app mở lần đầu
    _listenToUriStream(); // khi app đang mở/background
  }

  Future<void> _handleInitialLink() async {
    final uri = await _appLinks.getInitialLink();
    if (uri != null) {
      _processUri(uri);
    }
  }

  void _listenToUriStream() {
    _appLinks.uriLinkStream.listen((uri) {
      if (uri != null) {
        logger.d(uri);
        _processUri(uri);
      }
    }, onError: (err) {
      debugPrint('App Links Error: $err');
    });
  }

  void _processUri(Uri uri) {
    if (uri.scheme == 'castifystudio' && uri.host == 'verify') {
      final token = uri.queryParameters['token'];
      if (token != null) {
        navigatorKey.currentState?.push(
          MaterialPageRoute(
            builder: (_) => VerifyScreen(token: token),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Castify Studio',
      navigatorKey: navigatorKey,
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
      theme: lightMode,
    );
  }
}