import 'package:castify_studio/services/api_service.dart';
import 'package:castify_studio/utils/shared_prefs.dart';

class AuthService {
  final _api = ApiService();

  Future<bool> login(String username, String password) async {
    final res = await _api.post('/auth/authenticate', {
      'email': username,
      'password': password,
    });

    final accessToken = res['access_token'];
    final refreshToken = res['refresh_token'];

    if (accessToken != null && refreshToken != null) {
      await SharedPrefs.saveToken(accessToken, refreshToken);
      _api.setToken(accessToken);
      return true;
    }
    return false;
  }
  
  Future<bool> refreshToken() async {
    final refreshToken = await SharedPrefs.getRefreshToken();
    if (refreshToken == null) return false;
    
    try {
      final res = await _api.post(
        '/auth/refresh-token',
        {},
        headers: {
          'Authorization': 'Bearer $refreshToken',
        },
      );

      final newAccess = res['access_token'];
      final newRefresh = res['refresh_token'];
      if (newAccess != null) {
        await SharedPrefs.saveToken(newAccess, newRefresh);
        _api.setToken(newAccess);
        return true;
      }
    } catch (_) {}

    return false;
  }
}