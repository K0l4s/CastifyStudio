import 'package:castify_studio/features/chat/presentation/chat_screen.dart';
import 'package:castify_studio/features/content/presentation/content_screen.dart';
import 'package:castify_studio/features/content/presentation/screens/content_screen.dart';

import 'package:castify_studio/features/follower/presentation/creator_follower_screen.dart';

import 'package:castify_studio/features/manage_comment/presentation/screens/manage_comment_screen.dart';

//import 'package:castify_studio/features/notification/presentation/notification_screen.dart';
import 'package:castify_studio/features/overview/presentation/overview_screen.dart';
//import 'package:castify_studio/features/upload/presentation/upload_screen.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    OverviewScreen(),
    ContentScreen(),
    CreatorFollowerScreen(),
    // UploadScreen(),
    ManageCommentScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

  }

  final List<BottomNavigationBarItem> _navItems = const [
    BottomNavigationBarItem(
      icon: Icon(Icons.dashboard),
      label: 'Overview',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.video_library),
      label: 'Content',
    ),
    // BottomNavigationBarItem(
    //   icon: Icon(Icons.add_circle_outline),
    //   label: 'Create',
    // ),
    BottomNavigationBarItem(
      icon: Icon(Icons.comment_outlined),
      label: 'Community',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.verified_user_outlined),
      label: 'Follower',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: _navItems,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue.shade700,
        unselectedItemColor: Colors.grey.shade700,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
