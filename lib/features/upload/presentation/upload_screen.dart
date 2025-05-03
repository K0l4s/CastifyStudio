import 'dart:io';
import 'package:castify_studio/features/content/data/models/podcast_model.dart';
import 'package:castify_studio/features/content/presentation/widgets/genre_picker_bottom_sheet.dart';
import 'package:castify_studio/features/upload/provider/upload_podcast_provider.dart';
import 'package:castify_studio/services/toast_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:provider/provider.dart';

class UploadPodcastScreen extends StatefulWidget {
  const UploadPodcastScreen({super.key});

  @override
  _UploadPodcastScreenState createState() => _UploadPodcastScreenState();
}

class _UploadPodcastScreenState extends State<UploadPodcastScreen> {
  VideoPlayerController? _videoController;

  @override
  void initState() {
    super.initState();
    // Reset provider state after the first frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<UploadPodcastProvider>();
      provider.clear();
    });
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<UploadPodcastProvider>();

    // Initialize video controller if video is selected
    if (provider.video != null && _videoController == null) {
      _videoController = VideoPlayerController.file(provider.video!)
        ..initialize().then((_) {
          if (mounted) {
            setState(() {});
          }
        });
    } else if (provider.video == null && _videoController != null) {
      _videoController?.dispose();
      _videoController = null;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Podcast'),
      ),
      body: Stack(
        children: [
          // Main content
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Title *',
                    border: OutlineInputBorder(),
                  ),
                  maxLength: 100,
                  onChanged: provider.setTitle,
                ),
                const SizedBox(height: 16.0),

                // Content
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Content (Description) *',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 6,
                  maxLength: 5000,
                  onChanged: provider.setContent,
                ),
                const SizedBox(height: 16.0),

                // Video Picker and Preview
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Video',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8.0),
                        if (provider.video == null)
                          const Text('No video selected', style: TextStyle(color: Colors.grey))
                        else ...[
                          AspectRatio(
                            aspectRatio: _videoController?.value.aspectRatio ?? 16 / 9,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                _videoController != null && _videoController!.value.isInitialized
                                    ? VideoPlayer(_videoController!)
                                    : Container(
                                  color: Colors.grey[200],
                                  child: const Center(child: CircularProgressIndicator()),
                                ),
                                // Play/Pause button
                                GestureDetector(
                                  onTap: () {
                                    if (_videoController != null && _videoController!.value.isInitialized) {
                                      if (_videoController!.value.isPlaying) {
                                        _videoController!.pause();
                                      } else {
                                        _videoController!.play();
                                      }
                                      setState(() {});
                                    }
                                  },
                                  child: Icon(
                                    _videoController != null && _videoController!.value.isPlaying
                                        ? Icons.pause_circle_outline
                                        : Icons.play_circle_outline,
                                    size: 48,
                                    color: Colors.white.withOpacity(0.8),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            provider.video!.path.split('/').last,
                            style: const TextStyle(fontSize: 14, color: Colors.grey),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                        const SizedBox(height: 8.0),
                        OutlinedButton(
                          onPressed: () async {
                            final result = await FilePicker.platform.pickFiles(type: FileType.video);
                            if (result != null) {
                              provider.setVideo(File(result.files.single.path!));
                            }
                          },
                          child: Text(provider.video == null ? 'Select Video' : 'Change Video'
                            ,style: TextStyle(color: Colors.blue.shade800)),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),

                // Thumbnail Picker and Preview
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Thumbnail (optional)',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8.0),
                        if (provider.thumbnail == null)
                          const Text('No thumbnail selected', style: TextStyle(color: Colors.grey))
                        else ...[
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.file(
                              provider.thumbnail!,
                              height: 100,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            provider.thumbnail!.path.split('/').last,
                            style: const TextStyle(fontSize: 14, color: Colors.grey),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                        const SizedBox(height: 8.0),
                        OutlinedButton(
                          onPressed: () async {
                            final result = await FilePicker.platform.pickFiles(type: FileType.image);
                            if (result != null) {
                              provider.setThumbnail(File(result.files.single.path!));
                            }
                          },
                          child: Text(provider.thumbnail == null ? 'Select Thumbnail' : 'Change Thumbnail'
                            , style: TextStyle(color: Colors.blue.shade800)),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),

                // Genre Picker and Preview
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Genres',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8.0),
                        if (provider.selectedGenres.isEmpty)
                          const Text('No genres selected', style: TextStyle(color: Colors.grey))
                        else
                          Wrap(
                            spacing: 8.0,
                            children: provider.selectedGenres
                                .map((genre) => Chip(
                              label: Text(genre.name),
                              backgroundColor: Colors.blue[100],
                            ))
                                .toList(),
                          ),
                        const SizedBox(height: 8.0),
                        OutlinedButton(
                          onPressed: () async {
                            final genres = await showModalBottomSheet<List<Genre>>(
                              context: context,
                              isScrollControlled: true,
                              builder: (_) => GenrePickerBottomSheet(
                                selectedGenreIds: provider.selectedGenreIds,
                              ),
                            );
                            if (genres != null) {
                              provider.setGenres(genres);
                            }
                          },
                          child: Text(provider.selectedGenres.isEmpty ? 'Select Genres' : 'Change Genres'
                            , style: TextStyle(color: Colors.blue.shade800)),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),

                // Submit Button
                OutlinedButton(
                  onPressed: provider.isUploading
                      ? null
                      : () async {
                    try {
                      await provider.uploadPodcast();
                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                    } catch (e) {
                      ToastService.showToast('Upload failed: $e');
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                  ),
                  child: provider.isUploading
                      ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                      : Text('Upload Podcast' ,style: TextStyle(color: Colors.blue.shade800)),
                ),
              ],
            ),
          ),
          // Loading overlay
          if (provider.isUploading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}