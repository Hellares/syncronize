abstract class EmpresaAuthEvent {}

class LoginToEmpresa extends EmpresaAuthEvent {
  final String empresaId;
  
  LoginToEmpresa(this.empresaId);
}

class CheckEmpresaSession extends EmpresaAuthEvent {}

class LogoutFromEmpresa extends EmpresaAuthEvent {}

class LogoutCompleteSession extends EmpresaAuthEvent {}

class ClearEmpresaAuthState extends EmpresaAuthEvent {}