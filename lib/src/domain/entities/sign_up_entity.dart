import 'package:equatable/equatable.dart';

class SignUpEntity extends Equatable {
  final String name;
  final String email;
  final String password;
  final String confirmPassword;
  final String? pictureImagePath;

  const SignUpEntity({
    required this.name,
    required this.email,
    required this.password,
    required this.confirmPassword,
    this.pictureImagePath,
  });

  @override
  List<Object?> get props => [
    name,
    email,
    password,
    confirmPassword,
    pictureImagePath,
  ];

  SignUpEntity copyWith({
    String? name,
    String? email,
    String? password,
    String? confirmPassword,
    String? pictureImagePath,
  }) {
    return SignUpEntity(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      pictureImagePath: pictureImagePath ?? this.pictureImagePath,
    );
  }
}
