import 'package:syncronize/src/domain/repository/auth_repository.dart';



class LoginUseCase {

  AuthRepository repository;
  LoginUseCase(this.repository);

  run(String dni, String password) => repository.login(dni, password);

}