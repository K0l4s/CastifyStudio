import 'package:castify_studio/features/content/data/models/podcast_model.dart';
import 'package:castify_studio/services/api_service.dart';

class GenreService {
  final ApiService _api = ApiService();

  Future<List<Genre>> getAllGenres() async {
    final response = await _api.get('/genre/names');
    return (response as List)
        .map((json) => Genre.fromJson(json))
        .toList();
  }

  Future<List<Genre>> getGenresByList(List<String> genreIds) async {
    final response = await _api.post('/genre/namesByList', genreIds);
    return (response as List)
        .map((json) => Genre.fromJson(json))
        .toList();
  }
}
