import 'package:castify_studio/common/widgets/common_info_bottom_sheet.dart';
import 'package:castify_studio/features/content/data/models/podcast_model.dart';
import 'package:castify_studio/features/content/presentation/provider/podcast_provider.dart';
import 'package:castify_studio/features/content/presentation/screens/edit_video_screen.dart';
import 'package:castify_studio/features/content/presentation/widgets/genre_list.dart';
import 'package:flutter/material.dart';
import 'package:castify_studio/utils/format_utils.dart';
import 'package:provider/provider.dart';

class VideoDetailScreen extends StatelessWidget {
  final Podcast podcast;

  const VideoDetailScreen({super.key, required this.podcast});

  @override
  Widget build(BuildContext context) {

    final podcast = context.watch<PodcastProvider>().podcasts.firstWhere(
          (p) => p.id == this.podcast.id,
      orElse: () => this.podcast,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("Details"),
        backgroundColor: Colors.grey.shade100,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EditVideoScreen(
                    podcast: podcast,
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // TODO: Share
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    podcast.thumbnailUrl,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      FormatUtils.formatDuration(podcast.duration),
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (_) => CommonInfoBottomSheet(
                            title: "Title",
                            description: podcast.title,
                          ),
                        );
                      },
                      child: Text(
                        podcast.title,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(Icons.calendar_today, size: 16, color: Colors.grey.shade700),
                        const SizedBox(width: 4),
                        Text(FormatUtils.formatTimeAgo(podcast.createdDay)),
                        const SizedBox(width: 16),
                        Icon(Icons.lock_open, size: 16, color: Colors.grey.shade700),
                        const SizedBox(width: 4),
                        GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (_) => const CommonInfoBottomSheet(
                                title: "Display mode",
                                description:
                                "• Public: Anyone can watch this podcast.\n"
                                    "• Private: Only owner can watch this podcast.\n\n"
                                    "You can modify display mode by editing podcast.",
                              ),
                            );
                          },
                          child: Row(
                            children: [
                              Text(podcast.active ? "Public" : "Private"),
                              const SizedBox(width: 10),
                              Icon(Icons.info_outline, size: 16, color: Colors.grey.shade700),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (_) => CommonInfoBottomSheet(
                            title: "Description",
                            description: podcast.content,
                          ),
                        );
                      },
                      child: Text(
                        podcast.content.length > 120
                            ? '${podcast.content.substring(0, 120)}... Show more'
                            : podcast.content,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Icon(Icons.visibility, size: 18, color: Colors.grey.shade700),
                        const SizedBox(width: 4),
                        Text(FormatUtils.formatNumber(podcast.views)),

                        const SizedBox(width: 10),

                        Icon(Icons.thumb_up, size: 18, color: Colors.grey.shade700),
                        const SizedBox(width: 4),
                        Text(FormatUtils.formatNumber(podcast.totalLikes)),

                        const SizedBox(width: 10),

                        Icon(Icons.comment, size: 18, color: Colors.grey.shade700),
                        const SizedBox(width: 4),
                        Text(FormatUtils.formatNumber(podcast.totalComments)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      "Genres",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    GenreList(genres: podcast.genres),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
