import 'package:castify_studio/features/auth/presentation/provider/user_provider.dart';
import 'package:castify_studio/features/manage_comment/provider/comment_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:castify_studio/features/content/data/models/podcast_model.dart';
import 'package:castify_studio/features/manage_comment/presentation/screens/manage_comment_screen.dart';

class AllCommentsScreen extends StatefulWidget {
  final Podcast podcast;

  const AllCommentsScreen({Key? key, required this.podcast}) : super(key: key);

  @override
  _AllCommentsScreenState createState() => _AllCommentsScreenState();
}

class _AllCommentsScreenState extends State<AllCommentsScreen> {
  int _currentPage = 0;
  bool _hasMore = true;
  final Map<String, bool> _expandedReplies = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<CommentProvider>(context, listen: false);
      provider.fetchPaginatedComments(widget.podcast.id, page: _currentPage).then((_) {
        setState(() {
          final paginatedComments = provider.paginatedComments[widget.podcast.id];
          _hasMore = paginatedComments != null && _currentPage < paginatedComments.totalPages - 1;
        });
      });
    });
  }

  Future<void> _loadMoreComments(CommentProvider provider) async {
    if (!_hasMore || provider.isLoadingComments) return;
    _currentPage++;
    await provider.fetchPaginatedComments(widget.podcast.id, page: _currentPage);
    setState(() {
      final paginatedComments = provider.paginatedComments[widget.podcast.id];
      _hasMore = paginatedComments != null && _currentPage < paginatedComments.totalPages - 1;
    });
  }

  void _toggleReplies(String commentId, CommentProvider provider) {
    setState(() {
      _expandedReplies[commentId] = !(_expandedReplies[commentId] ?? false);
      if (_expandedReplies[commentId] == true) {
        provider.fetchChildComments(commentId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CommentProvider>(
      builder: (context, provider, child) {
        final paginatedComments = provider.paginatedComments[widget.podcast.id];
        final comments = paginatedComments?.content ?? [];
        final totalElements = paginatedComments?.totalElements ?? 0;

        if (provider.error != null) {
          return Scaffold(
            appBar: AppBar(title: Text(widget.podcast.title)),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(provider.error!),
                  ElevatedButton(
                    onPressed: () {
                      provider.clearError();
                      provider.fetchPaginatedComments(widget.podcast.id, page: 0);
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text('Comment on podcast'),
          ),
          body: NotificationListener<ScrollNotification>(
            onNotification: (scrollInfo) {
              if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
                _loadMoreComments(provider);
                return true;
              }
              return false;
            },
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Podcast Info
                  ListTile(
                    leading: SizedBox(
                      width: 80,
                      height: 50,
                      child: Image.network(
                        widget.podcast.thumbnailUrl,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(child: CircularProgressIndicator());
                        },
                        errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
                      ),
                    ),
                    title: Text(widget.podcast.title, maxLines: 2, overflow: TextOverflow.ellipsis),
                  ),
                  // Comments
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'Comments ($totalElements)',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: comments.length + (provider.isLoadingComments ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == comments.length) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final comment = comments[index];
                      final isExpanded = _expandedReplies[comment.id] ?? false;
                      final childComments = provider.childComments[comment.id] ?? [];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CommentWidget(
                            comment: comment,
                            onLike: () {
                              provider.likeComment(widget.podcast.id, comment.id);
                            },
                            onReply: () async {
                              final replyContent = await _showReplyDialog(context);
                              if (replyContent != null) {
                                await provider.addReply(widget.podcast.id, comment.id, replyContent);
                              }
                            },
                            onShowReplies: comment.totalReplies > 0
                                ? () => _toggleReplies(comment.id, provider)
                                : null,
                            showRepliesText: comment.totalReplies > 0
                                ? isExpanded
                                ? 'Hide Replies (${comment.totalReplies})'
                                : 'Show Replies (${comment.totalReplies})'
                                : null,
                          ),
                          if (isExpanded && childComments.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(left: 16.0),
                              child: Column(
                                children: childComments
                                    .map((child) => CommentWidget(
                                  comment: child,
                                  isChild: true,
                                  onLike: () {
                                    provider.likeComment(widget.podcast.id, child.id);
                                  },
                                  onReply: () async {
                                    final replyContent = await _showReplyDialog(context);
                                    if (replyContent != null) {
                                      await provider.addReply(widget.podcast.id, comment.id, replyContent);
                                    }
                                  },
                                ))
                                    .toList(),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                        hintStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                      ),
                    ),
                  ),
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

// In AllCommentsScreen, replace _showReplyDialog with:
  Future<String?> _showReplyDialog(BuildContext context) async {
    return _showCommentBottomSheet(context, isReply: true);
  }
}