import 'package:syncronize/src/domain/models/auth_response.dart';
import 'package:syncronize/src/domain/models/user.dart';
import 'package:syncronize/src/domain/utils/resource.dart';

abstract class AuthRepository {

  // Future<AuthResponse?> getUserSession(); 
  // Future<bool> logout(); 
  // Future<void> saveUserSession(AuthResponse authResponse);
  Future<Resource<AuthResponse>> login(String dni, String password);
  Future<Resource<AuthResponse>> register(User user);

}