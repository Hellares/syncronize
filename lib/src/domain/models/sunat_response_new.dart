// src/domain/models/reniec_response.dart
class ReniecResponse {
  final int status;
  final bool success;
  final String message;
  final ReniecData data;

  ReniecResponse({
    required this.status,
    required this.success,
    required this.message,
    required this.data,
  });

  factory ReniecResponse.fromJson(Map<String, dynamic> json) => ReniecResponse(
        status: json["status"] ?? 0,
        success: json["success"] ?? false,
        message: json["message"] ?? "",
        data: ReniecData.fromJson(json["data"] ?? {}),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "success": success,
        "message": message,
        "data": data.toJson(),
      };
}

class ReniecData {
  final String numero;
  final String nombres;
  final String apellidoPaterno;
  final String apellidoMaterno;
  final String nombreCompleto;
  final String departamento;
  final String provincia;
  final String distrito;
  final String direccion;
  final String direccionCompleta;
  final String ubigeoReniec;
  final String ubigeoSunat;
  final List<String> ubigeo;
  final String fechaNacimiento;
  final String sexo;

  ReniecData({
    required this.numero,
    required this.nombres,
    required this.apellidoPaterno,
    required this.apellidoMaterno,
    required this.nombreCompleto,
    required this.departamento,
    required this.provincia,
    required this.distrito,
    required this.direccion,
    required this.direccionCompleta,
    required this.ubigeoReniec,
    required this.ubigeoSunat,
    required this.ubigeo,
    required this.fechaNacimiento,
    required this.sexo,
  });

  factory ReniecData.fromJson(Map<String, dynamic> json) => ReniecData(
        numero: json["numero"] ?? "",
        nombres: json["nombres"] ?? "",
        apellidoPaterno: json["apellido_paterno"] ?? "",
        apellidoMaterno: json["apellido_materno"] ?? "",
        nombreCompleto: json["nombre_completo"] ?? "",
        departamento: json["departamento"] ?? "",
        provincia: json["provincia"] ?? "",
        distrito: json["distrito"] ?? "",
        direccion: json["direccion"] ?? "",
        direccionCompleta: json["direccion_completa"] ?? "",
        ubigeoReniec: json["ubigeo_reniec"] ?? "",
        ubigeoSunat: json["ubigeo_sunat"] ?? "",
        ubigeo: json["ubigeo"] != null 
            ? List<String>.from(json["ubigeo"].map((x) => x.toString()))
            : [],
        fechaNacimiento: json["fecha_nacimiento"] ?? "",
        sexo: json["sexo"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "numero": numero,
        "nombres": nombres,
        "apellido_paterno": apellidoPaterno,
        "apellido_materno": apellidoMaterno,
        "nombre_completo": nombreCompleto,
        "departamento": departamento,
        "provincia": provincia,
        "distrito": distrito,
        "direccion": direccion,
        "direccion_completa": direccionCompleta,
        "ubigeo_reniec": ubigeoReniec,
        "ubigeo_sunat": ubigeoSunat,
        "ubigeo": List<dynamic>.from(ubigeo.map((x) => x)),
        "fecha_nacimiento": fechaNacimiento,
        "sexo": sexo,
      };
}