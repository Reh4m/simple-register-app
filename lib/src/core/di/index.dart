import 'package:get_it/get_it.dart';
import 'package:simple_register_app/src/data/implements/authentication_repository_impl.dart';
import 'package:simple_register_app/src/data/implements/user_repository_impl.dart';
import 'package:simple_register_app/src/data/sources/local/daos/authentication_dao.dart';
import 'package:simple_register_app/src/data/sources/local/daos/user_dao.dart';
import 'package:simple_register_app/src/data/sources/local/database.dart';
import 'package:simple_register_app/src/domain/repositories/authentication_repository.dart';
import 'package:simple_register_app/src/domain/repositories/user_repository.dart';
import 'package:simple_register_app/src/domain/usecases/authentication_usecases.dart';
import 'package:simple_register_app/src/domain/usecases/user_usecases.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Core
  // - Database Provider
  sl.registerSingleton<DatabaseProvider>(DatabaseProvider());

  // Daos
  // - User Dao
  sl.registerLazySingleton<UserDao>(() => UserDao(sl<DatabaseProvider>()));
  // - Authentication Dao
  sl.registerLazySingleton<AuthenticationDao>(
    () => AuthenticationDao(sl<UserDao>()),
  );

  // Repositories
  // - User Repository
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(sl<UserDao>()),
  );
  // - Authentication Repository
  sl.registerLazySingleton<AuthenticationRepository>(
    () => AuthenticationRepositoryImpl(sl<AuthenticationDao>()),
  );

  // Use Cases
  // - Authentication Use Cases
  sl.registerLazySingleton<SignInUseCase>(
    () => SignInUseCase(sl<AuthenticationRepository>()),
  );
  sl.registerLazySingleton<SignUpUseCase>(
    () => SignUpUseCase(sl<AuthenticationRepository>()),
  );
  // - User Use Cases
  sl.registerLazySingleton<GetUserById>(
    () => GetUserById(sl<UserRepository>()),
  );
  sl.registerLazySingleton<GetUserByEmail>(
    () => GetUserByEmail(sl<UserRepository>()),
  );
}
