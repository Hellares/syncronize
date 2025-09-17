import 'package:syncronize/src/domain/repository/empresa_auth_repository.dart';

class ClearEmpresaSessionUseCase {
  final EmpresaAuthRepository empresaAuthRepository;

  ClearEmpresaSessionUseCase(this.empresaAuthRepository);

  Future<void> run() {
    return empresaAuthRepository.clearEmpresaSession();
  }
}