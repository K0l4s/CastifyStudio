import 'package:flutter/material.dart';
import 'package:castify_studio/common/widgets/common_sliver_app_bar.dart';

class ContentScreen extends StatelessWidget {
  const ContentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (_, __) => [
        CommonSliverAppBar(
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                // TODO: implement search
              },
            ),
          ],
        ),
      ],
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (_, index) => ListTile(title: Text('Content item $index')),
      ),
    );
  }
}
