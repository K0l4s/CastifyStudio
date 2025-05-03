import 'package:castify_studio/common/widgets/common_sliver_app_bar.dart';
import 'package:castify_studio/features/auth/domain/entities/user_card_model.dart';
import 'package:castify_studio/services/follower_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CreatorFollowerScreen extends StatefulWidget {
  const CreatorFollowerScreen({Key? key}) : super(key: key);

  @override
  State<CreatorFollowerScreen> createState() => _CreatorFollowerScreenState();
}

class _CreatorFollowerScreenState extends State<CreatorFollowerScreen> {
  final FollowerService _followerService = FollowerService();

  List<UserCardModel> followers = [];
  int pageNumber = 0;
  final int pageSize = 10;
  int totalPages = 1;

  @override
  void initState() {
    super.initState();
    fetchFollowers();
  }

  Future<void> fetchFollowers() async {
    try {
      final (users, pages) = await _followerService.getFollowers(pageNumber, pageSize);
      setState(() {
        followers = users;
        totalPages = pages;
      });
    } catch (_) {
      Fluttertoast.showToast(msg: 'Get followers failed');
    }
  }

  void toggleFollow(UserCardModel user) async {
    try {
      await _followerService.toggleFollowUser(user.username);

      setState(() {
        followers = followers.map((u) {
          if (u.id == user.id) {
            final isFollowing = u.follow ?? false;
            final updatedCount = isFollowing
                ? (u.totalFollower ?? 0) - 1
                : (u.totalFollower ?? 0) + 1;

            return u.copyWith(
              follow: !isFollowing,
              totalFollower: updatedCount,
            );
          }
          return u;
        }).toList();
      });
    } catch (_) {
      Fluttertoast.showToast(msg: 'Follow/unfollow failed');
    }
  }

  void changePage(int newPage) {
    if (newPage >= 0 && newPage < totalPages) {
      setState(() {
        pageNumber = newPage;
      });
      fetchFollowers();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (_, __) => const [
          CommonSliverAppBar(),
        ],
        body: followers.isEmpty
            ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.people_outline,
                size: 64,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                'No followers yet',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        )
            : Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: followers.length,
                itemBuilder: (context, index) {
                  final user = followers[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(
                              user.avatarUrl?.isNotEmpty == true
                                  ? user.avatarUrl!
                                  : 'https://via.placeholder.com/150',
                            ),
                            radius: 30,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user.fullname ?? '',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '@${user.username}',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      _buildStatistic(
                                        user.totalFollower ?? 0,
                                        'Followers',
                                      ),
                                      const SizedBox(width: 16),
                                      _buildStatistic(
                                        user.totalFollowing ?? 0,
                                        'Following',
                                      ),
                                      const SizedBox(width: 16),
                                      _buildStatistic(
                                        user.totalPost ?? 0,
                                        'Posts',
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () => toggleFollow(user),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: user.follow == true
                                  ? Colors.grey[200]
                                  : Theme.of(context).primaryColor,
                              foregroundColor: user.follow == true
                                  ? Colors.black87
                                  : Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Text(
                              user.follow == true ? 'Following' : 'Follow',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: pageNumber == 0
                        ? null
                        : () => changePage(pageNumber - 1),
                    icon: const Icon(Icons.arrow_back_ios),
                    color: Theme.of(context).primaryColor,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Page ${pageNumber + 1} of $totalPages',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: pageNumber >= totalPages - 1
                        ? null
                        : () => changePage(pageNumber + 1),
                    icon: const Icon(Icons.arrow_forward_ios),
                    color: Theme.of(context).primaryColor,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatistic(int value, String label) {
    return Column(
      children: [
        Text(
          value.toString(),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
