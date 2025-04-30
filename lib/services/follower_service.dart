
import 'package:castify_studio/features/auth/domain/entities/user_card_model.dart';
import 'package:castify_studio/services/api_service.dart';
import 'package:logger/logger.dart';

class FollowerService {
  final _api = ApiService();
  final _logger = Logger();

  Future<(List<UserCardModel>, int)> getFollowers(int pageNumber, int pageSize) async {
    try {
      final res = await _api.get(
        '/user/followers?pageNumber=$pageNumber&pageSize=$pageSize',
      );

      final List<UserCardModel> users = (res['data'] as List)
          .map((e) => UserCardModel.fromJson(e))
          .toList();
      final int totalPages = res['totalPages'] ?? 1;

      return (users, totalPages);
    } catch (e, stack) {
      _logger.e('Error getting followers', error: e, stackTrace: stack);
      rethrow;
    }
  }
  Future<void> toggleFollowUser(String username) async {
    try {
      final res = await _api.putText('/user/follow?username=$username');
      _logger.i('Toggle follow result: $res');
    } catch (e, stack) {
      _logger.e('Error toggle follow: ', error: e, stackTrace: stack);
      rethrow;
    }
  }


}
