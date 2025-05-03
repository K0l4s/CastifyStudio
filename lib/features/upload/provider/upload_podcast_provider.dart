import 'dart:io';
import 'package:castify_studio/features/content/data/models/podcast_model.dart';
import 'package:castify_studio/services/podcast_service.dart';
import 'package:castify_studio/services/toast_service.dart';
import 'package:flutter/material.dart';

class UploadPodcastProvider extends ChangeNotifier {
  String title = '';
  String content = '';
  File? video;
  File? thumbnail;
  List<String> selectedGenreIds = [];
  bool isUploading = false;

  final PodcastService _podcastService = PodcastService();

  List<Genre> allGenres = [];

  void setTitle(String value) {
    title = value;
    notifyListeners();
  }

  void setContent(String value) {
    content = value;
    notifyListeners();
  }

  void setVideo(File file) {
    video = file;
    notifyListeners();
  }

  void setThumbnail(File? file) {
    thumbnail = file;
    notifyListeners();
  }

  void setGenres(List<Genre> genres) {
    selectedGenreIds = genres.map((g) => g.id).toList();
    // Update allGenres to include selected genres, preserving others if needed
    final existingIds = allGenres.map((g) => g.id).toSet();
    allGenres = [
      ...allGenres,
      ...genres.where((g) => !existingIds.contains(g.id)),
    ];
    notifyListeners();
  }

  void setAllGenres(List<Genre> genres) {
    allGenres = genres;
    notifyListeners();
  }

  List<Genre> get selectedGenres => allGenres.where((g) => selectedGenreIds.contains(g.id)).toList();

  Future<void> uploadPodcast() async {
    if (title.length > 100) throw Exception("Title too long");
    if (content.length > 5000) throw Exception("Content too long");
    if (video == null) throw Exception("Video is required");
    if (selectedGenreIds.isEmpty || selectedGenreIds.length > 5) {
      throw Exception("Select between 1 and 5 genres");
    }

    isUploading = true;
    notifyListeners();

    try {
      await _podcastService.uploadPodcast(
        title: title,
        content: content,
        video: video!,
        thumbnail: thumbnail,
        genreIds: selectedGenreIds,
      );
      ToastService.showToast("Podcast uploaded successfully!");
    } catch (e) {
      ToastService.showToast("Failed to upload: ${e.toString()}");
    } finally {
      isUploading = false;
      notifyListeners();
    }
  }

  void clear() {
    title = '';
    content = '';
    video = null;
    thumbnail = null;
    selectedGenreIds = [];
    allGenres = []; // Clear allGenres to ensure fresh state
    isUploading = false;
    notifyListeners();
  }
}