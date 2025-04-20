import 'package:castify_studio/features/auth/domain/entities/role.dart';
import 'package:castify_studio/features/auth/domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    required super.id,
    required super.firstName,
    required super.middleName,
    required super.lastName,
    required super.avatarUrl,
    required super.coverUrl,
    required super.email,
    required super.birthday,
    required super.address,
    required super.phone,
    required super.code,
    required super.createDay,
    required super.isActive,
    required super.isLock,
    required super.username,
    required super.role,
    required super.enabled,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      firstName: json['firstName'],
      middleName: json['middleName'],
      lastName: json['lastName'],
      avatarUrl: json['avatarUrl'],
      coverUrl: json['coverUrl'],
      email: json['email'],
      birthday: json['birthday'],
      address: json['address'],
      phone: json['phone'],
      code: json['code'],
      createDay: DateTime.parse(json['createDay']),
      isActive: json['isActive'],
      isLock: json['isLock'],
      username: json['username'],
      role: Role.values.firstWhere((e) => e.toString().split('.').last == json['role']),
      enabled: json['enabled'],
    );
  }
}