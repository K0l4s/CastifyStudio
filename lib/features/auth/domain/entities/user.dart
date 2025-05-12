class User {
  final String? id;
  final String? firstName;
  final String? middleName;
  final String? lastName;
  final String? username;
  final String? avatarUrl;
  final String? coverUrl;
  final DateTime? birthday;
  final String? address;
  final dynamic location; // có thể define model riêng nếu cần
  final String? locality;
  final String? phone;
  final String? email;
  final int? totalFollower;
  final int? totalFollowing;
  final int? totalPost;
  final bool? follow;

  User({
    this.id,
    this.firstName,
    this.middleName,
    this.lastName,
    this.username,
    this.avatarUrl,
    this.coverUrl,
    this.birthday,
    this.address,
    this.location,
    this.locality,
    this.phone,
    this.email,
    this.totalFollower,
    this.totalFollowing,
    this.totalPost,
    this.follow,
  });
}
