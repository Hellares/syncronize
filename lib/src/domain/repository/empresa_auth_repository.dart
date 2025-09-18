// import 'package:syncronize/src/domain/models/auth_response.dart';
// import 'package:syncronize/src/domain/utils/resource.dart';

// abstract class EmpresaAuthRepository {
  
//   /// Autentica al usuario con una empresa específica
//   Future<Resource<AuthResponse>> loginToEmpresa(String userToken, String empresaId);
  
//   /// Valida si el token de empresa sigue siendo válido
//   Future<Resource<bool>> validateEmpresaToken(String empresaToken);
  
//   /// Cierra la sesión de empresa
//   Future<Resource<bool>> logoutFromEmpresa(String empresaToken);
  
//   /// Guarda la sesión de empresa (token + datos de empresa)
//   Future<void> saveEmpresaSession(AuthResponse authResponse, String empresaId);
  
//   /// Obtiene la sesión de empresa guardada
//   Future<AuthResponse?> getEmpresaSession();
  
//   /// Obtiene el ID de la empresa actualmente seleccionada
//   Future<String?> getSelectedEmpresaId();
  
//   /// Limpia la sesión de empresa
//   Future<void> clearEmpresaSession();
// }