import 'package:flutter/material.dart';
import 'package:castify_studio/common/widgets/common_sliver_app_bar.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (_, __) => const [
        CommonSliverAppBar(),
      ],
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (_, index) => ListTile(title: Text('Chat item $index')),
      ),
    );
  }
}
