import 'dart:io';

import 'package:castify_studio/features/content/data/models/podcast_model.dart';
import 'package:castify_studio/features/content/presentation/widgets/genre_picker_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditVideoScreen extends StatefulWidget {
  final Podcast podcast;

  const EditVideoScreen({super.key, required this.podcast});

  @override
  State<EditVideoScreen> createState() => _EditVideoScreenState();
}

class _EditVideoScreenState extends State<EditVideoScreen> {
  final _formKey = GlobalKey<FormState>();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chỉnh sửa Video')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Tiêu đề'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _contentController,
                maxLines: 5,
                decoration: const InputDecoration(labelText: 'Nội dung mô tả'),
              ),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Thumbnail:', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: _pickThumbnail,
                    child: _thumbnailImage != null
                        ? Image.file(_thumbnailImage!, height: 150)
                        : widget.podcast.thumbnailUrl.isNotEmpty
                        ? Image.network(widget.podcast.thumbnailUrl, height: 150)
                        : Container(
                      height: 150,
                      color: Colors.grey[300],
                      child: const Center(child: Text('Chọn ảnh thumbnail')),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text('Thể loại:', style: TextStyle(fontWeight: FontWeight.bold)),
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
                icon: const Icon(Icons.edit),
                label: const Text("Chỉnh sửa thể loại"),
              ),
              const SizedBox(height: 8),

              const SizedBox(height: 24),
              const Text('Chế độ hiển thị:', style: TextStyle(fontWeight: FontWeight.bold)),
              Row(
                children: [
                  Radio<bool>(
                    value: true,
                    groupValue: _isPublic,
                    onChanged: (value) => setState(() => _isPublic = value!),
                  ),
                  const Text('Công khai'),
                  Radio<bool>(
                    value: false,
                    groupValue: _isPublic,
                    onChanged: (value) => setState(() => _isPublic = value!),
                  ),
                  const Text('Riêng tư'),
                ],
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  debugPrint('Genres: $selectedGenres');
                  debugPrint('Title: ${_titleController.text}');
                  debugPrint('Public: $_isPublic');
                },
                child: const Text('Lưu thay đổi'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
