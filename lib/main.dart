import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_register_app/src/core/di/index.dart' as di;
import 'package:simple_register_app/src/presentation/config/router/index.dart';
import 'package:simple_register_app/src/presentation/providers/auth_provider.dart';
import 'package:simple_register_app/src/presentation/providers/image_picker_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Dependency injection setup
  await di.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) {
            final authProvider = AuthProvider();

            authProvider.initialize();

            return authProvider;
          },
        ),
        ChangeNotifierProvider(create: (_) => ImagePickerProvider()),
      ],
      child: const MyApp(),
    ),
  );
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
