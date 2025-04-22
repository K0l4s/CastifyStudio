import 'package:castify_studio/features/auth/domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    required super.id,
    required super.fullname,
    required super.username,
    required super.avatarUrl,
    required super.coverUrl,
    required super.birthday,
    required super.address,
    required super.location,
    required super.locality,
    required super.phone,
    required super.email,
    required super.totalFollower,
    required super.totalFollowing,
    required super.totalPost,
    required super.follow,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      fullname: json['fullname'],
      username: json['username'],
      avatarUrl: json['avatarUrl'],
      coverUrl: json['coverUrl'],
      birthday: DateTime(
        json['birthday'][0],
        json['birthday'][1],
        json['birthday'][2],
        json['birthday'][3],
        json['birthday'][4],
        json['birthday'][5],
        json['birthday'][6] ~/ 1000000, // convert nanoseconds to milliseconds
      ),
      address: json['address'],
      location: json['location'],
      locality: json['locality'],
      phone: json['phone'],
      email: json['email'],
      totalFollower: json['totalFollower'],
      totalFollowing: json['totalFollowing'],
      totalPost: json['totalPost'],
      follow: json['follow'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullname': fullname,
      'username': username,
      'avatarUrl': avatarUrl,
      'coverUrl': coverUrl,
      'birthday': [
        birthday.year,
        birthday.month,
        birthday.day,
        birthday.hour,
        birthday.minute,
        birthday.second,
        birthday.microsecond * 1000,
      ],
      'address': address,
      'location': location,
      'locality': locality,
      'phone': phone,
      'email': email,
      'totalFollower': totalFollower,
      'totalFollowing': totalFollowing,
      'totalPost': totalPost,
      'follow': follow,
    };
  }
}
