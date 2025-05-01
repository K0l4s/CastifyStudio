import 'dart:io';

import 'package:castify_studio/features/content/data/models/podcast_model.dart';
import 'package:castify_studio/services/api_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class PodcastService {
  final ApiService _apiService = ApiService();

  Future<PodcastResponse> fetchSelfPodcastsInCreator({
    int page = 0,
    int size = 10,
    int? minViews,
    int? minComments,
    String sortByViews = 'asc',
    String sortByComments = 'asc',
    String sortByCreatedDay = 'desc',
  }) async {
    final queryParams = {
      'page': page.toString(),
      'size': size.toString(),
      'sortByViews': sortByViews,
      'sortByComments': sortByComments,
      'sortByCreatedDay': sortByCreatedDay,
    };

    if (minViews != null) {
      queryParams['minViews'] = minViews.toString();
    }
    if (minComments != null) {
      queryParams['minComments'] = minComments.toString();
    }

    final response = await _apiService.get(
      '/podcast/contents',
      queryParams: queryParams,
    );

    return PodcastResponse.fromJson(response);
  }

  Future<Podcast> updatePodcast({
    required String id,
    String? title,
    String? content,
    List<String>? genreIds,
    MultipartFile? thumbnail,
  }) async {
    final formData = FormData();

    if (title != null) formData.fields.add(MapEntry('title', title));
    if (content != null) formData.fields.add(MapEntry('content', content));
    if (genreIds != null) {
      for (final genreId in genreIds) {
        formData.fields.add(MapEntry('genreIds', genreId));
      }
    }
    if (thumbnail != null) {
      formData.files.add(MapEntry('thumbnail', thumbnail));
    }

    final data = await _apiService.putMultipart('/podcast/edit/$id', formData);
    return Podcast.fromJson(data as Map<String, dynamic>);
  }

  Future<void> togglePodcast(List<String> podcastIds) async {
    return await _apiService.put(
      '/podcast/toggle', podcastIds
    );
  }
}
