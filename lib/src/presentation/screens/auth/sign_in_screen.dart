import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';
import 'package:simple_register_app/src/core/utils/validators.dart';
import 'package:simple_register_app/src/domain/entities/sign_in_entity.dart';
import 'package:simple_register_app/src/presentation/providers/auth_provider.dart';
import 'package:simple_register_app/src/presentation/utils/toast_notification.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _signInFormKey = GlobalKey<FormState>();
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();

  bool _isPasswordVisible = false;

  Future<void> _handleSignIn() async {
    if (_signInFormKey.currentState?.validate() ?? false) {
      final authProvider = context.read<AuthProvider>();

      final signInData = SignInEntity(
        email: _emailTextController.text.trim(),
        password: _passwordTextController.text.trim(),
      );

      await authProvider.signIn(signInData);

      if (!context.mounted) return;

      switch (authProvider.status) {
        case AuthStatus.authenticated:
          context.goNamed('home');
        case AuthStatus.error:
          _showErrorToastification(
            title: 'Sign In Failed',
            description:
                authProvider.errorMessage ?? 'An unknown error occurred.',
            type: ToastNotificationType.error,
          );
          break;
        default:
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
    _emailTextController.dispose();
    _passwordTextController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              _buildHeader(),
              const SizedBox(height: 20.0),
              _buildSignInForm(),
              const SizedBox(height: 20.0),
              _buildSignUpPrompt(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const Text(
      'Welcome Back!',
      style: TextStyle(fontSize: 34.0, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildSignInForm() {
    return Form(
      key: _signInFormKey,
      child: Consumer<AuthProvider>(
        builder: (_, authProvider, child) {
          final isLoading = authProvider.isLoading;

          return Column(
            children: <Widget>[
              _buildEmailField(isLoading),
              const SizedBox(height: 20.0),
              _buildPasswordField(isLoading),
              const SizedBox(height: 20.0),
              _buildSignInButton(isLoading),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmailField(bool isLoading) {
    return TextFormField(
      controller: _emailTextController,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
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
      keyboardType: TextInputType.visiblePassword,
      textInputAction: TextInputAction.done,
      obscureText: !_isPasswordVisible,
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

  Widget _buildSignInButton(bool isLoading) {
    return FilledButton(
      onPressed: !isLoading ? _handleSignIn : null,
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
                    'Sign In',
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

  Widget _buildSignUpPrompt() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Don\'t have an account?'),
        TextButton(
          onPressed: () => context.goNamed('signup'),
          child: const Text('Sign Up'),
        ),
      ],
    );
  }
}
