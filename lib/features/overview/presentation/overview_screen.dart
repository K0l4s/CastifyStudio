import 'package:castify_studio/common/dialogs/info_dialog.dart';
import 'package:castify_studio/features/auth/data/models/statistics.dart';
import 'package:castify_studio/features/auth/data/models/user_model.dart';
import 'package:castify_studio/features/auth/presentation/provider/user_provider.dart';
import 'package:castify_studio/utils/format_utils.dart';
import 'package:flutter/material.dart';
import 'package:castify_studio/common/widgets/common_sliver_app_bar.dart';
import 'package:castify_studio/services/creator_service.dart';
import 'package:provider/provider.dart';

enum DateRangeType { today, thisMonth, thisYear, allTime }

class OverviewScreen extends StatefulWidget {
  const OverviewScreen({super.key});

  @override
  State<OverviewScreen> createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen> {
  final CreatorService _creatorService = CreatorService();
  Statistics? _statistics;
  bool _isLoading = true;
  String? _error;
  DateRangeType _selectedRange = DateRangeType.allTime;
  UserModel? _user;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
    _fetchStatistics();
  }

  void _onDateRangeChanged(DateRangeType type) {
    setState(() {
      _selectedRange = type;
      _isLoading = true;
    });
    _fetchStatistics();
  }

  Map<String, DateTime> _getDateRange(DateRangeType type) {
    final now = DateTime.now();
    switch (type) {
      case DateRangeType.today:
        return {
          'start': DateTime(now.year, now.month, now.day),
          'end': DateTime(now.year, now.month, now.day, 23, 59, 59),
        };
      case DateRangeType.thisMonth:
        return {
          'start': DateTime(now.year, now.month, 1),
          'end': DateTime(now.year, now.month + 1, 0, 23, 59, 59),
        };
      case DateRangeType.thisYear:
        return {
          'start': DateTime(now.year, 1, 1),
          'end': DateTime(now.year, 12, 31, 23, 59, 59),
        };
      case DateRangeType.allTime:
        return {
          'start': DateTime(2000),
          'end': DateTime.now(),
        };
    }
  }

  Future<void> _fetchStatistics() async {
    try {
      final range = _getDateRange(_selectedRange);
      final stats = await _creatorService.getStatistics(
        startDate: range['start']!,
        endDate: range['end']!,
      );
      setState(() {
        _statistics = stats;
        _isLoading = false;
        _error = null;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _loadUserInfo() async {
    final user = await Provider.of<UserProvider>(context, listen: false).loadUserModel();
    setState(() {
      _user = user;
    });
  }

  Widget _buildUserInfo() {
    if (_user == null) return const SizedBox();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundImage: _user?.avatarUrl != null
                ? NetworkImage(_user!.avatarUrl!)
                : const AssetImage('lib/assets/images/default_avatar.jpg') as ImageProvider,
            radius: 40,
          ),
          const SizedBox(width: 16),
          // Info
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${_user!.lastName ?? ''} ${_user!.middleName ?? ''} ${_user!.firstName ?? ''}'.trim(),
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                '@${_user!.username}',
                style: const TextStyle(color: Colors.black),
              ),
              const SizedBox(height: 4),
              Text(
                  '${FormatUtils.formatNumber(_user!.totalFollower ?? 0 )} Followers',
                  style: const TextStyle(color: Colors.black)
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatBox(IconData icon, int value, String title, String description) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          InfoDialog.show(
            context: context,
            title: title,
            description: description,
          );
        },
        child: Container(
          margin: const EdgeInsets.all(4),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey.shade200,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 30, color: Colors.blue.shade800),
              const SizedBox(height: 4),
              Text(FormatUtils.formatNumber(value), style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (_, __) => const [
        CommonSliverAppBar(),
      ],
      body: Column(
        children: [
          if (_user != null) _buildUserInfo(),

          DropdownButton<DateRangeType>(
            value: _selectedRange,
            onChanged: (type) => _onDateRangeChanged(type!),
            items: const [
              DropdownMenuItem(
                value: DateRangeType.today,
                child: Text('Day'),
              ),
              DropdownMenuItem(
                value: DateRangeType.thisMonth,
                child: Text('Month'),
              ),
              DropdownMenuItem(
                value: DateRangeType.thisYear,
                child: Text('Year'),
              ),
              DropdownMenuItem(
                value: DateRangeType.allTime,
                child: Text("All time")
              )
            ],
          ),
          Text("Channel Overview"),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                ? Center(child: Text('Lỗi: $_error'))
                : ListView(
              padding: const EdgeInsets.all(8),
              children: [
                Row(
                  children: [
                    _buildStatBox(Icons.remove_red_eye, _statistics!.totalViews, "Total views", _statistics!.totalViews.toString()),
                    _buildStatBox(Icons.thumb_up, _statistics!.totalLikes, "Total likes", _statistics!.totalLikes.toString()),
                    _buildStatBox(Icons.comment, _statistics!.totalComments, "Total comments", _statistics!.totalComments.toString()),
                    _buildStatBox(Icons.people, _statistics!.totalFollowers, "Total followers", _statistics!.totalFollowers.toString()),
                  ],
                ),
                const SizedBox(height: 16),
                const Text('Top Popular Videos', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                ..._statistics!.topVideos.map((video) {
                  return ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        video.thumbnailUrl,
                        width: 100, // 👈 to hơn
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(video.title, maxLines: 2, overflow: TextOverflow.ellipsis),
                    subtitle: Row(
                      children: [
                        Icon(Icons.remove_red_eye, size: 16, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(FormatUtils.formatNumber(video.views)),
                        const SizedBox(width: 12),
                        Icon(Icons.thumb_up, size: 16, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(FormatUtils.formatNumber(video.likes)),
                        const SizedBox(width: 12),
                        Icon(Icons.comment, size: 16, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(FormatUtils.formatNumber(video.comments)),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
