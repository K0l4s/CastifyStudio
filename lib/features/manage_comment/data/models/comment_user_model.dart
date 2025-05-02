class CommentUser {
  final String id;
  final String fullname;
  final String username;
  final String avatarUrl;
  final int totalFollower;
  final int totalFollowing;
  final int totalPost;
  final bool follow;

  CommentUser({
    required this.id,
    required this.fullname,
    required this.username,
    required this.avatarUrl,
    required this.totalFollower,
    required this.totalFollowing,
    required this.totalPost,
    required this.follow,
  });

  factory CommentUser.fromJson(Map<String, dynamic> json) {
    return CommentUser(
      id: json['id'],
      fullname: json['fullname'],
      username: json['username'],
      avatarUrl: json['avatarUrl'],
      totalFollower: json['totalFollower'],
      totalFollowing: json['totalFollowing'],
      totalPost: json['totalPost'],
      follow: json['follow'],
    );
  }
}