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

  Future<bool> register(String email, String repeatEmail, String password, String confirmPassword,
      String username, String firstName, String middleName, String lastName) async {
    _loading = true;
    _errorMessage = "";
    notifyListeners();

    try {
      final res = await authService.register(email, repeatEmail, password, confirmPassword,
          username, firstName, middleName, lastName);

      _loading = false;
      notifyListeners();

      if (res) {
        return true;
      }
      return false;
    } catch (e) {
      _loading = false;
      _errorMessage = "$e";
      notifyListeners();
      return false;
    }
  }

  // Forgot password
  Future<bool> forgotPassword(String email) async {
    _loading = true;
    _errorMessage = "";
    notifyListeners();

    try {
      final result = await authService.sendResetRequest(email);
      _loading = false;
      notifyListeners();
      return result;
    } catch (e) {
      _loading = false;
      // _errorMessage = "Failed to send reset password request";
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Reset password
  Future<bool> resetPassword(String newPassword) async {
    _loading = true;
    _errorMessage = "";
    notifyListeners();

    try {
      final result = await authService.resetPassword(newPassword);
      _loading = false;
      notifyListeners();
      return result;
    } catch (e) {
      _loading = false;
      _errorMessage = "Failed to reset password";
      notifyListeners();
      return false;
    }
  }
}
