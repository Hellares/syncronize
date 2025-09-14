// src/data/dataSource/remote/service/reniec_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:syncronize/src/domain/models/sunat_response_new.dart';
import 'package:syncronize/src/domain/utils/list_to_string.dart';
import 'package:syncronize/src/domain/utils/resource.dart';


class ReniecService {
  static const String _baseUrl = 'https://api.factiliza.com/v1';
  static const String _token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIyMzciLCJodHRwOi8vc2NoZW1hcy5taWNyb3NvZnQuY29tL3dzLzIwMDgvMDYvaWRlbnRpdHkvY2xhaW1zL3JvbGUiOiJjb25zdWx0b3IifQ.Mi4bxZChCuNt4uH2-_jy7z37GPLnBhEqtH2IfvlK-6M';

  Future<Resource<ReniecResponse>> getDniReniec(String numberDni) async {
    try {
      // Validar el DNI
      if (numberDni.isEmpty || numberDni.length != 8 || !RegExp(r'^\d+$').hasMatch(numberDni)) {
        return Error('El DNI debe tener 8 dígitos numéricos');
      }

      final uri = Uri.parse('$_baseUrl/dni/info/$numberDni');
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token',
      };

      final response = await http.get(uri, headers: headers);
      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final reniecResponse = ReniecResponse.fromJson(data);
        // print(reniecResponse.toJson());
        return Success(reniecResponse);
      } else {
        String errorMessage;
        switch (response.statusCode) {
          case 401:
            errorMessage = 'Token de autorización inválido';
            break;
          case 404:
            errorMessage = 'DNI no encontrado en RENIEC';
            break;
          case 429:
            errorMessage = 'Límite de solicitudes alcanzado, intente más tarde';
            break;
          case 500:
            errorMessage = 'Error interno del servidor RENIEC';
            break;
          default:
            errorMessage = data['message'] is String
                ? data['message']
                : data['message'] is List
                    ? listToString(data['message'])
                    : 'Error desconocido al consultar RENIEC';
        }
        return Error(errorMessage);
      }
    } catch (e) {
      return Error('Error de conexión con RENIEC: ${e.toString()}');
    }
  }
}