import 'dart:io';

import 'package:castify_studio/features/content/data/models/podcast_model.dart';
import 'package:castify_studio/features/content/presentation/provider/podcast_provider.dart';
import 'package:castify_studio/features/content/presentation/widgets/genre_picker_bottom_sheet.dart';
import 'package:castify_studio/services/podcast_service.dart';
import 'package:castify_studio/services/toast_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class EditVideoScreen extends StatefulWidget {
  final Podcast podcast;

  const EditVideoScreen({super.key, required this.podcast});

  @override
  State<EditVideoScreen> createState() => _EditVideoScreenState();
}

class _EditVideoScreenState extends State<EditVideoScreen> {
  final podcastService = PodcastService();
  final _formKey = GlobalKey<FormState>();
  bool _isSaving = false;

  late TextEditingController _titleController;
  late TextEditingController _contentController;

  File? _thumbnailImage;
  final ImagePicker _picker = ImagePicker();

  // List<String> selectedGenreIds = [];
  List<Genre> selectedGenres = [];

  bool _isPublic = true;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.podcast.title);
    _contentController = TextEditingController(text: widget.podcast.content);
    _isPublic = widget.podcast.active;

    // selectedGenreIds = widget.podcast.genres.map((g) => g.id).toList();
    selectedGenres = List<Genre>.from(widget.podcast.genres);

  }

  void _pickGenres() async {
    final newSelected = await showModalBottomSheet<List<Genre>>(
      context: context,
      isScrollControlled: true,
      builder: (_) => GenrePickerBottomSheet(
        selectedGenreIds: selectedGenres.map((g) => g.id).toList(),
      ),
    );

    if (newSelected != null) {
      setState(() {
        selectedGenres = newSelected;
      });
    }
  }

  Future<void> _pickThumbnail() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _thumbnailImage = File(picked.path);
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _onSaveChanges() async {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    // Kiểm tra nếu title và content trống
    if (title.isEmpty || content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Title and content cannot be empty')),
      );
      return;
    }

    setState(() => _isSaving = true);

    final genreIds = selectedGenres.map((g) => g.id).toList();

    MultipartFile? thumbnailFile;
    if (_thumbnailImage != null) {
      thumbnailFile = await MultipartFile.fromFile(
        _thumbnailImage!.path,
        filename: _thumbnailImage!.path.split('/').last,
      );
    }

    try {
      // Gọi API update podcast
      final updatedPodcast = await podcastService.updatePodcast(
        id: widget.podcast.id,
        title: title,
        content: content,
        genreIds: genreIds,
        thumbnail: thumbnailFile,
      );

      if (!mounted) return;

      ToastService.showToast('Podcast updated successfully');
      Provider.of<PodcastProvider>(context, listen: false)
          .updatePodcast(updatedPodcast);
      Navigator.of(context).pop();
    } catch (e) {
      debugPrint('Error updating podcast: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update podcast')),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Video'), backgroundColor: Colors.grey.shade100),
      body:
      Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Thumbnail:', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Stack(
                        clipBehavior: Clip.none, // Allow the button to overflow
                        children: [
                          Opacity(
                            opacity: 0.8, // Adjust this value to control the opacity of the thumbnail
                            child: GestureDetector(
                              onTap: _pickThumbnail,
                              child: SizedBox(
                                height: 150,
                                // Không đặt width, để ảnh tự tính chiều rộng theo tỷ lệ
                                child: _thumbnailImage != null
                                    ? Image.file(
                                  _thumbnailImage!,
                                  height: 150,
                                  fit: BoxFit.fitHeight, // duy trì tỷ lệ theo chiều cao
                                )
                                    : widget.podcast.thumbnailUrl.isNotEmpty
                                    ? Image.network(
                                  widget.podcast.thumbnailUrl,
                                  height: 150,
                                  fit: BoxFit.fitHeight,
                                )
                                    : Container(
                                  height: 150,
                                  color: Colors.grey[300],
                                  child: const Center(child: Text('Select thumbnail')),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 4, // Adjust the position to move it slightly inside the image
                            right: 4, // Adjust the position to move it slightly inside the image
                            child: GestureDetector(
                              onTap: () {
                                // Add your logic for editing the thumbnail
                                debugPrint('Edit thumbnail');
                              },
                              child: Opacity(
                                opacity: 0.9, // Reduced opacity for the edit button
                                child: CircleAvatar(
                                  backgroundColor: Colors.blue, // Blue background color for the button
                                  child: Icon(
                                    Icons.edit, // Pencil icon
                                    color: Colors.white, // White color for the icon
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(labelText: 'Title'),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _contentController,
                    maxLines: 5,
                    decoration: const InputDecoration(labelText: 'Description'),
                  ),
                  const SizedBox(height: 16),
                  const Text('Genres:', style: TextStyle(fontWeight: FontWeight.bold)),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: selectedGenres
                        .map(
                          (genre) => Chip(
                        label: Text(
                          genre.name,
                          style: const TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Colors.blue.shade800,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                          side: BorderSide(
                            color: Colors.blue.shade800,
                          ),
                        ),
                      ),
                    )
                        .toList(),
                  ),
                  TextButton.icon(
                    onPressed: _pickGenres,
                    icon: Icon(Icons.edit, color: Colors.grey.shade700),
                    label: Text("Edit genres", style: TextStyle(color: Colors.grey.shade700)),
                  ),
                  const SizedBox(height: 8),

                  const SizedBox(height: 24),
                  const Text('Display mode:', style: TextStyle(fontWeight: FontWeight.bold)),
                  Row(
                    children: [
                      Radio<bool>(
                        value: true,
                        groupValue: _isPublic,
                        onChanged: (value) async {
                          if (value != null && value != _isPublic) {
                            setState(() => _isPublic = value);
                            try {
                              await context.read<PodcastProvider>().togglePodcastVisibility(widget.podcast.id);
                              ToastService.showToast("Podcast is now public");
                            } catch (e) {
                              debugPrint('Toggle failed: $e');
                              // Revert UI nếu cần
                              setState(() => _isPublic = !_isPublic);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Failed to update visibility')),
                              );
                            }
                          }
                        },
                      ),
                      const Text('Public'),
                      Radio<bool>(
                        value: false,
                        groupValue: _isPublic,
                        onChanged: (value) async {
                          if (value != null && value != _isPublic) {
                            setState(() => _isPublic = value);
                            try {
                              await context.read<PodcastProvider>().togglePodcastVisibility(widget.podcast.id);
                              ToastService.showToast("Podcast is now private");
                            } catch (e) {
                              debugPrint('Toggle failed: $e');
                              setState(() => _isPublic = !_isPublic);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Failed to update visibility')),
                              );
                            }
                          }
                        },
                      ),
                      const Text('Private'),
                    ],
                  ),
                  const SizedBox(height: 32),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.blue.shade800,
                      side: BorderSide(color: Colors.blue.shade800),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: _isSaving ? null : _onSaveChanges,
                    child: const Text('Save changes'),
                  ),
                ],
              ),
            ),
          ),
          if (_isSaving) ...[
            const Positioned.fill(
              child: ModalBarrier(
                color: Colors.black38,
                dismissible: false,
              ),
            ),

            const Center(
              child: CircularProgressIndicator(),
            ),
          ],
        ],
      ),
    );
  }
}
