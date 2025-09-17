// import 'package:flutter/foundation.dart';
// import 'package:syncronize/src/data/datasource/local/secure_storage.dart';
// import 'package:syncronize/src/data/datasource/remote/service/empresa_auth_service.dart';
// import 'package:syncronize/src/domain/models/auth_response.dart';
// import 'package:syncronize/src/domain/models/user.dart';
// import 'package:syncronize/src/domain/repository/empresa_auth_repository.dart';
// import 'package:syncronize/src/domain/utils/resource.dart';

// class EmpresaAuthRepositoryImpl implements EmpresaAuthRepository {
//   final EmpresaAuthService empresaAuthService;
//   final SecureStorage secureStorage;

//   EmpresaAuthRepositoryImpl(this.empresaAuthService, this.secureStorage);

//   @override
//   Future<Resource<AuthResponse>> loginToEmpresa(String userToken, String empresaId) {
//     return empresaAuthService.loginToEmpresa(userToken, empresaId);
//   }

//   @override
//   Future<Resource<bool>> validateEmpresaToken(String empresaToken) {
//     return empresaAuthService.validateEmpresaToken(empresaToken);
//   }

//   @override
//   Future<Resource<bool>> logoutFromEmpresa(String empresaToken) {
//     return empresaAuthService.logoutFromEmpresa(empresaToken);
//   }

//   @override
//   Future<void> saveEmpresaSession(AuthResponse authResponse, String empresaId) async {
//     try {
//       final sessionData = {
//         'token': authResponse.data.token,
//         'user': authResponse.data.user.toJson(),
//         'empresaId': empresaId,
//       };
//       await secureStorage.save('empresa_session', sessionData);
//       if (kDebugMode) print('Sesión de empresa guardada');
//     } catch (e) {
//       if (kDebugMode) print('Error guardando sesión de empresa: $e');
//       rethrow;
//     }
//   }

//   @override
//   Future<AuthResponse?> getEmpresaSession() async {
//     try {
//       final sessionData = await secureStorage.read('empresa_session');
//       if (sessionData != null) {
//         final user = User.fromJson(sessionData['user']);
//         final token = sessionData['token'] as String;
//         final empresaId = sessionData['empresaId'] as String;
//         final authResponse = AuthResponse(
//           success: true,
//           message: 'Sesión de empresa válida',
//           data: Data(user: user, token: token),
//         );
//         return authResponse;
//       }
//       return null;
//     } catch (e) {
//       if (kDebugMode) print('Error obteniendo sesión de empresa: $e');
//       return null;
//     }
//   }

//   @override
//   Future<String?> getSelectedEmpresaId() async {
//     try {
//       final sessionData = await secureStorage.read('empresa_session');
//       if (sessionData != null) {
//         return sessionData['empresaId'] as String?;
//       }
//       return null;
//     } catch (e) {
//       if (kDebugMode) print('Error obteniendo ID de empresa: $e');
//       return null;
//     }
//   }

//   @override
//   Future<void> clearEmpresaSession() async {
//     try {
//       await secureStorage.remove('empresa_session');
//       if (kDebugMode) print('Sesión de empresa limpiada');
//     } catch (e) {
//       if (kDebugMode) print('Error limpiando sesión de empresa: $e');
//       rethrow;
//     }
//   }
// }