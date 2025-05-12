import 'dart:io';

import 'package:castify_studio/features/auth/data/models/user_model.dart';
import 'package:castify_studio/services/api_service.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class UserService {
  final _api = ApiService();
  final logger = Logger();

  Future<UserModel?> getSelfUserInfo() async {
    try {
      final res = await _api.get('/user/auth');
      return UserModel.fromJson(res);
    } catch (e, stack) {
      logger.e('Error loading user info', error: e, stackTrace: stack);
      return null;
    }
  }

  Future<void> changeAvatar(File avatarFile) async {
    try {
      final formData = FormData.fromMap({
        'avatar': await MultipartFile.fromFile(avatarFile.path, filename: 'avatar.jpg'),
      });

      final res = await _api.putMultipart('/user/avatar', formData);
      logger.i('Upload successful: $res');
    } catch (e) {
      logger.e('Error upload avatar: ', error: e);
      return;
    }
  }
}
