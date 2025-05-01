import 'package:castify_studio/features/content/presentation/provider/podcast_provider.dart';
import 'package:castify_studio/features/content/presentation/screens/video_detail_screen.dart';
import 'package:castify_studio/utils/format_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListVideoScreen extends StatefulWidget {
  const ListVideoScreen({super.key});

  @override
  State<ListVideoScreen> createState() => _ListVideoScreenState();
}

class _ListVideoScreenState extends State<ListVideoScreen> {
  // Các tùy chọn bộ lọc
  final List<String> _filterOptions = [
    'Default',
    'Views ascending', // BUG
    'Views descending',
    'Comments ascending', // BUG
    'Comments descending',
    'Release date ascending',
    'Release date descending',
  ];
  // Map từ nhãn tới sortBy và order
  final Map<String, Map<String, String>> _filterMap = {
    'Default': {'sortBy': 'createdDay', 'order': 'desc'},
    'Views ascending': {'sortBy': 'views', 'order': 'asc'},
    'Views descending': {'sortBy': 'views', 'order': 'desc'},
    'Comments ascending': {'sortBy': 'comments', 'order': 'asc'},
    'Comments descending': {'sortBy': 'comments', 'order': 'desc'},
    'Release date ascending': {'sortBy': 'createdDay', 'order': 'asc'},
    'Release date descending': {'sortBy': 'createdDay', 'order': 'desc'},
  };

  String _selectedFilter = 'Default';
  String _sortBy = 'createdDay';
  String _order = 'desc';
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _applyFilterAndFetch(); // chạy sau build
    });
    _scrollController.addListener(_onScroll);
  }

  void _applyFilterAndFetch() {
    final mapping = _filterMap[_selectedFilter]!;
    _sortBy = mapping['sortBy']!;
    _order = mapping['order']!;
    context.read<PodcastProvider>().clearAndFetchAll(
      sortBy: _sortBy,
      order: _order,
    );
  }

  void _onScroll() {
    final provider = context.read<PodcastProvider>();
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 100 &&
        !provider.isLoadingMore &&
        !provider.isLoading) {
      provider.fetchMore(sortBy: _sortBy, order: _order);
    }
  }

  void _onFilterSelected(String? label) {
    if (label == null) return;
    setState(() {
      _selectedFilter = label;
    });
    _applyFilterAndFetch();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PodcastProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('All video'),
        backgroundColor: Colors.grey.shade100,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.filter_list, size: 20, color: Colors.black54),
                  const SizedBox(width: 8),
                  const Text(
                    'Sort by:',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedFilter,
                        isExpanded: true,
                        icon: const Icon(Icons.keyboard_arrow_down),
                        items: _filterOptions.map((label) {
                          return DropdownMenuItem(
                            value: label,
                            child: Text(label),
                          );
                        }).toList(),
                        onChanged: _onFilterSelected,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            child: provider.isLoading && provider.podcasts.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
              controller: _scrollController,
              itemCount:
              provider.podcasts.length + (provider.isLoadingMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index >= provider.podcasts.length) {
                  return const Padding(
                    padding: EdgeInsets.all(4),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                final podcast = provider.podcasts[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => VideoDetailScreen(podcast: podcast),
                        ),
                      );
                    },
                    child: Container(
                      color: Colors.white,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.network(
                            podcast.thumbnailUrl,
                            width: 150,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  podcast.title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(Icons.visibility, size: 16, color: Colors.grey.shade700,),
                                    const SizedBox(width: 4),
                                    Text(FormatUtils.formatNumber(podcast.views)),
                                    const SizedBox(width: 12),
                                    Icon(Icons.comment, size: 16, color: Colors.grey.shade700,),
                                    const SizedBox(width: 4),
                                    Text(FormatUtils.formatNumber(podcast.totalComments)),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(Icons.calendar_today, size: 16, color: Colors.grey.shade700,),
                                    const SizedBox(width: 4),
                                    Text(FormatUtils.formatTimeAgo(podcast.createdDay)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.more_vert),
                            onPressed: () {},
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
