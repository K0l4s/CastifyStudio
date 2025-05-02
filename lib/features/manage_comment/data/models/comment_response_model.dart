import 'package:castify_studio/features/manage_comment/data/models/comment_model.dart';

class CommentResponse {
  final List<Comment> content;
  final int size;
  final int currentPage;
  final int totalPages;
  final int totalElements;

  CommentResponse({
    required this.content,
    required this.size,
    required this.currentPage,
    required this.totalPages,
    required this.totalElements,
  });

  factory CommentResponse.fromJson(Map<String, dynamic> json) {
    return CommentResponse(
      content: (json['content'] as List)
          .map((e) => Comment.fromJson(e))
          .toList(),
      size: json['size'],
      currentPage: json['currentPage'],
      totalPages: json['totalPages'],
      totalElements: json['totalElements'],
    );
  }
}