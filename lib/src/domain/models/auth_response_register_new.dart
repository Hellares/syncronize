class AuthResponseRegisterNew {
    bool success;
    String message;
    Data data;

    AuthResponseRegisterNew({
        required this.success,
        required this.message,
        required this.data,
    });

    factory AuthResponseRegisterNew.fromJson(Map<String, dynamic> json) => AuthResponseRegisterNew(
        success: json["success"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data.toJson(),
    };
}

class Data {
    String id;
    String dni;
    String nombres;
    String apellidoPaterno;
    String apellidoMaterno;
    String nombreCompleto;
    DateTime fechaNacimiento;
    String departamento;
    String provincia;
    String distrito;
    String direccionCompleta;
    String email;
    String telefono;
    String status;
    bool verified;
    DateTime createdAt;
    DateTime updatedAt;

    Data({
        required this.id,
        required this.dni,
        required this.nombres,
        required this.apellidoPaterno,
        required this.apellidoMaterno,
        required this.nombreCompleto,
        required this.fechaNacimiento,
        required this.departamento,
        required this.provincia,
        required this.distrito,
        required this.direccionCompleta,
        required this.email,
        required this.telefono,
        required this.status,
        required this.verified,
        required this.createdAt,
        required this.updatedAt,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        dni: json["dni"],
        nombres: json["nombres"],
        apellidoPaterno: json["apellido_paterno"],
        apellidoMaterno: json["apellido_materno"],
        nombreCompleto: json["nombres_completos"],
        fechaNacimiento: DateTime.parse(json["fecha_nacimiento"]),
        departamento: json["departamento"],
        provincia: json["provincia"],
        distrito: json["distrito"],
        direccionCompleta: json["direccion_completa"],
        email: json["email"],
        telefono: json["telefono"],
        status: json["status"],
        verified: json["verified"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "dni": dni,
        "nombres": nombres,
        "apellido_paterno": apellidoPaterno,
        "apellido_materno": apellidoMaterno,
        "nombres_completos": nombreCompleto,
        "fecha_nacimiento": fechaNacimiento.toIso8601String(),
        "departamento": departamento,
        "provincia": provincia,
        "distrito": distrito,
        "direccion_completa": direccionCompleta,
        "email": email,
        "telefono": telefono,
        "status": status,
        "verified": verified,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
    };
}
