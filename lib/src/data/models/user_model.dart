import 'package:simple_register_app/src/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    super.id,
    required super.name,
    required super.email,
    required super.password,
    super.pictureImagePath,
    required super.createdAt,
    required super.updatedAt,
  });

  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      id: data['id']?.toInt(),
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      password: data['password'] ?? '',
      pictureImagePath: data['picture_image_path'],
      createdAt: DateTime.parse(data['created_at']),
      updatedAt: DateTime.parse(data['updated_at']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'email': email,
      'password': password,
      if (pictureImagePath != null) 'picture_image_path': pictureImagePath,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      name: entity.name,
      email: entity.email,
      password: entity.password,
      pictureImagePath: entity.pictureImagePath,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  UserEntity toEntity() {
    return UserEntity(
      id: id,
      name: name,
      email: email,
      password: password,
      pictureImagePath: pictureImagePath,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  @override
  UserModel copyWith({
    int? id,
    String? name,
    String? email,
    String? password,
    String? pictureImagePath,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      pictureImagePath: pictureImagePath ?? this.pictureImagePath,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
