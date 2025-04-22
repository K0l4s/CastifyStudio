import 'package:castify_studio/features/auth/presentation/provider/user_provider.dart';
import 'package:castify_studio/features/profile/presentation/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CommonSliverAppBar extends StatelessWidget {
  final List<Widget>? actions;

  const CommonSliverAppBar({super.key, this.actions});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      floating: true,
      snap: true,
      backgroundColor: Colors.grey.shade100,
      elevation: 2,
      centerTitle: false,
      title: Row(
        children: [
          Image.asset(
            'lib/assets/images/logo.png',
            width: 36,
            height: 36,
          ),
          const SizedBox(width: 8),
          Text(
            "CSTUDIO",
            style: TextStyle(
              color: Colors.blue.shade800,
              fontWeight: FontWeight.bold,
              fontSize: 20,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
      actions: [
        ...?actions,
        const SizedBox(width: 8),
        Consumer<UserProvider>(
          builder: (context, userProvider, _) {
            final avatarUrl = userProvider.avatarUrl;
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProfileScreen()),
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: CircleAvatar(
                  radius: 18,
                  backgroundImage: avatarUrl != null && avatarUrl.isNotEmpty
                      ? NetworkImage(avatarUrl)
                      : const AssetImage('lib/assets/images/default_avatar.jpg')
                  as ImageProvider,
                  backgroundColor: Colors.grey.shade200,
                ),
              ),
            );
          },
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          color: Colors.grey.shade300,
          height: 1,
        ),
      ),
    );
  }
}
