import 'package:flutter_dotenv/flutter_dotenv.dart';

class Genre {
  final String id;
  final String name;

  Genre({required this.id, required this.name});

  factory Genre.fromJson(Map<String, dynamic> json) {
    return Genre(
      id: json['id'],
      name: json['name'],
    );
  }
}

class User {
  final String id;
  final String fullname;
  final String username;
  final String avatarUrl;

  User({
    required this.id,
    required this.fullname,
    required this.username,
    required this.avatarUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      fullname: json['fullname'],
      username: json['username'],
      avatarUrl: json['avatarUrl'],
    );
  }
}

class Podcast {
  final String id;
  final String title;
  final String content;
  final String thumbnailUrl;
  final String videoUrl;
  final List<Genre> genres;
  final int views;
  final int duration;
  final int totalLikes;
  final int totalComments;
  final String? username;
  final String createdDay;
  final String lastEdited;
  final User user;
  final bool liked;
  final bool active;

  Podcast({
    required this.id,
    required this.title,
    required this.content,
    required this.thumbnailUrl,
    required this.videoUrl,
    required this.genres,
    required this.views,
    required this.duration,
    required this.totalLikes,
    required this.totalComments,
    this.username,
    required this.createdDay,
    required this.lastEdited,
    required this.user,
    required this.liked,
    required this.active,
  });

  factory Podcast.fromJson(Map<String, dynamic> json) {
    return Podcast(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      thumbnailUrl: json['thumbnailUrl'],
      videoUrl: json['videoUrl'],
      genres: (json['genres'] as List)
          .map((e) => Genre.fromJson(e))
          .toList(),
      views: json['views'],
      duration: json['duration'],
      totalLikes: json['totalLikes'],
      totalComments: json['totalComments'],
      username: json['username'],
      createdDay: json['createdDay'],
      lastEdited: json['lastEdited'],
      user: User.fromJson(json['user']),
      liked: json['liked'],
      active: json['active'],
    );
  }

  Podcast copyWith({
    String? id,
    String? title,
    String? content,
    String? thumbnailUrl,
    String? videoUrl,
    List<Genre>? genres,
    int? views,
    int? duration,
    int? totalLikes,
    int? totalComments,
    String? username,
    String? createdDay,
    String? lastEdited,
    User? user,
    bool? liked,
    bool? active,
  }) {
    return Podcast(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      videoUrl: videoUrl ?? this.videoUrl,
      genres: genres ?? this.genres,
      views: views ?? this.views,
      duration: duration ?? this.duration,
      totalLikes: totalLikes ?? this.totalLikes,
      totalComments: totalComments ?? this.totalComments,
      username: username ?? this.username,
      createdDay: createdDay ?? this.createdDay,
      lastEdited: lastEdited ?? this.lastEdited,
      user: user ?? this.user,
      liked: liked ?? this.liked,
      active: active ?? this.active,
    );
  }

}

class PodcastResponse {
  final List<Podcast> content;
  final int totalPages;
  final int totalElements;

  PodcastResponse({
    required this.content,
    required this.totalPages,
    required this.totalElements,
  });

  factory PodcastResponse.fromJson(Map<String, dynamic> json) {
    return PodcastResponse(
      content: (json['content'] as List)
          .map((e) => Podcast.fromJson(e))
          .toList(),
      totalPages: json['totalPages'],
      totalElements: json['totalElements'],
    );
  }
}
