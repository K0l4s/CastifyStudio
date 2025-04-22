import 'package:castify_studio/common/widgets/common_sliver_app_bar.dart';
import 'package:flutter/material.dart';

class UploadScreen extends StatelessWidget {
  const UploadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (_, __) => const [
        CommonSliverAppBar(),
      ],
      body: const Center(child: Text("Tạo nội dung mới")),
    );
  }
}
