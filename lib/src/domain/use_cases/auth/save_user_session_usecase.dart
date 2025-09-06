

import 'package:syncronize/src/domain/models/auth_empresa_response.dart';
import 'package:syncronize/src/domain/repository/auth_repository.dart';

class SaveUserSessionUseCase{
  AuthRepository authRepository;

  SaveUserSessionUseCase(this.authRepository);

  Future<void> run(AuthEmpresaResponse authResponse) => authRepository.saveUserSession(authResponse);
}