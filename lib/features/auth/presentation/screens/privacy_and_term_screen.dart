import 'package:flutter/material.dart';

class PrivacyAndTermsScreen extends StatelessWidget {
  const PrivacyAndTermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy & Terms'),
        backgroundColor: Colors.grey.shade200,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              '📜 Chính sách Bảo mật (Privacy Policy)',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Cập nhật lần cuối: 12/05/2025'),

            SizedBox(height: 16),
            Text(
              '1. Thông tin chúng tôi thu thập:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('- Họ tên, email, ảnh đại diện, mật khẩu.'),
            Text('- Tập podcast, bình luận, lượt thích, đánh giá.'),
            Text('- IP, thiết bị, hệ điều hành, cookie...'),

            SizedBox(height: 12),
            Text(
              '2. Cách chúng tôi sử dụng thông tin:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('- Cung cấp và cải thiện dịch vụ podcast.'),
            Text('- Cá nhân hóa trải nghiệm người dùng.'),
            Text('- Gửi thông báo tài khoản và bản cập nhật.'),

            SizedBox(height: 12),
            Text(
              '3. Chia sẻ thông tin:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('- Không bán thông tin cá nhân.'),
            Text('- Chỉ chia sẻ nếu có sự đồng ý hoặc yêu cầu pháp lý.'),

            SizedBox(height: 12),
            Text(
              '4. Quyền của người dùng:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('- Truy cập, chỉnh sửa hoặc xóa dữ liệu cá nhân.'),
            Text('- Vô hiệu hóa tài khoản bất cứ lúc nào.'),

            SizedBox(height: 12),
            Text(
              '5. Bảo mật dữ liệu:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('- Mã hóa, xác thực hai lớp, sao lưu định kỳ.'),

            SizedBox(height: 12),
            Text(
              '6. Dữ liệu trẻ em:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('- Không dành cho người dưới 13 tuổi.'),

            SizedBox(height: 24),
            Divider(),
            SizedBox(height: 16),

            Text(
              '📄 Điều khoản Sử dụng (Terms of Service)',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Cập nhật lần cuối: 12/05/2025'),

            SizedBox(height: 16),
            Text(
              '1. Tài khoản người dùng:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('- Chịu trách nhiệm thông tin đăng nhập.'),
            Text('- Không mạo danh hoặc chia sẻ tài khoản.'),

            SizedBox(height: 12),
            Text(
              '2. Nội dung người dùng tạo:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('- Bạn giữ bản quyền podcast.'),
            Text('- Cấp quyền hiển thị nội dung cho Castify.'),

            SizedBox(height: 12),
            Text(
              '3. Hành vi bị nghiêm cấm:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('- Nội dung vi phạm pháp luật, spam, giả mạo...'),

            SizedBox(height: 12),
            Text(
              '4. Quyền của Castify:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('- Có thể xóa nội dung, khóa tài khoản vi phạm.'),

            SizedBox(height: 12),
            Text(
              '5. Giới hạn trách nhiệm:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('- Castify không chịu trách nhiệm nội dung người dùng.'),

            SizedBox(height: 12),
            Text(
              '6. Luật áp dụng:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('- Theo pháp luật Việt Nam.'),

            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
