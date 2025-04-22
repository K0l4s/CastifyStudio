import 'package:castify_studio/features/auth/data/models/user_model.dart';
import 'package:castify_studio/services/api_service.dart';
import 'package:logger/logger.dart';

class UserService {
  final _api = ApiService();
  final logger = Logger();

  Future<UserModel?> getSelfUserInfo() async {
    try {
      final res = await _api.get('/user');
      return UserModel.fromJson(res);
    } catch (e, stack) {
      logger.e('Error loading user info', error: e, stackTrace: stack);
      return null;
    }
  }
}
