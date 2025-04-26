import 'package:castify_studio/features/content/data/models/podcast_model.dart';
import 'package:flutter/material.dart';
import 'package:castify_studio/services/podcast_service.dart';

class PodcastProvider with ChangeNotifier {
  final PodcastService _podcastService = PodcastService();

  List<Podcast> _podcasts = [];
  List<Podcast> get podcasts => _podcasts;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isLoadingMore = false;
  bool get isLoadingMore => _isLoadingMore;

  int _totalPages = 0;
  int get totalPages => _totalPages;

  int _currentPage = 0;
  int get currentPage => _currentPage;

  Future<void> fetchSelfPodcast({
    int page = 0,
    int size = 10,
    int? minViews,
    int? minComments,
    String sortByViews = 'asc',
    String sortByComments = 'asc',
    String sortByCreatedDay = 'desc',
    bool append = false,
  }) async {
    try {
      if (append) {
        _isLoadingMore = true;
      } else {
        _isLoading = true;
      }
      notifyListeners();

      final response = await _podcastService.fetchSelfPodcastsInCreator(
        page: page,
        size: size,
        minViews: minViews,
        minComments: minComments,
        sortByViews: sortByViews,
        sortByComments: sortByComments,
        sortByCreatedDay: sortByCreatedDay,
      );

      if (append) {
        _podcasts.addAll(response.content);
      } else {
        _podcasts = response.content;
      }

      _currentPage = page;
      _totalPages = response.totalPages;
    } catch (e) {
      print('Error fetching podcasts: $e');
    } finally {
      _isLoading = false;
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  Future<void> clearAndFetchAll({
    required String sortBy,
    required String order,
  }) async {
    _podcasts.clear();
    _currentPage = 0;
    _totalPages = 0;
    await fetchSelfPodcast(
      page: 0,
      sortByViews: sortBy == 'views' ? order : 'asc',
      sortByComments: sortBy == 'comments' ? order : 'asc',
      sortByCreatedDay: sortBy == 'createdDay' ? order : 'desc',
    );
  }

  Future<void> fetchMore({
    required String sortBy,
    required String order,
  }) async {
    if (_currentPage + 1 >= _totalPages) return;
    await fetchSelfPodcast(
      page: _currentPage + 1,
      append: true,
      sortByViews: sortBy == 'views' ? order : 'asc',
      sortByComments: sortBy == 'comments' ? order : 'asc',
      sortByCreatedDay: sortBy == 'createdDay' ? order : 'desc',
    );
  }
}
