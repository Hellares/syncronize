import 'package:dio/dio.dart';
import 'package:syncronize/src/domain/models/empresa_user_roles_response.dart';
import 'package:syncronize/src/domain/utils/resource.dart';

class EmpresaUserRolesService {

  late Dio _dio;

  EmpresaUserRolesService(){
    _dio = Dio(BaseOptions(
      baseUrl:'http://192.168.100.3:3000',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ));
  }


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
