class User {
  final String id;
  final String fullname;
  final String username;
  final String avatarUrl;
  final String coverUrl;
  final DateTime birthday;
  final String address;
  final dynamic location; // có thể define model riêng nếu cần
  final String locality;
  final String phone;
  final String email;
  final int totalFollower;
  final int totalFollowing;
  final int totalPost;
  final bool follow;

  User({
    required this.id,
    required this.fullname,
    required this.username,
    required this.avatarUrl,
    required this.coverUrl,
    required this.birthday,
    required this.address,
    required this.location,
    required this.locality,
    required this.phone,
    required this.email,
    required this.totalFollower,
    required this.totalFollowing,
    required this.totalPost,
    required this.follow,
  });
}
