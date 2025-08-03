
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:syncronize/src/data/api/api_config.dart';
import 'package:syncronize/src/domain/models/auth_response.dart';
import 'package:syncronize/src/domain/utils/list_to_string.dart';
import 'package:syncronize/src/domain/utils/resource.dart';

class AuthService {
  Future<Resource<AuthResponse>> login(String dni, String password) async {
    try {
      Uri  url = Uri.http(ApiConfig.baseUrl, 'api/auth/login');
      Map<String, String> headers = {
        'Content-Type': 'application/json',
      };
      String body = json.encode({
        'dni': dni,
        'password': password,
      });
      final response = await http.post(url, headers: headers, body: body);
      final data = json.decode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        AuthResponse authResponse = AuthResponse.fromJson(data);
        // print(authResponse.toJson());
        return Success(authResponse);
        
      } else {
        return Error(listToString(data['message']));
      }
      
    } catch (e) {
      return Error(e.toString());
    }
  }

  
}