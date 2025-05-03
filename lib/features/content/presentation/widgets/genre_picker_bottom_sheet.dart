import 'package:flutter/material.dart';
import 'package:castify_studio/features/content/data/models/podcast_model.dart';
import 'package:castify_studio/services/genre_service.dart';
import 'package:castify_studio/services/toast_service.dart';

class GenrePickerBottomSheet extends StatefulWidget {
  final List<String> selectedGenreIds;

  const GenrePickerBottomSheet({
    super.key,
    required this.selectedGenreIds,
  });

  @override
  State<GenrePickerBottomSheet> createState() => _GenrePickerBottomSheetState();
}

class _GenrePickerBottomSheetState extends State<GenrePickerBottomSheet> {
  final GenreService _genreService = GenreService();
  final TextEditingController _searchController = TextEditingController();

  List<Genre> _allGenres = [];
  List<Genre> _filteredGenres = [];
  List<String> selectedIds = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    selectedIds = List<String>.from(widget.selectedGenreIds);
    _fetchGenres();
    _searchController.addListener(_filterGenres);
  }

  // Lọc genres theo text search
  void _filterGenres() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredGenres = _allGenres
          .where((g) => g.name.toLowerCase().contains(query))
          .toList();
    });
  }

  // Lấy toàn bộ genres từ API
  Future<void> _fetchGenres() async {
    try {
      final genres = await _genreService.getAllGenres(); // List<Genre>
      setState(() {
        _allGenres = genres;
        _filteredGenres = genres;
        _isLoading = false;
      });
    } catch (e) {
      ToastService.showToast("Failed to load genres");
      Navigator.pop(context);
    }
  }

  // Bật/tắt chọn genre
  void _toggleGenre(String id) {
    setState(() {
      if (selectedIds.contains(id)) {
        selectedIds.remove(id);
      } else if (selectedIds.length < 5) {
        selectedIds.add(id);
      } else {
        ToastService.showToast("You can't select more than 5 genres");
      }
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterGenres);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.9,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Select genres",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: "Search genres...",
                  hintStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: _filteredGenres.isEmpty
                    ? const Center(child: Text("No genres found"))
                    : ListView.builder(
                  controller: scrollController,
                  itemCount: _filteredGenres.length,
                  itemBuilder: (context, index) {
                    final genre = _filteredGenres[index];
                    return CheckboxListTile(
                      title: Text(genre.name),
                      value: selectedIds.contains(genre.id),
                      onChanged: (_) => _toggleGenre(genre.id),
                      activeColor: Colors.blue.shade800,
                      controlAffinity: ListTileControlAffinity.leading,
                    );
                  },
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: selectedIds.isEmpty ? Colors.grey : Colors.blue.shade800,
                    side: BorderSide(color: selectedIds.isEmpty ? Colors.grey : Colors.blue.shade800),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: selectedIds.isEmpty
                      ? null
                      : () {
                    final selectedGenres = _allGenres
                        .where((g) => selectedIds.contains(g.id))
                        .toList();
                    Navigator.pop(context, selectedGenres);
                  },
                  child: const Text("Confirm"),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}