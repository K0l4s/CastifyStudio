import 'dart:io';
import 'package:castify_studio/features/auth/presentation/provider/user_provider.dart';
import 'package:castify_studio/services/user_service.dart';
import 'package:castify_studio/services/toast_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  File? _avatarImage;
  final _userService = UserService();
  bool _isUploading = false;

  Future<void> _pickAvatarImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _avatarImage = File(picked.path);
        _isUploading = true;
      });

      try {
        await _userService.changeAvatar(_avatarImage!);
        final updatedUser = await _userService.getSelfUserInfo();

        if (updatedUser != null) {
          Provider.of<UserProvider>(context, listen: false).updateUser(updatedUser);
          ToastService.showToast('Avatar updated successfully!');
        }
      } catch (e) {
        ToastService.showToast('Failed to update avatar');
      } finally {
        setState(() {
          _isUploading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: Colors.grey.shade200,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: user == null
            ? const Center(child: CircularProgressIndicator())
            : Column(
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage: _avatarImage != null
                      ? FileImage(_avatarImage!)
                      : (user.avatarUrl != null && user.avatarUrl!.isNotEmpty
                      ? NetworkImage(user.avatarUrl!)
                      : const AssetImage('lib/assets/images/default_avatar.jpg'))
                  as ImageProvider,
                ),
                Positioned(
                  bottom: 0,
                  right: 4,
                  child: InkWell(
                    onTap: _isUploading ? null : _pickAvatarImage,
                    child: CircleAvatar(
                      backgroundColor: Colors.blue,
                      child: const Icon(Icons.edit, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              user.fullname ?? '',
              style: const TextStyle(fontSize: 20),
            ),
            Text(
              '@${user.username}',
              style: TextStyle(color: Colors.grey.shade600),
            ),
            if (_isUploading)
              const Padding(
                padding: EdgeInsets.only(top: 16.0),
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }
}
