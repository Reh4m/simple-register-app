import 'package:simple_register_app/src/domain/entities/sign_up_entity.dart';

class SignUpModel extends SignUpEntity {
  const SignUpModel({
    required super.name,
    required super.email,
    required super.password,
    required super.confirmPassword,
    super.pictureImagePath,
  });
}
