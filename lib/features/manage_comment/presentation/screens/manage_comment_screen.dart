import 'package:castify_studio/features/manage_comment/presentation/screens/all_comment_screen.dart';
import 'package:castify_studio/features/manage_comment/provider/comment_provider.dart';
import 'package:castify_studio/utils/format_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:castify_studio/features/auth/presentation/provider/user_provider.dart';
import 'package:castify_studio/features/manage_comment/data/models/comment_model.dart';
import 'package:castify_studio/common/widgets/common_sliver_app_bar.dart';

class ManageCommentScreen extends StatefulWidget {
  const ManageCommentScreen({super.key});

  @override
  _ManageCommentScreenState createState() => _ManageCommentScreenState();
}

class _ManageCommentScreenState extends State<ManageCommentScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<CommentProvider>(context, listen: false);
      provider.refreshPodcasts();
    });
  }

  Future<String?> _showCommentBottomSheet(BuildContext context, {bool isReply = false}) async {
    final TextEditingController controller = TextEditingController();
    final focusNode = FocusNode();
    String? result;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16.0,
            right: 16.0,
            top: 16.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isReply ? 'Reply to Comment' : 'Add Comment',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              // Comment Input
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Avatar
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(context.read<UserProvider>().avatarUrl ?? ''),
                    onBackgroundImageError: (error, stackTrace) => const Icon(Icons.person),
                  ),
                  const SizedBox(width: 12.0),
                  Expanded(
                    child: TextField(
                      controller: controller,
                      focusNode: focusNode,
                      autofocus: true,
                      minLines: 1,
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText: isReply ? 'Write your reply...' : 'Write your comment...',
                        hintStyle: const TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                      ),
                    ),
                  ),
                  // Send Button
                  IconButton(
                    icon: const Icon(Icons.send, color: Colors.blue),
                    onPressed: () {
                      if (controller.text.trim().isNotEmpty) {
                        result = controller.text.trim();
                        Navigator.pop(context);
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
            ],
          ),
        );
      },
    );

    focusNode.requestFocus();
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CommentProvider>(
      builder: (context, provider, child) {
        if (provider.isLoadingPodcasts && provider.podcasts.isEmpty) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (provider.error != null) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(provider.error!),
                  ElevatedButton(
                    onPressed: () {
                      provider.clearError();
                      provider.refreshPodcasts();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        final podcasts = provider.podcasts;
        return NestedScrollView(
          headerSliverBuilder: (_, __) => const [
            CommonSliverAppBar(),
          ],
          body: NotificationListener<ScrollNotification>(
            onNotification: (scrollInfo) {
              if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent &&
                  provider.hasMorePodcasts &&
                  !provider.isLoadingPodcasts) {
                provider.loadMorePodcasts();
                return true;
              }
              return false;
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Manage Comments Title
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
                  child: Text(
                    'Manage Comments',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // Podcast List
                Expanded(
                  child: ListView.builder(
                    itemCount: podcasts.length + (provider.isLoadingPodcasts ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == podcasts.length) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final podcast = podcasts[index];
                      final comments = provider.podcastComments[podcast.id] ?? [];
                      return Card(
                        margin: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 10),
                            // Podcast Info
                            ListTile(
                              leading: SizedBox(
                                width: 80,
                                height: 50,
                                child: Image.network(
                                  podcast.thumbnailUrl,
                                  fit: BoxFit.cover,
                                  loadingBuilder: (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return const Center(child: CircularProgressIndicator());
                                  },
                                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
                                ),
                              ),
                              title: Text(podcast.title, maxLines: 2, overflow: TextOverflow.ellipsis),
                            ),
                            // Comments
                            if (comments.isNotEmpty) ...[
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                child: Text(
                                  'Comments',
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              ...comments.take(5).map((comment) => CommentWidget(
                                comment: comment,
                                onLike: () {
                                  provider.likeComment(podcast.id, comment.id);
                                },
                                onReply: () async {
                                  final replyContent = await _showCommentBottomSheet(context, isReply: true);
                                  if (replyContent != null) {
                                    await provider.addReply(podcast.id, comment.id, replyContent);
                                  }
                                },
                                onShowReplies: comment.totalReplies > 0
                                    ? () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AllCommentsScreen(podcast: podcast),
                                    ),
                                  );
                                }
                                    : null,
                                showRepliesText: comment.totalReplies > 0
                                    ? 'View Replies (${comment.totalReplies})'
                                    : null,
                              )),
                              // Show All Button
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AllCommentsScreen(podcast: podcast),
                                      ),
                                    );
                                  },
                                  child: Text('Show All', style: TextStyle(color: Colors.blue.shade800)),
                                ),
                              ),
                            ] else
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('No comments yet.'),
                                    const SizedBox(height: 8.0),
                                    TextButton(
                                      onPressed: () async {
                                        final commentContent = await _showCommentBottomSheet(context, isReply: false);
                                        if (commentContent != null) {
                                          await provider.addComment(podcast.id, commentContent);
                                        }
                                      },
                                      child: Text('Add a Comment', style: TextStyle(color: Colors.blue.shade800)),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class CommentWidget extends StatelessWidget {
  final Comment comment;
  final VoidCallback onLike;
  final VoidCallback onReply;
  final VoidCallback? onShowReplies;
  final String? showRepliesText;
  final bool isChild;

  const CommentWidget({
    Key? key,
    required this.comment,
    required this.onLike,
    required this.onReply,
    this.onShowReplies,
    this.showRepliesText,
    this.isChild = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: isChild ? 16.0 : 12.0, right: 8.0, top: 8.0, bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(comment.user.avatarUrl ?? ''),
            onBackgroundImageError: (error, stackTrace) => const Icon(Icons.person),
          ),
          const SizedBox(width: 12.0),
          // Comment Content and Actions
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Row for Username, Timestamp, and More Menu
                Row(
                  children: [
                    Text(
                      comment.user.username,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Text(
                      FormatUtils.formatTimeAgo(comment.timestamp),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    const Spacer(),
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert, size: 20),
                      onSelected: (value) {
                        if (value == 'report') {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Reported comment')),
                          );
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'report',
                          child: Text('Report'),
                        ),
                      ],
                    ),
                  ],
                ),
                // const SizedBox(height: 4.0),
                // Comment Content
                Text(
                  comment.content,
                  style: const TextStyle(fontSize: 14),
                ),
                // const SizedBox(height: 8.0),
                // Row for Like and Reply Buttons
                Row(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            comment.liked ? Icons.favorite : Icons.favorite_border,
                            color: comment.liked ? Colors.red : Colors.grey,
                            size: 20,
                          ),
                          onPressed: onLike,
                        ),
                        if (comment.totalLikes > 0)
                          Text(
                            '${comment.totalLikes}',
                            style: TextStyle(fontSize: 12, color: Colors.blue.shade800),
                          ),
                      ],
                    ),
                    const SizedBox(width: 16.0),
                    IconButton(
                      icon: const Icon(Icons.comment, size: 20, color: Colors.grey),
                      onPressed: onReply,
                    ),
                  ],
                ),
                // Show Replies Button
                if (showRepliesText != null)
                  TextButton(
                    onPressed: onShowReplies,
                    child: Text(
                      showRepliesText!,
                      style: const TextStyle(fontSize: 14, color: Colors.blue),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}