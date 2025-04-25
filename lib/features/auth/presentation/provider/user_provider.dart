import 'package:castify_studio/features/auth/data/models/user_model.dart';
import 'package:castify_studio/utils/shared_prefs.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  UserModel? _user;

  UserModel? get user => _user;

  String? get avatarUrl => _user?.avatarUrl;
  String? get username => _user?.username;
  String? get fullname => _user?.fullname;
  String? get email => _user?.email;

  // Load user từ SharedPreferences
  Future<void> loadUserInfoFromPrefs() async {
    _user = await SharedPrefs.getUser();
    notifyListeners();
  }

  Future<UserModel> loadUserModel() async {
    _user = await SharedPrefs.getUser();
    notifyListeners();
    return _user!;
  }

  // Cập nhật toàn bộ user và lưu vào SharedPreferences
  Future<void> updateUser(UserModel user) async {
    _user = user;
    await SharedPrefs.saveUser(user);
    notifyListeners();
  }

  // Xóa user và xóa luôn trong SharedPreferences
  Future<void> clear() async {
    _user = null;
    await SharedPrefs.clearUser();
    notifyListeners();
  }
}

