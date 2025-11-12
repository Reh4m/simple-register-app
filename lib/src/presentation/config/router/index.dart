import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:simple_register_app/src/presentation/config/router/auth_guard.dart'
    show authGuard;
import 'package:simple_register_app/src/presentation/providers/auth_provider.dart';
import 'package:simple_register_app/src/presentation/screens/auth/avatar_selector_screen.dart';
import 'package:simple_register_app/src/presentation/screens/auth/sign_in_screen.dart';
import 'package:simple_register_app/src/presentation/screens/auth/sign_up_screen.dart';
import 'package:simple_register_app/src/presentation/screens/home/index.dart';
import 'package:simple_register_app/src/presentation/screens/splash_screen.dart';

class AppRouter {
  static const String splash = '/splash';
  static const String signin = '/signin';
  static const String signup = '/signup';
  static const String avatar_selector = '/avatar-selector';
  static const String home = '/home';

  static GoRouter router(BuildContext context) {
    return GoRouter(
      initialLocation: splash,
      redirect: authGuard,
      refreshListenable: context.read<AuthProvider>(),
      routes: [
        GoRoute(
          path: splash,
          name: 'splash',
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: signin,
          name: 'signin',
          builder: (context, state) => const SignInScreen(),
        ),
        GoRoute(
          path: signup,
          name: 'signup',
          builder: (context, state) => const SignUpScreen(),
        ),
        GoRoute(
          path: avatar_selector,
          name: 'avatar_selector',
          builder: (context, state) => const AvatarSelectorScreen(),
        ),
        GoRoute(
          path: home,
          name: 'home',
          builder: (context, state) => const HomeScreen(),
        ),
      ],
    );
  }
}
