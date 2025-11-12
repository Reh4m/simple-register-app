import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:simple_register_app/src/presentation/providers/auth_provider.dart';

FutureOr<String?> authGuard(BuildContext context, GoRouterState state) {
  final authProvider = context.read<AuthProvider>();
  final user = authProvider.currentUser;

  final isAuthenticated = user != null;
  final hasPicture = user?.hasPicture ?? false;
  final authStatus = authProvider.status;

  final currentLocation = state.uri.path;

  final isSplash = currentLocation == '/splash';
  final isSignIn = currentLocation == '/signin';
  final isSignUp = currentLocation == '/signup';
  final isAuthPage = isSignIn || isSignUp;
  final isHome = currentLocation == '/home';
  final isAvatarSelector = currentLocation == '/avatar-selector';

  if (authStatus == AuthStatus.initial ||
      (authStatus == AuthStatus.loading && !authProvider.isInitialized)) {
    return isSplash ? null : '/splash';
  }

  if (isAuthenticated && !hasPicture && !isAvatarSelector) {
    return '/avatar-selector';
  }

  if (isAuthenticated) {
    if (isSplash || isAuthPage) return '/home';

    if (!authProvider.checkSessionValidity()) {
      authProvider.signOut();
      return '/signin';
    }

    return null;
  }

  if (!isAuthenticated) {
    if (isHome || isSplash) return '/signin';

    if (isAuthPage) return null;
  }

  if (authStatus == AuthStatus.error && !isAuthPage && !isSplash) {
    return '/signin';
  }

  return null;
}
