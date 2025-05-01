import 'package:castify_studio/features/content/data/models/podcast_model.dart';
import 'package:flutter/material.dart';

class GenreList extends StatelessWidget {
  final List<Genre> genres;
  final void Function(Genre genre)? onGenreTap;

  const GenreList({
    super.key,
    required this.genres,
    this.onGenreTap,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: genres.map((genre) {
        return OutlinedButton(
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.blue.shade800,
            backgroundColor: Colors.blue.shade800,
            side: BorderSide(color: Colors.blue.shade800),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          onPressed: onGenreTap != null ? () => onGenreTap!(genre) : null,
          child: Text(genre.name, style: TextStyle(color: Colors.white)),
        );
      }).toList(),
    );
  }
}
