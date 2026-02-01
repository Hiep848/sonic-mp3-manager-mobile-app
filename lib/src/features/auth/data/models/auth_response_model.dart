import '../../domain/entities/user_entity.dart';

class AuthResponseModel {
  final String accessToken;
  final UserEntity user;

  AuthResponseModel({required this.accessToken, required this.user});

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      accessToken: json['accessToken'] as String,
      user: UserEntity.fromJson(json['user'] as Map<String, dynamic>),
    );
  }
}
