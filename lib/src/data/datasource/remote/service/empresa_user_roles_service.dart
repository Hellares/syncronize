import 'package:dio/dio.dart';
import 'package:syncronize/src/data/api/dio_config.dart'; // ✅ Importar DioConfig
import 'package:syncronize/src/domain/models/empresa_user_roles_response.dart';
import 'package:syncronize/src/domain/utils/resource.dart';

class EmpresaUserRolesService {
  final Dio _dio;

  // ✅ FIX: Usar DioConfig en lugar de hardcodear URL
  EmpresaUserRolesService() : _dio = DioConfig.instance;

  Future<Resource<EmpresaUserRolesResponse>> getUserEmpresasRoles(String token) async {
    try {
      final response = await _dio.get(
        '/api/users/me/empresas',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        final empresasResponse = EmpresaUserRolesResponse.fromJson(response.data);
        return Success(empresasResponse);
      } else {
        return Error('Error ${response.statusCode}: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      String errorMessage = 'Error de conexión';
      
      if (e.type == DioExceptionType.connectionTimeout) {
        errorMessage = 'Tiempo de conexión agotado';
      } else if (e.type == DioExceptionType.receiveTimeout) {
        errorMessage = 'Tiempo de respuesta agotado';
      } else if (e.response != null) {
        errorMessage = 'Error ${e.response?.statusCode}: ${e.response?.statusMessage}';
      }
      
      return Error(errorMessage);
    } catch (e) {
      return Error('Error inesperado: $e');
    }
  }
}
