
import 'package:syncronize/src/data/datasource/remote/service/auth_service.dart';
import 'package:syncronize/src/domain/models/auth_response.dart';
import 'package:syncronize/src/domain/models/user.dart';
import 'package:syncronize/src/domain/repository/auth_repository.dart';
import 'package:syncronize/src/domain/utils/resource.dart';



class AuthRepositoryImpl implements AuthRepository {

  AuthService authService;
  AuthRepositoryImpl(this.authService);

  @override
  Future<Resource<AuthResponse>> login(String dni, String password) {
    return authService.login(dni, password);
  }

  @override
  Future<Resource<AuthResponse>> register(User user) {

    throw UnimplementedError();
  }
  
  

}