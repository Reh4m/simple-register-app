import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final int? id;
  final String name;
  final String email;
  final String password;
  final String? pictureImagePath;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserEntity({
    this.id,
    required this.name,
    required this.email,
    required this.password,
    this.pictureImagePath,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [id, name, email, password];

  String get initials {
    final nameParts = name.split(' ');

    if (nameParts.length >= 2) {
      return '${nameParts[0][0]}${nameParts[1][0]}'.toUpperCase();
    }

    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  bool get hasPicture =>
      pictureImagePath != null && pictureImagePath!.isNotEmpty;

  UserEntity copyWith({
    int? id,
    String? name,
    String? email,
    String? password,
    String? pictureImagePath,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserEntity(
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
