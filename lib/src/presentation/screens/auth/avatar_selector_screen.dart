import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:simple_register_app/src/presentation/providers/auth_provider.dart';
import 'package:simple_register_app/src/presentation/utils/toast_notification.dart';

class AvatarSelectorScreen extends StatefulWidget {
  const AvatarSelectorScreen({super.key});

  @override
  State<AvatarSelectorScreen> createState() => _AvatarSelectorScreenState();
}

class _AvatarSelectorScreenState extends State<AvatarSelectorScreen> {
  String _selectedAvatarFileName = 'avatar_1.jpg';
  File? _customProfileImage;
  bool _isCustomImageSelected = false;

  Future<void> _pickCustomImage() async {
    try {
      final pickedImage = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (pickedImage == null) return;

      setState(() {
        _customProfileImage = File(pickedImage.path);
        _isCustomImageSelected = true;
      });
    } on PlatformException catch (e) {
      _showToast(
        title: 'Error',
        description: 'Failed to pick image: ${e.message}',
        type: ToastNotificationType.error,
      );
    }
  }

  void _selectAvatar(String avatarFileName) {
    setState(() {
      _selectedAvatarFileName = avatarFileName;
      _isCustomImageSelected = false;
      _customProfileImage = null;
    });
  }

  Future<void> _saveSelectedAvatar() async {
    final authProvider = context.read<AuthProvider>();

    final imagePath =
        _isCustomImageSelected
            ? 'file://${_customProfileImage!.path}'
            : 'assets://assets/images/avatars/$_selectedAvatarFileName';
    await authProvider.setUserPicturePath(imagePath);

    if (!context.mounted) return;

    switch (authProvider.status) {
      case AuthStatus.authenticated:
        context.goNamed('home');
        break;
      case AuthStatus.error:
        _showToast(
          title: 'Error',
          description:
              authProvider.errorMessage ?? 'An unknown error occurred.',
          type: ToastNotificationType.error,
        );
        break;
      default:
        break;
    }
  }

  void _showToast({
    required String title,
    required String description,
    required ToastNotificationType type,
  }) {
    ToastNotification.show(
      context,
      title: title,
      description: description,
      type: type,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Consumer<AuthProvider>(
            builder: (_, authProvider, __) {
              final isLoading = authProvider.isLoading;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(height: 20),
                  _buildHeader(theme),
                  const SizedBox(height: 20),
                  _buildAvatarPreview(),
                  const SizedBox(height: 20),
                  _buildAvatarGrid(),
                  const SizedBox(height: 20),
                  _buildContinueButton(isLoading: isLoading),
                  const SizedBox(height: 20),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Center(
      child: Text('Select Your Avatar', style: theme.textTheme.headlineLarge),
    );
  }

  Widget _buildAvatarPreview() {
    final imageProvider =
        _isCustomImageSelected
            ? FileImage(_customProfileImage!)
            : AssetImage('assets/images/avatars/$_selectedAvatarFileName')
                as ImageProvider;

    return Center(
      child: Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
        ),
      ),
    );
  }

  Widget _buildAvatarGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 15,
        crossAxisSpacing: 15,
        childAspectRatio: 1.0,
      ),
      itemCount: 9,
      itemBuilder: (_, index) {
        return index == 0
            ? _buildAddCustomImageButton()
            : _buildAvatarOption(index);
      },
    );
  }

  Widget _buildAvatarOption(int index) {
    final avatarName = 'avatar_$index.jpg';
    final isSelected =
        !_isCustomImageSelected && _selectedAvatarFileName == avatarName;

    return InkWell(
      onTap: () => _selectAvatar(avatarName),
      borderRadius: BorderRadius.circular(50.0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage('assets/images/avatars/$avatarName'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          _animatedCheckIcon(isVisible: isSelected),
        ],
      ),
    );
  }

  Widget _buildAddCustomImageButton() {
    final isSelected = _isCustomImageSelected;

    return InkWell(
      onTap: _pickCustomImage,
      borderRadius: BorderRadius.circular(50.0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFdee2e6),
              borderRadius: BorderRadius.circular(50.0),
            ),
            child: const Center(
              child: HugeIcon(
                icon: HugeIcons.strokeRoundedImageAdd02,
                color: Color(0xFF495057),
                size: 46,
                strokeWidth: 2.5,
              ),
            ),
          ),
          _animatedCheckIcon(isVisible: isSelected),
        ],
      ),
    );
  }

  Widget _buildContinueButton({required bool isLoading}) {
    return FilledButton(
      onPressed: !isLoading ? _saveSelectedAvatar : null,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        minimumSize: const Size(double.infinity, 0),
      ),
      child:
          isLoading
              ? const SizedBox(
                height: 21.0,
                width: 21.0,
                child: CircularProgressIndicator(strokeWidth: 3.0),
              )
              : const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Continue',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(width: 10),
                  HugeIcon(
                    icon: HugeIcons.strokeRoundedArrowRight02,
                    color: Colors.white,
                    size: 18,
                    strokeWidth: 2.5,
                  ),
                ],
              ),
    );
  }

  Widget _animatedCheckIcon({required bool isVisible}) {
    return Positioned(
      top: 4,
      right: 6,
      child: AnimatedScale(
        scale: isVisible ? 1 : 0,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutBack,
        child: AnimatedOpacity(
          opacity: isVisible ? 1 : 0,
          duration: const Duration(milliseconds: 250),
          child: Container(
            decoration: const BoxDecoration(
              color: Color(0xFFff6b6b),
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(4),
            child: const HugeIcon(
              icon: HugeIcons.strokeRoundedCheckmarkBadge04,
              color: Colors.white,
              size: 16,
              strokeWidth: 2.5,
            ),
          ),
        ),
      ),
    );
  }
}
