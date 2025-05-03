class UserCardModel {
  final String id;
  final String fullname;
  final String username;
  final String? avatarUrl;
  final bool follow;
  final int totalFollower;
  final int totalFollowing;
  final int totalPost;

  UserCardModel({
    required this.id,
    required this.fullname,
    required this.username,
    this.avatarUrl,
    required this.follow,
    required this.totalFollower,
    required this.totalFollowing,
    required this.totalPost,
  });

  factory UserCardModel.fromJson(Map<String, dynamic> json) {
    return UserCardModel(
      id: json['id'] as String,
      fullname: json['fullname'] as String,
      username: json['username'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      follow: json['follow'] as bool? ?? false,
      totalFollower: json['totalFollower'] as int? ?? 0,
      totalFollowing: json['totalFollowing'] as int? ?? 0,
      totalPost: json['totalPost'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullname': fullname,
      'username': username,
      'avatarUrl': avatarUrl,
      'follow': follow,
      'totalFollower': totalFollower,
      'totalFollowing': totalFollowing,
      'totalPost': totalPost,
    };
  }

  UserCardModel copyWith({
    String? id,
    String? fullname,
    String? username,
    String? avatarUrl,
    bool? follow,
    int? totalFollower,
    int? totalFollowing,
    int? totalPost,
  }) {
    return UserCardModel(
      id: id ?? this.id,
      fullname: fullname ?? this.fullname,
      username: username ?? this.username,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      follow: follow ?? this.follow,
      totalFollower: totalFollower ?? this.totalFollower,
      totalFollowing: totalFollowing ?? this.totalFollowing,
      totalPost: totalPost ?? this.totalPost,
    );
  }
}
