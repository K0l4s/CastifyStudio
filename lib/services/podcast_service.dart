import 'dart:io';

import 'package:castify_studio/features/content/data/models/podcast_model.dart';
import 'package:castify_studio/services/api_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';

class PodcastService {
  final ApiService _apiService = ApiService();
  final Logger logger = Logger();

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

  Future<Podcast> uploadPodcast({
    required String title,
    required String content,
    required File video,
    File? thumbnail,
    required List<String> genreIds,
  }) async {
    final formData = FormData();

    formData.fields
      ..add(MapEntry('title', title))
      ..add(MapEntry('content', content));

    for (final id in genreIds) {
      formData.fields.add(MapEntry('genreIds', id));
    }

    formData.files.add(
      MapEntry(
        'video',
        await MultipartFile.fromFile(
          video.path,
          filename: video.path.split('/').last,
          contentType: DioMediaType('video', 'mp4'), // Force MIME type
        ),
      ),
    );

    if (thumbnail != null) {
      formData.files.add(
        MapEntry(
          'thumbnail',
          await MultipartFile.fromFile(thumbnail.path, filename: thumbnail.path.split('/').last),
        ),
      );
    }

    final data = await _apiService.postMultipart('/podcast/create', formData);
    return Podcast.fromJson(data as Map<String, dynamic>);
  }
}
