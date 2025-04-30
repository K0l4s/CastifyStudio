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
  final String username;
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
    required this.username,
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
