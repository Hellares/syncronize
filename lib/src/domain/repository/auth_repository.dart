import 'package:syncronize/src/domain/models/auth_response.dart';
import 'package:syncronize/src/domain/models/auth_response_register_new.dart';
import 'package:syncronize/src/domain/models/user_register_new.dart';
import 'package:syncronize/src/domain/utils/resource.dart';

abstract class AuthRepository {

  // Future<AuthResponse?> getUserSession(); 
  // Future<bool> logout(); 
  // Future<void> saveUserSession(AuthResponse authResponse);
  Future<Resource<AuthResponse>> login(String dni, String password);
  Future<Resource<AuthResponseRegisterNew>> register(UserRegisterNew user);

}