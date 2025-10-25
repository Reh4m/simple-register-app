import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:simple_register_app/src/core/utils/validators.dart';
import 'package:simple_register_app/src/domain/entities/sign_up_entity.dart';
import 'package:simple_register_app/src/presentation/providers/auth_provider.dart';
import 'package:simple_register_app/src/presentation/utils/toast_notification.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _signUpFormKey = GlobalKey<FormState>();
  final _fullNameTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final _confirmPasswordTextController = TextEditingController();

  File? _selectedProfileImage;

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  Future<void> _pickProfileImage() async {
    try {
      final pickedImage = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );

      if (pickedImage == null) return;

      setState(() => _selectedProfileImage = File(pickedImage.path));
    } on PlatformException catch (e) {
      _showErrorToastification(
        title: 'Image Selection Failed',
        description: 'Error picking image: ${e.message}',
        type: ToastNotificationType.error,
      );
    }
  }

  Future<void> _handleSignUp() async {
    if (_signUpFormKey.currentState?.validate() ?? false) {
      final authProvider = context.read<AuthProvider>();

      final signInData = SignUpEntity(
        name: _fullNameTextController.text.trim(),
        email: _emailTextController.text.trim(),
        password: _passwordTextController.text.trim(),
        confirmPassword: _confirmPasswordTextController.text.trim(),
      );

      await authProvider.signUp(signInData);

      if (!context.mounted) return;

      switch (authProvider.status) {
        case AuthStatus.authenticated:
          context.goNamed('home');
        case AuthStatus.error:
          _showErrorToastification(
            title: 'Sign Up Failed',
            description:
                authProvider.errorMessage ?? 'An unknown error occurred',
            type: ToastNotificationType.error,
          );
          break;
        default:
          // Do nothing
          break;
      }
    }
  }

  void _showErrorToastification({
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
  void dispose() {
    _fullNameTextController.dispose();
    _emailTextController.dispose();
    _passwordTextController.dispose();
    _confirmPasswordTextController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          dragStartBehavior: DragStartBehavior.down,
          child: Container(
            padding: const EdgeInsets.all(20.0),
            height:
                MediaQuery.of(context).size.height -
                MediaQuery.of(context).padding.top,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildHeader(),
                const SizedBox(height: 20.0),
                _buildSignUpForm(theme),
                const SizedBox(height: 20.0),
                _buildSignInPrompt(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const Column(
      children: [
        Text(
          'Create an Account',
          style: TextStyle(fontSize: 34.0, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 5.0),
        Text('Sign up to get started', style: TextStyle(fontSize: 18.0)),
      ],
    );
  }

  Widget _buildSignUpForm(ThemeData theme) {
    return Form(
      key: _signUpFormKey,
      child: Consumer<AuthProvider>(
        builder: (_, authProvider, child) {
          final isLoading = authProvider.isLoading;

          return Column(
            children: [
              _buildProfileImagePicker(theme, isLoading),
              const SizedBox(height: 20.0),
              _buildFullNameField(isLoading),
              const SizedBox(height: 20.0),
              _buildEmailField(isLoading),
              const SizedBox(height: 20.0),
              _buildPasswordField(isLoading),
              const SizedBox(height: 20.0),
              _buildConfirmPasswordField(isLoading),
              const SizedBox(height: 20.0),
              _buildSignUpButton(isLoading),
            ],
          );
        },
      ),
    );
  }

  Widget _buildProfileImagePicker(ThemeData theme, bool isLoading) {
    return InkWell(
      onTap: !isLoading ? _pickProfileImage : null,
      borderRadius: BorderRadius.circular(50.0),
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Container(
            width: 100.0,
            height: 100.0,
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              image:
                  _selectedProfileImage != null
                      ? DecorationImage(
                        image: FileImage(_selectedProfileImage!),
                        fit: BoxFit.cover,
                      )
                      : null,
              borderRadius: BorderRadius.circular(50.0),
            ),
            child:
                _selectedProfileImage == null
                    ? Icon(
                      Icons.camera_alt_outlined,
                      size: 40.0,
                      color: theme.colorScheme.onSurface,
                    )
                    : null,
          ),
          Container(
            width: 30.0,
            height: 30.0,
            decoration: BoxDecoration(
              color: theme.primaryColor,
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Icon(
              Icons.add,
              size: 20.0,
              color: theme.colorScheme.onPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFullNameField(bool isLoading) {
    return TextFormField(
      controller: _fullNameTextController,
      keyboardType: TextInputType.name,
      decoration: const InputDecoration(labelText: 'Full Name'),
      validator:
          (value) =>
              value == null || value.isEmpty ? 'Full Name is required' : null,
      enabled: !isLoading,
    );
  }

  Widget _buildEmailField(bool isLoading) {
    return TextFormField(
      controller: _emailTextController,
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(labelText: 'Email'),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Email is required';
        }
        if (!Validators.isValidEmail(value)) {
          return 'Please enter a valid email';
        }
        return null;
      },
      enabled: !isLoading,
    );
  }

  Widget _buildPasswordField(bool isLoading) {
    return TextFormField(
      controller: _passwordTextController,
      obscureText: !_isPasswordVisible,
      keyboardType: TextInputType.visiblePassword,
      decoration: InputDecoration(
        labelText: 'Password',
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
          ),
          onPressed:
              () => setState(() => _isPasswordVisible = !_isPasswordVisible),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Password is required';
        }
        if (value.length < 6) {
          return 'Password must be at least 6 characters';
        }
        return null;
      },
      enabled: !isLoading,
    );
  }

  Widget _buildConfirmPasswordField(bool isLoading) {
    return TextFormField(
      controller: _confirmPasswordTextController,
      obscureText: !_isConfirmPasswordVisible,
      keyboardType: TextInputType.visiblePassword,
      decoration: InputDecoration(
        labelText: 'Confirm Password',
        suffixIcon: IconButton(
          icon: Icon(
            _isConfirmPasswordVisible
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
          ),
          onPressed:
              () => setState(
                () => _isConfirmPasswordVisible = !_isConfirmPasswordVisible,
              ),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Confirm Password is required';
        }
        if (_passwordTextController.text != value) {
          return 'Passwords do not match';
        }
        return null;
      },
      enabled: !isLoading,
    );
  }

  Widget _buildSignUpButton(bool isLoading) {
    return FilledButton(
      onPressed: !isLoading ? _handleSignUp : null,
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
                    'Sign Up',
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

  Widget _buildSignInPrompt() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Already have an account?'),
        TextButton(
          onPressed: () => context.goNamed('signin'),
          child: const Text('Sign In'),
        ),
      ],
    );
  }
}
