import 'package:flutter/material.dart';
import 'package:simple_register_app/src/core/di/index.dart' as di;
import 'package:simple_register_app/src/presentation/config/router/index.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Dependency injection setup
  await di.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Simple Register App',
      routerConfig: AppRouter.router(),
    );
  }
}
