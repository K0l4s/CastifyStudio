class Statistics {
  final int totalViews;
  final int totalLikes;
  final int totalComments;
  final int totalFollowers;
  final List<TopVideo> topVideos;

  Statistics({
    required this.totalViews,
    required this.totalLikes,
    required this.totalComments,
    required this.totalFollowers,
    required this.topVideos,
  });

  factory Statistics.fromJson(Map<String, dynamic> json) {
    return Statistics(
      totalViews: json['totalViews'],
      totalLikes: json['totalLikes'],
      totalComments: json['totalComments'],
      totalFollowers: json['totalFollowers'],
      topVideos: (json['topVideos'] as List)
          .map((video) => TopVideo.fromJson(video))
          .toList(),
    );
  }
}

class TopVideo {
  final String title;
  final String thumbnailUrl;
  final int views;
  final int likes;
  final int comments;

  TopVideo({
    required this.title,
    required this.thumbnailUrl,
    required this.views,
    required this.likes,
    required this.comments,
  });

  factory TopVideo.fromJson(Map<String, dynamic> json) {
    return TopVideo(
      title: json['title'],
      thumbnailUrl: json['thumbnailUrl'],
      views: json['views'],
      likes: json['likes'],
      comments: json['comments'],
    );
  }
}
