import 'package:syncronize/src/domain/models/auth_empresa_response.dart';

import 'package:syncronize/src/domain/models/auth_response_register_new.dart';
import 'package:syncronize/src/domain/models/user_register_new.dart';
import 'package:syncronize/src/domain/utils/resource.dart';

abstract class AuthRepository {

  Future<AuthEmpresaResponse?> getUserSession(); 
  Future<bool> logout(); 
  Future<void> saveUserSession(AuthEmpresaResponse authResponse);
  Future<Resource<AuthEmpresaResponse>> login(String dni, String password);
  Future<Resource<AuthResponseRegisterNew>> register(UserRegisterNew user);

}