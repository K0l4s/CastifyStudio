import 'package:castify_studio/services/comment_service.dart';
import 'package:castify_studio/services/podcast_service.dart';
import 'package:flutter/material.dart';
import 'package:castify_studio/features/content/data/models/podcast_model.dart';
import 'package:castify_studio/features/manage_comment/data/models/comment_model.dart';
import 'package:castify_studio/features/manage_comment/data/models/comment_response_model.dart';

class CommentProvider with ChangeNotifier {
  final PodcastService _podcastService = PodcastService();
  final CommentService _commentService = CommentService();

  List<Podcast> _podcasts = [];
  Map<String, List<Comment>> _podcastComments = {};
  Map<String, CommentResponse> _paginatedComments = {};
  Map<String, List<Comment>> _childComments = {};
  bool _isLoadingPodcasts = false;
  bool _isLoadingComments = false;
  bool _hasMorePodcasts = true;
  int _currentPodcastPage = 0;
  String? _error;

  List<Podcast> get podcasts => _podcasts;
  Map<String, List<Comment>> get podcastComments => _podcastComments;
  Map<String, CommentResponse> get paginatedComments => _paginatedComments;
  Map<String, List<Comment>> get childComments => _childComments;
  bool get isLoadingPodcasts => _isLoadingPodcasts;
  bool get isLoadingComments => _isLoadingComments;
  String? get error => _error;
  bool get hasMorePodcasts => _hasMorePodcasts;

  // Fetch initial podcasts (first page, 5 podcasts)
  Future<void> fetchPodcasts() async {
    if (_isLoadingPodcasts || !_hasMorePodcasts) return;
    _isLoadingPodcasts = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _podcastService.fetchSelfPodcastsInCreator(
        page: _currentPodcastPage,
        size: 5,
      );
      _podcasts = response.content;
      _hasMorePodcasts = _currentPodcastPage < response.totalPages - 1;
      for (var podcast in _podcasts) {
        await fetchComments(podcast.id, size: 5);
      }
      _currentPodcastPage++;
    } catch (e) {
      _error = 'Error fetching podcasts: $e';
    } finally {
      _isLoadingPodcasts = false;
      notifyListeners();
    }
  }

  // Load more podcasts (next page)
  Future<void> loadMorePodcasts() async {
    if (_isLoadingPodcasts || !_hasMorePodcasts) return;
    _isLoadingPodcasts = true;
    notifyListeners();

    try {
      final response = await _podcastService.fetchSelfPodcastsInCreator(
        page: _currentPodcastPage,
        size: 5,
      );
      _podcasts.addAll(response.content);
      _hasMorePodcasts = _currentPodcastPage < response.totalPages - 1;
      for (var podcast in response.content) {
        await fetchComments(podcast.id, size: 5);
      }
      _currentPodcastPage++;
    } catch (e) {
      _error = 'Error loading more podcasts: $e';
    } finally {
      _isLoadingPodcasts = false;
      notifyListeners();
    }
  }

  // Refresh podcasts (clear and fetch fresh data)
  Future<void> refreshPodcasts() async {
    _podcasts.clear();
    _podcastComments.clear();
    _paginatedComments.clear();
    _childComments.clear();
    _currentPodcastPage = 0;
    _hasMorePodcasts = true;
    await fetchPodcasts();
  }

  // Fetch comments for a podcast (used for initial 5 comments)
  Future<void> fetchComments(String podcastId, {int size = 5}) async {
    if (_podcastComments[podcastId] != null) return;
    _isLoadingComments = true;
    notifyListeners();

    try {
      final comments = await _commentService.fetchCommentsOfPodcast(
        podcastId: podcastId,
        size: size,
      );
      _podcastComments[podcastId] = comments;
    } catch (e) {
      _error = 'Error fetching comments for podcast $podcastId: $e';
    } finally {
      _isLoadingComments = false;
      notifyListeners();
    }
  }

  // Fetch paginated comments for a podcast (used in AllCommentsScreen)
  Future<void> fetchPaginatedComments(String podcastId, {int page = 0, int size = 10}) async {
    _isLoadingComments = true;
    notifyListeners();

    try {
      final response = await _commentService.getCommentsByPodcast(
        podcastId: podcastId,
        page: page,
        size: size,
      );
      final commentResponse = CommentResponse.fromJson(response);

      if (page == 0) {
        _paginatedComments[podcastId] = commentResponse;
      } else {
        final existing = _paginatedComments[podcastId];
        if (existing != null) {
          _paginatedComments[podcastId] = CommentResponse(
            content: [...existing.content, ...commentResponse.content],
            size: commentResponse.size,
            currentPage: commentResponse.currentPage,
            totalPages: commentResponse.totalPages,
            totalElements: commentResponse.totalElements,
          );
        }
      }

      // Update non-paginated comments for ManageCommentScreen
      _podcastComments[podcastId] = _paginatedComments[podcastId]?.content.take(5).toList() ?? [];
    } catch (e) {
      _error = 'Error fetching paginated comments: $e';
    } finally {
      _isLoadingComments = false;
      notifyListeners();
    }
  }

  // Fetch child comments for a parent comment
  Future<void> fetchChildComments(String parentCommentId) async {
    if (_childComments[parentCommentId] != null) return;
    _isLoadingComments = true;
    notifyListeners();

    try {
      final response = await _commentService.getCommentReplies(parentCommentId);
      final List<dynamic> comments = response; // Direct list response
      _childComments[parentCommentId] = comments.map((e) => Comment.fromJson(e)).toList();
    } catch (e) {
      _error = 'Error fetching child comments for comment $parentCommentId: $e';
    } finally {
      _isLoadingComments = false;
      notifyListeners();
    }
  }

  // Like a comment
  Future<void> likeComment(String podcastId, String commentId) async {
    try {
      await _commentService.likeComment(commentId);
      _updateComment(podcastId, commentId);
    } catch (e) {
      _error = 'Error liking comment: $e';
      notifyListeners();
    }
  }

  // Add a reply to a comment
  Future<void> addReply(String podcastId, String commentId, String content) async {
    try {
      await _commentService.addComment(
        podcastId: podcastId,
        content: content,
        parentId: commentId,
      );
      // Refresh comments and child comments
      _podcastComments.remove(podcastId);
      _paginatedComments.remove(podcastId);
      _childComments.remove(commentId);
      await fetchComments(podcastId, size: 5);
      await fetchPaginatedComments(podcastId, page: 0);
      await fetchChildComments(commentId);
    } catch (e) {
      _error = 'Error adding reply: $e';
      notifyListeners();
    }
  }

  Future<void> addComment(String podcastId, String content) async {
    try {
      await _commentService.addComment(podcastId: podcastId, content: content);
      _podcastComments.remove(podcastId);
      _paginatedComments.remove(podcastId);
      await fetchComments(podcastId, size: 5);
      await fetchPaginatedComments(podcastId, page: 0);
    } catch (e) {
      _error = 'Error adding comment: $e';
      notifyListeners();
    }
  }

  // Helper to update comment like status
  void _updateComment(String podcastId, String commentId) {
    final comments = _podcastComments[podcastId];
    final paginatedComments = _paginatedComments[podcastId]?.content;
    final childComments = _childComments.values.expand((c) => c).toList();

    if (comments != null) {
      _podcastComments[podcastId] = comments.map((c) {
        if (c.id == commentId) {
          return Comment(
            id: c.id,
            parentId: c.parentId,
            content: c.content,
            mentionedUser: c.mentionedUser,
            totalLikes: c.liked ? c.totalLikes - 1 : c.totalLikes + 1,
            totalReplies: c.totalReplies,
            timestamp: c.timestamp,
            user: c.user,
            liked: !c.liked,
          );
        }
        return c;
      }).toList();
    }

    if (paginatedComments != null) {
      _paginatedComments[podcastId] = CommentResponse(
        content: paginatedComments.map((c) {
          if (c.id == commentId) {
            return Comment(
              id: c.id,
              parentId: c.parentId,
              content: c.content,
              mentionedUser: c.mentionedUser,
              totalLikes: c.liked ? c.totalLikes - 1 : c.totalLikes + 1,
              totalReplies: c.totalReplies,
              timestamp: c.timestamp,
              user: c.user,
              liked: !c.liked,
            );
          }
          return c;
        }).toList(),
        size: _paginatedComments[podcastId]!.size,
        currentPage: _paginatedComments[podcastId]!.currentPage,
        totalPages: _paginatedComments[podcastId]!.totalPages,
        totalElements: _paginatedComments[podcastId]!.totalElements,
      );
    }

    for (var parentId in _childComments.keys) {
      _childComments[parentId] = _childComments[parentId]!.map((c) {
        if (c.id == commentId) {
          return Comment(
            id: c.id,
            parentId: c.parentId,
            content: c.content,
            mentionedUser: c.mentionedUser,
            totalLikes: c.liked ? c.totalLikes - 1 : c.totalLikes + 1,
            totalReplies: c.totalReplies,
            timestamp: c.timestamp,
            user: c.user,
            liked: !c.liked,
          );
        }
        return c;
      }).toList();
    }

    notifyListeners();
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}