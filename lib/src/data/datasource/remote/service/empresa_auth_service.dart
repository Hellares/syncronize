import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:syncronize/src/data/api/api_config.dart';
import 'package:syncronize/src/domain/models/auth_response.dart';
import 'package:syncronize/src/domain/utils/resource.dart';

class EmpresaAuthService {
  
  /// Genera un token específico para una empresa usando el token de usuario y el ID de empresa
  Future<Resource<AuthResponse>> loginToEmpresa(String userToken, String empresaId) async {
    try {
      Uri url = ApiConfig.getUri('api/auth/empresa/login');
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $userToken',
      };
      String body = json.encode({
        'empresaId': empresaId,
      });
      
      final response = await http.post(url, headers: headers, body: body);
      final data = json.decode(response.body);
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        AuthResponse authResponse = AuthResponse.fromJson(data);
        return Success(authResponse);
      } else {
        return Error(data['message'] ?? 'Error al autenticar con la empresa');
      }
    } catch (e) {
      return Error('Error de conexión: $e');
    }
  }
  
  /// Valida si el token de empresa sigue siendo válido
  Future<Resource<bool>> validateEmpresaToken(String empresaToken) async {
    try {
      Uri url = ApiConfig.getUri('api/auth/empresa/validate');
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $empresaToken',
      };
      
      final response = await http.get(url, headers: headers);
      
      if (response.statusCode == 200) {
        return Success(true);
      } else {
        return Success(false);
      }
    } catch (e) {
      return Error('Error de conexión: $e');
    }
  }
  
  /// Cierra la sesión de empresa (invalida el token de empresa)
  Future<Resource<bool>> logoutFromEmpresa(String empresaToken) async {
    try {
      Uri url = ApiConfig.getUri('api/auth/empresa/logout');
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $empresaToken',
      };
      
      final response = await http.post(url, headers: headers);
      
      if (response.statusCode == 200) {
        return Success(true);
      } else {
        return Error('Error al cerrar sesión de empresa');
      }
    } catch (e) {
      return Error('Error de conexión: $e');
    }
  }
}