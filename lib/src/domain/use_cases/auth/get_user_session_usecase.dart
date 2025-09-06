


import 'package:syncronize/src/domain/models/auth_empresa_response.dart';
import 'package:syncronize/src/domain/repository/auth_repository.dart';

class GetUserSessionUseCase{
  AuthRepository authRepository;

  GetUserSessionUseCase(this.authRepository);

  Future<AuthEmpresaResponse?> run() => authRepository.getUserSession();
}