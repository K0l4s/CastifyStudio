import 'package:flutter/material.dart';
import '../../../../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final authService = AuthService();

  bool _loading = false;
  bool get isLoading => _loading;

  String _errorMessage = "";
  String get errorMessage => _errorMessage;

  Future<bool> login(String email, String password) async {
    _loading = true;
    _errorMessage = "";
    notifyListeners();

    try {
      final success = await authService.login(email, password);

      _loading = false;
      notifyListeners();

      return success;
    } catch (e) {
      _loading = false;
      _errorMessage = "Username/email or password is not correct";
      notifyListeners();
      return false;
    }
  }
}
