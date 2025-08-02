// src/domain/models/auth_response_register_new.dart


import 'package:syncronize/src/domain/models/user_register_new.dart';

class AuthResponseRegisterNew {
  final UserRegisterNew user;
  final String? message;

  AuthResponseRegisterNew({
    required this.user,
    this.message,
  });

  factory AuthResponseRegisterNew.fromJson(Map<String, dynamic> json) => AuthResponseRegisterNew(
        user: UserRegisterNew.fromJson(json["user"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "user": user.toJson(),
        "message": message,
      };
}