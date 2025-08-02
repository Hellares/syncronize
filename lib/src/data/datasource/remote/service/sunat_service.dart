
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:syncronize/src/domain/models/sunat_response.dart';
import 'package:syncronize/src/domain/utils/resource.dart';

class SunatService {
  static const String _baseUrl = 'https://api.factiliza.com/v1';
  static const String _token =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIyMzciLCJodHRwOi8vc2NoZW1hcy5taWNyb3NvZnQuY29tL3dzLzIwMDgvMDYvaWRlbnRpdHkvY2xhaW1zL3JvbGUiOiJjb25zdWx0b3IifQ.Mi4bxZChCuNt4uH2-_jy7z37GPLnBhEqtH2IfvlK-6M';

  Future<Resource<SunatResponse>> getDniSunat(String numberDni) async {
    try {
      // Validar el DNI
      if (numberDni.isEmpty || numberDni.length != 8 || !RegExp(r'^\d+$').hasMatch(numberDni)) {
        return  Error('El DNI debe tener 8 dígitos numéricos');
      }

      final uri = Uri.parse('$_baseUrl/dni/info/$numberDni');
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token',
      };

      final response = await http.get(uri, headers: headers);
      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final sunatResponse = SunatResponse.fromJson(data);
        return Success(sunatResponse);
      } else {
        String errorMessage;
        switch (response.statusCode) {
          case 401:
            errorMessage = 'Token de autorización inválido';
            break;
          case 404:
            errorMessage = 'DNI no encontrado';
            break;
          case 429:
            errorMessage = 'Límite de solicitudes alcanzado';
            break;
          default:
            errorMessage = data['message'] is String
                ? data['message']
                : data['message'] is List
                    ? data['message'].join(', ')
                    : 'Error desconocido';
        }
        return Error(errorMessage);
      }
    } catch (e) {
      return Error('Error de conexión: ${e.toString()}');
    }
  }
}