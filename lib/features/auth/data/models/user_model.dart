import 'package:castify_studio/features/auth/domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    super.id,
    super.firstName,
    super.middleName,
    super.lastName,
    super.username,
    super.avatarUrl,
    super.coverUrl,
    super.birthday,
    super.address,
    super.location,
    super.locality,
    super.phone,
    super.email,
    super.totalFollower,
    super.totalFollowing,
    super.totalPost,
    super.follow,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final birthdayJson = json['birthday'];
    DateTime? parsedBirthday;

    if (birthdayJson != null && birthdayJson is List && birthdayJson.length == 7) {
      parsedBirthday = DateTime(
        birthdayJson[0],
        birthdayJson[1],
        birthdayJson[2],
        birthdayJson[3],
        birthdayJson[4],
        birthdayJson[5],
        birthdayJson[6] ~/ 1000000, // nanoseconds to milliseconds
      );
    }

    return UserModel(
      id: json['id'],
      firstName: json['firstName'],
      middleName: json['middleName'],
      lastName: json['lastName'],
      username: json['username'],
      avatarUrl: json['avatarUrl'],
      coverUrl: json['coverUrl'],
      birthday: parsedBirthday,
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
      'firstName': firstName,
      'middleName': middleName,
      'lastName': lastName,
      'username': username,
      'avatarUrl': avatarUrl,
      'coverUrl': coverUrl,
      'birthday': birthday != null
          ? [
        birthday!.year,
        birthday!.month,
        birthday!.day,
        birthday!.hour,
        birthday!.minute,
        birthday!.second,
        birthday!.microsecond * 1000,
      ]
          : null,
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
