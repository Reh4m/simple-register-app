import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:simple_register_app/src/presentation/providers/auth_provider.dart';

FutureOr<String?> authGuard(BuildContext context, GoRouterState state) {
  final authProvider = context.read<AuthProvider>();
  final isAuthenticated = authProvider.isAuthenticated;

  final publicRoutes = ['/signin', '/signup'];
  final isPublicRoute = publicRoutes.contains(state.uri.path);

  // If the user is not authenticated and trying to access a protected route, redirect to sign-in
  if (!isAuthenticated && !isPublicRoute) {
    return '/signin';
  }

  // If the user is authenticated and trying to access a public route, redirect to home
  if (isAuthenticated && isPublicRoute) {
    return '/home';
  }

  // No redirection needed
  return null;
}
