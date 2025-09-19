import 'package:go_router/go_router.dart';
import 'package:simple_register_app/src/presentation/config/router/auth_guard.dart'
    show authGuard;
import 'package:simple_register_app/src/presentation/screens/auth/sign_in_screen.dart';
import 'package:simple_register_app/src/presentation/screens/auth/sign_up_screen.dart';
import 'package:simple_register_app/src/presentation/screens/home/index.dart';

class AppRouter {
  static const String signin = '/signin';
  static const String signup = '/signup';
  static const String home = '/home';

  static GoRouter router() {
    return GoRouter(
      initialLocation: '/signin',
      redirect: authGuard,
      routes: [
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
          path: home,
          name: 'home',
          builder: (context, state) => const HomeScreen(),
        ),
      ],
    );
  }
}
