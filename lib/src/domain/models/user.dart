class User {
    String id;
    String dni;
    String nombres;
    String apellidoPaterno;
    String apellidoMaterno;
    String nombresCompletos;
    DateTime fechaNacimiento;
    String departamento;
    String provincia;
    String distrito;
    String direccionCompleta;
    String email;
    String telefono;
    String status;
    bool verified;
    DateTime lastLogin;
    DateTime createdAt;
    DateTime updatedAt;

    User({
        required this.id,
        required this.dni,
        required this.nombres,
        required this.apellidoPaterno,
        required this.apellidoMaterno,
        required this.nombresCompletos,
        required this.fechaNacimiento,
        required this.departamento,
        required this.provincia,
        required this.distrito,
        required this.direccionCompleta,
        required this.email,
        required this.telefono,
        required this.status,
        required this.verified,
        required this.lastLogin,
        required this.createdAt,
        required this.updatedAt,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        dni: json["dni"],
        nombres: json["nombres"],
        apellidoPaterno: json["apellido_paterno"],
        apellidoMaterno: json["apellido_materno"],
        nombresCompletos: json["nombres_completos"],
        fechaNacimiento: DateTime.parse(json["fecha_nacimiento"]),
        departamento: json["departamento"],
        provincia: json["provincia"],
        distrito: json["distrito"],
        direccionCompleta: json["direccion_completa"],
        email: json["email"],
        telefono: json["telefono"],
        status: json["status"],
        verified: json["verified"],
        lastLogin: DateTime.parse(json["last_login"]),
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "dni": dni,
        "nombres": nombres,
        "apellido_paterno": apellidoPaterno,
        "apellido_materno": apellidoMaterno,
        "nombres_completos": nombresCompletos,
        "fecha_nacimiento": fechaNacimiento.toIso8601String(),
        "departamento": departamento,
        "provincia": provincia,
        "distrito": distrito,
        "direccion_completa": direccionCompleta,
        "email": email,
        "telefono": telefono,
        "status": status,
        "verified": verified,
        "last_login": lastLogin.toIso8601String(),
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
    };
}
