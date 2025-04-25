import 'package:castify_studio/features/auth/data/models/statistics.dart';
import 'package:castify_studio/services/api_service.dart';

class CreatorService {
  final ApiService _apiService = ApiService();

  Future<Statistics> getStatistics({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final path =
        '/creator/statistics?startDate=${startDate.toIso8601String()}&endDate=${endDate.toIso8601String()}';
    final response = await _apiService.get(path);
    return Statistics.fromJson(response);
  }
}
