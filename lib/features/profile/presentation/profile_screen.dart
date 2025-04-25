import 'package:castify_studio/common/dialogs/confirm_dialog.dart';
import 'package:castify_studio/features/auth/presentation/provider/user_provider.dart';
import 'package:castify_studio/features/auth/presentation/screens/login_screen.dart';
import 'package:castify_studio/features/auth/presentation/screens/privacy_screen.dart';
import 'package:castify_studio/services/toast_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.grey.shade200,
        elevation: 2,// Màu nền của app bar
      ),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, _) {
          final user = userProvider.user;

          if (user == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar và thông tin người dùng
                Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: user.avatarUrl?.isNotEmpty == true
                        ? NetworkImage(user.avatarUrl!)
                        : const AssetImage('lib/assets/images/default_avatar.jpg')
                    as ImageProvider,
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Text(
                    user.fullname ?? 'No full name available',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    '@${user.username}',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // Nút Edit Profile
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // Chuyển đến màn hình chỉnh sửa profile
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade900, // Nền của nút
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                    ),
                    child: Text('Edit Profile', style: TextStyle(color: Colors.grey.shade200),),
                  ),
                ),

                const SizedBox(height: 10),
                const Divider(),

                // Các tùy chọn
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text('Settings'),
                  onTap: () {
                    // Chuyển đến màn hình settings
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.lock),
                  title: const Text('Privacy'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const PrivacyScreen()),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.exit_to_app, color: Colors.red.shade600,),
                  title: Text('Sign Out', style: TextStyle(color: Colors.red.shade600),),
                  onTap: () async {
                    await showConfirmDialog(
                      context,
                      'Sign Out',
                      'Are you sure you want to sign out?',
                      () async {
                        await userProvider.clear();

                        // Hiển thị thông báo toast
                        ToastService.showToast('Successfully signed out');

                        // Quay về màn hình login
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => const LoginScreen()),
                          (Route<dynamic> route) => false
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
