import 'package:castify_studio/common/widgets/common_sliver_app_bar.dart';
import 'package:castify_studio/features/content/presentation/provider/podcast_provider.dart';
import 'package:castify_studio/features/content/presentation/screens/list_video_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ContentScreen extends StatefulWidget {
  const ContentScreen({super.key});

  @override
  State<ContentScreen> createState() => _ContentScreenState();
}

class _ContentScreenState extends State<ContentScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Lấy 5 video mới nhất
      context.read<PodcastProvider>().fetchSelfPodcast(size: 5, sortByCreatedDay: 'desc');
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PodcastProvider>();

    return NestedScrollView(
      headerSliverBuilder: (_, __) => [
        CommonSliverAppBar(
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
              },
            ),
          ],
        ),
      ],
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Video", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ShowAllButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const ListVideoScreen()));
                },
              ),
            ],
          ),
          SizedBox(
            height: 200,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: provider.podcasts.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (_, index) {
                final podcast = provider.podcasts[index];
                return Container(
                  width: 240,
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: NetworkImage(podcast.thumbnailUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
                          ),
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                podcast.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(Icons.visibility, size: 14, color: Colors.white70),
                                  const SizedBox(width: 4),
                                  Text('${podcast.views}', style: const TextStyle(color: Colors.white70)),
                                  const SizedBox(width: 8),
                                  Icon(Icons.comment, size: 14, color: Colors.white70),
                                  const SizedBox(width: 4),
                                  Text('${podcast.totalComments}', style: const TextStyle(color: Colors.white70)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 8,
                        right: 0,
                        child: IconButton(
                          icon: const Icon(Icons.more_vert, color: Colors.white),
                          onPressed: () {
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 32),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Playlist", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ShowAllButton(
                onPressed: () {
                  //TODO
                },
              ),
            ],
          ),
          const SizedBox(height: 80, child: Center(child: Text("Chưa có playlist nào"))),
        ],
      ),
    );
  }
}

class ShowAllButton extends StatelessWidget {
  final VoidCallback onPressed;

  const ShowAllButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        side: BorderSide(color: Colors.grey.shade600),
        backgroundColor: Colors.grey.shade600,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      onPressed: onPressed,
      child: const Text("Show all", style: TextStyle(color: Colors.white)),
    );
  }
}
