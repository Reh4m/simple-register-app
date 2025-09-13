class UserTable {
  static const String tableName = 'users';

  static const String idColumn = 'id';
  static const String nameColumn = 'name';
  static const String emailColumn = 'email';
  static const String passwordColumn = 'password';
  static const String pictureImagePathColumn = 'picture_image_path';
  static const String createdAtColumn = 'created_at';
  static const String updatedAtColumn = 'updated_at';

  static const String createTableQuery = '''
    CREATE TABLE $tableName (
      $idColumn INTEGER PRIMARY KEY AUTOINCREMENT,
      $nameColumn TEXT NOT NULL,
      $emailColumn TEXT NOT NULL UNIQUE,
      $passwordColumn TEXT NOT NULL,
      $pictureImagePathColumn TEXT,
      $createdAtColumn TEXT NOT NULL,
      $updatedAtColumn TEXT NOT NULL
    )
  ''';
}
