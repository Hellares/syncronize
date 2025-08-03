import 'package:syncronize/src/domain/models/auth_response.dart';
import 'package:syncronize/src/domain/repository/auth_repository.dart';
import 'package:syncronize/src/domain/utils/resource.dart';



class LoginUseCase {

  AuthRepository repository;
  LoginUseCase(this.repository);


  // run(String dni, String password) => repository.login(dni, password);
  //o
  Future<Resource<AuthResponse>> run(String dni, String password) => repository.login(dni, password);

}