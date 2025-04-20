import 'package:castify_studio/features/auth/domain/entities/role.dart';

class User {
  final String id;
  final String firstName;
  final String middleName;
  final String lastName;
  final String avatarUrl;
  final String coverUrl;
  final String email;
  final String birthday;
  final String address;
  final String phone;
  final String code;
  final DateTime createDay;
  final bool isActive;
  final bool isLock;
  final String username;
  final Role role;
  final bool enabled;

  User({
    required this.id,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.avatarUrl,
    required this.coverUrl,
    required this.email,
    required this.birthday,
    required this.address,
    required this.phone,
    required this.code,
    required this.createDay,
    required this.isActive,
    required this.isLock,
    required this.username,
    required this.role,
    required this.enabled,
  });
}