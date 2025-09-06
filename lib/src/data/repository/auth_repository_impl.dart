
import 'package:syncronize/src/data/datasource/local/shared_preference.dart';
import 'package:syncronize/src/data/datasource/remote/service/auth_service.dart';
import 'package:syncronize/src/domain/models/auth_empresa_response.dart';
import 'package:syncronize/src/domain/models/auth_response_register_new.dart';
import 'package:syncronize/src/domain/models/user_register_new.dart';
import 'package:syncronize/src/domain/repository/auth_repository.dart';
import 'package:syncronize/src/domain/utils/resource.dart';



class AuthRepositoryImpl implements AuthRepository {

  AuthService authService;
  SharedPref sharedPref;
  AuthRepositoryImpl(this.authService, this.sharedPref);

  @override
  Future<Resource<AuthEmpresaResponse>> login(String dni, String password) {
    return authService.login(dni, password);
  }

  @override
  Future<Resource<AuthResponseRegisterNew>> register(UserRegisterNew user) {

    return authService.register(user);
  }
  
  @override
  Future<AuthEmpresaResponse?> getUserSession() async {
    final data = await sharedPref.read('user');
      if(data != null){
        AuthEmpresaResponse authResponse = AuthEmpresaResponse.fromJson(await sharedPref.read('user'));
        return authResponse;
      } 
    return null;
  }
  
  @override
  Future<void> saveUserSession(AuthEmpresaResponse authResponse) async {
    sharedPref.save('user', authResponse.toJson());
  }
  
  @override
  Future<void> logout() {
    // TODO: implement logout
    throw UnimplementedError();
  }
  
  

}