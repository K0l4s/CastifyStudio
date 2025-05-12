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
  bool _isUploading = false;
  final _userService = UserService();

  late TextEditingController _firstNameController;
  late TextEditingController _middleNameController;
  late TextEditingController _lastNameController;

  @override
  void initState() {
    super.initState();
    final user = Provider.of<UserProvider>(context, listen: false).user;
    _firstNameController = TextEditingController(text: user?.firstName ?? '');
    _middleNameController = TextEditingController(text: user?.middleName ?? '');
    _lastNameController = TextEditingController(text: user?.lastName ?? '');
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _middleNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

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

  Future<void> _saveProfile() async {
    setState(() {
      _isUploading = true;
    });

    try {
      final currentUser = Provider.of<UserProvider>(context, listen: false).user;
      final updatedUser = await _userService.updateUserInfo(
        firstName: _firstNameController.text.trim() != currentUser?.firstName ? _firstNameController.text.trim() : currentUser?.firstName ?? '',
        middleName: _middleNameController.text.trim() != currentUser?.middleName ? _middleNameController.text.trim() : currentUser?.middleName ?? '',
        lastName: _lastNameController.text.trim() != currentUser?.lastName ? _lastNameController.text.trim() : currentUser?.lastName ?? '',
      );

      if (updatedUser != null) {
        final userWithAvatar = updatedUser.avatarUrl == null || updatedUser.avatarUrl!.isEmpty
            ? updatedUser.copyWith(avatarUrl: currentUser?.avatarUrl)
            : updatedUser;

        Provider.of<UserProvider>(context, listen: false).updateUser(userWithAvatar);
        ToastService.showToast('Profile updated successfully!');
        setState(() {
          _isUploading = false;
        });
      } else {
        ToastService.showToast('Failed to update profile');
      }
    } catch (e) {
      ToastService.showToast('Error updating profile');
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;

    if (user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    ImageProvider avatarProvider;
    if (_avatarImage != null) {
      avatarProvider = FileImage(_avatarImage!);
    } else if (user.avatarUrl != null && user.avatarUrl!.isNotEmpty) {
      avatarProvider = NetworkImage(user.avatarUrl!);
    } else {
      avatarProvider = const AssetImage('lib/assets/images/default_avatar.jpg');
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: Colors.grey.shade200,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Center(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: avatarProvider,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 4,
                    child: InkWell(
                      onTap: _isUploading ? null : _pickAvatarImage,
                      child: const CircleAvatar(
                        backgroundColor: Colors.blue,
                        child: Icon(Icons.edit, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            TextFormField(
              controller: _firstNameController,
              decoration: const InputDecoration(labelText: 'First Name'),
            ),
            TextFormField(
              controller: _middleNameController,
              decoration: const InputDecoration(labelText: 'Middle Name'),
            ),
            TextFormField(
              controller: _lastNameController,
              decoration: const InputDecoration(labelText: 'Last Name'),
            ),
            const SizedBox(height: 24),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                padding: EdgeInsets.zero,
              ),
              onPressed: _isUploading ? null : _saveProfile,
              child: Ink(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF2196F3), Color(0xFF21CBF3)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Container(
                  alignment: Alignment.center,
                  height: 50,
                  child: const Text(
                    'Save Changes',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
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
