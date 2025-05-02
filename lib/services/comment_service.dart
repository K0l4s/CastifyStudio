import 'package:castify_studio/features/manage_comment/data/models/comment_model.dart';
import 'package:castify_studio/services/api_service.dart';

class CommentService {
  final ApiService _apiService = ApiService();

  Future<List<Comment>> fetchCommentsOfPodcast({
    required String podcastId,
    int page = 0,
    int size = 10,
    String sortBy = 'latest',
  }) async {
    try {
      final response = await _apiService.get(
        '/comment/list/$podcastId',
        queryParams: {
          'page': page.toString(),
          'size': size.toString(),
          'sortBy': sortBy,
        },
      );

      final List<dynamic> content = response['content'];
      return content.map((e) => Comment.fromJson(e)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getCommentsByPodcast({
    required String podcastId,
    required int page,
    required int size,
    String sortBy = 'latest',
  }) async {
    try {
      final response = await _apiService.get(
        '/comment/list/$podcastId',
        queryParams: {
          'page': page.toString(),
          'size': size.toString(),
          'sortBy': sortBy,
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> addComment({
    required String podcastId,
    required String content,
    String? parentId,
    String? mentionedUser,
  }) async {
    try {
      final payload = {
        'podcastId': podcastId,
        'content': content,
        if (parentId != null) 'parentId': parentId,
        if (mentionedUser != null) 'mentionedUser': mentionedUser,
      };

      final response = await _apiService.post(
        '/comment/add',
        payload,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> getCommentReplies(String commentId) async {
    try {
      final response = await _apiService.get(
        '/comment/list/replies/$commentId',
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> likeComment(String commentId) async {
    try {
      final response = await _apiService.post(
        '/comment/reaction',
        {'commentId': commentId},
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> deleteComments(List<String> commentIds) async {
    try {
      final response = await _apiService.deleteWithBody(
        '/comment/delete',
        commentIds,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
