import 'package:get_it/get_it.dart';
import 'package:simple_register_app/src/data/sources/local/database.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Database Provider
  sl.registerSingleton<DatabaseProvider>(DatabaseProvider());
}
