import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';
import 'package:simple_register_app/src/presentation/providers/auth_provider.dart';
import 'package:simple_register_app/src/presentation/utils/custom_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('Confirm Logout'),
          content: const Text('Are you sure you want to log out?'),
          actions: [
            CustomButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                context.read<AuthProvider>().signOut();
              },
              text: 'Log Out',
              variant: ButtonVariant.primary,
              width: double.infinity,
            ),
            const SizedBox(height: 10),
            CustomButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              text: 'Cancel',
              variant: ButtonVariant.outline,
              width: double.infinity,
            ),
          ],
        );
      },
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
              final user = authProvider.currentUser;
              final isLoading = authProvider.isLoading;

              return Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('Profile', style: theme.textTheme.headlineLarge),
                    const SizedBox(height: 20),
                    _buildProfileAvatar(user?.pictureImagePath),
                    const SizedBox(height: 20),
                    _buildUserName(user?.name, theme),
                    const SizedBox(height: 10),
                    _buildUserEmail(user?.email, theme),
                    const SizedBox(height: 20),
                    _buildLogoutButton(context, isLoading: isLoading),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildProfileAvatar(String? pictureImagePath) {
    return CircleAvatar(
      radius: 60,
      backgroundImage:
          pictureImagePath != null
              ? _getAvatarImageProvider(pictureImagePath)
              : null,
      child:
          pictureImagePath == null ? const Icon(Icons.person, size: 60) : null,
    );
  }

  Widget _buildUserName(String? name, ThemeData theme) {
    return Text(name ?? 'No Username', style: theme.textTheme.headlineMedium);
  }

  Widget _buildUserEmail(String? email, ThemeData theme) {
    return Text(email ?? 'No Email', style: theme.textTheme.bodyLarge);
  }

  Widget _buildLogoutButton(BuildContext context, {required bool isLoading}) {
    return CustomButton(
      onPressed:
          !isLoading ? () => _showLogoutConfirmationDialog(context) : null,
      text: 'Log Out',
      variant: ButtonVariant.primary,
      width: double.infinity,
      icon: const HugeIcon(
        icon: HugeIcons.strokeRoundedLogout01,
        color: Colors.white,
        size: 18,
        strokeWidth: 2.5,
      ),
      iconPosition: ButtonIconPosition.right,
    );
  }

  ImageProvider _getAvatarImageProvider(String imagePath) {
    if (imagePath.startsWith('assets://')) {
      final assetPath = imagePath.replaceFirst('assets://', '');
      return AssetImage(assetPath);
    } else {
      final filePath = imagePath.replaceFirst('file://', '');
      return FileImage(File(filePath));
    }
  }
}
