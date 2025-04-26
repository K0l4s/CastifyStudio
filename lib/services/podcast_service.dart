import 'package:castify_studio/features/content/data/models/podcast_model.dart';
import 'package:castify_studio/services/api_service.dart';

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
}
