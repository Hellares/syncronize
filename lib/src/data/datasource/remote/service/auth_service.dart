
import 'dart:convert';
// import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
// import 'package:logger/logger.dart';
import 'package:syncronize/core/network/interceptors/base_service.dart';
import 'package:syncronize/src/data/api/api_config.dart';
import 'package:syncronize/src/domain/models/auth_empresa_response.dart';
// import 'package:syncronize/src/domain/models/backend_error_response.dart';
import 'package:syncronize/src/domain/models/auth_response_register_new.dart';
import 'package:syncronize/src/domain/models/user_register_new.dart';
import 'package:syncronize/src/domain/utils/list_to_string.dart';
import 'package:syncronize/src/domain/utils/resource.dart';

class AuthService extends BaseService {



  Future<Resource<AuthEmpresaResponse>> login(String dni, String password) async {
    // Validaciones locales
    if (dni.isEmpty || password.isEmpty) {
      logger.w('DNI o contraseña vacíos');
      return Error<AuthEmpresaResponse>(
        'DNI y contraseña son requeridos',
        statusCode: 400,
        errorCode: 'VALIDATION_ERROR',
      );
    }
    
    if (!RegExp(r'^\d{8}$').hasMatch(dni)) {
      logger.w('DNI inválido: $dni');
      return Error<AuthEmpresaResponse>(
        'El DNI debe tener 8 dígitos',
        statusCode: 400,
        errorCode: 'VALIDATION_ERROR',
      );
    }

   
    // Usar el método base para manejar la respuesta
    return handleResponse<AuthEmpresaResponse>(
      request: () => dio.post('/api/auth/login', data: {
        'dni': dni,
        'password': password,
      }),
      fromJson: (json) => AuthEmpresaResponse.fromJson(json),
      entityName: 'Login',
    );
  }




  Future<Resource<AuthResponseRegisterNew>> register(UserRegisterNew user) async {
    try{
      Uri url = ApiConfig.getUri('api/auth/register');
      Map<String, String> headers = { "Content-Type": "application/json" };
      String body = json.encode(user.toJson());
      final response = await http.post(url, headers: headers, body: body);
      final data = jsonDecode(response.body);
      if(response.statusCode == 200 || response.statusCode == 201){
        AuthResponseRegisterNew authResponseRegister = AuthResponseRegisterNew.fromJson(data);
        //print(authResponse.toJson());
        return Success(authResponseRegister);
      }
      else{
        return Error(listToString(data['message']));
      }
    } catch(e){
      //print('Error:  $e');
      return Error(e.toString());
    }
  }
}
