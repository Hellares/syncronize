import 'package:syncronize/src/domain/models/auth_response.dart';
import 'package:syncronize/src/domain/repository/empresa_auth_repository.dart';
import 'package:syncronize/src/domain/utils/resource.dart';

class LoginToEmpresaUseCase {
  final EmpresaAuthRepository repository;
  
  LoginToEmpresaUseCase(this.repository);
  
  Future<Resource<AuthResponse>> run(String userToken, String empresaId) {
    return repository.loginToEmpresa(userToken, empresaId);
  }
}