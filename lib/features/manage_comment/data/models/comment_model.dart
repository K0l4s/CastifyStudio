import 'package:castify_studio/features/manage_comment/data/models/comment_user_model.dart';

class Comment {
  final String id;
  final String? parentId;
  final String content;
  final CommentUser? mentionedUser;
  final int totalLikes;
  final int totalReplies;
  final String timestamp;
  final CommentUser user;
  final bool liked;

  Comment({
    required this.id,
    this.parentId,
    required this.content,
    this.mentionedUser,
    required this.totalLikes,
    required this.totalReplies,
    required this.timestamp,
    required this.user,
    required this.liked,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      parentId: json['parentId'],
      content: json['content'],
      mentionedUser: json['mentionedUser'] != null
          ? CommentUser.fromJson(json['mentionedUser'])
          : null,
      totalLikes: json['totalLikes'],
      totalReplies: json['totalReplies'],
      timestamp: json['timestamp'],
      user: CommentUser.fromJson(json['user']),
      liked: json['liked'],
    );
  }
}