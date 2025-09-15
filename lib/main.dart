import 'package:flutter/material.dart';
import 'package:simple_register_app/src/core/di/index.dart' as di;

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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Simple Register App',
    );
  }
}
