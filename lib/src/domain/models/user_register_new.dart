// src/domain/models/user_register_new.dart
class UserRegisterNew {
  final String? dni;
  final String nombres;
  final String apellidoPaterno;
  final String apellidoMaterno;
  final String departamento;
  final String provincia;
  final String distrito;
  final String direccion;
  final String? email;
  final String? phone;
  final String? password;

  UserRegisterNew({
    this.dni,
    required this.nombres,
    required this.apellidoPaterno,
    required this.apellidoMaterno,
    required this.departamento,
    required this.provincia,
    required this.distrito,
    required this.direccion,
    required this.email,
    required this.phone,
    this.password,
  });

  factory UserRegisterNew.fromJson(Map<String, dynamic> json) => UserRegisterNew(
        dni: json["dni"],
        nombres: json["nombres"],
        apellidoPaterno: json["apellido_paterno"],
        apellidoMaterno: json["apellido_materno"],
        departamento: json["departamento"],
        provincia: json["provincia"],
        distrito: json["distrito"],
        direccion: json["direccion"],
        email: json["email"],
        phone: json["phone"],
        password: json["password"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "dni": dni,
        "nombres": nombres,
        "apellido_paterno": apellidoPaterno,
        "apellido_materno": apellidoMaterno,
        "departamento": departamento,
        "provincia": provincia,
        "distrito": distrito,
        "direccion": direccion,
        "email": email,
        "phone": phone,
        "password": password,
      };

  // Getters para compatibilidad con implementación anterior si es necesario
  String get name => nombres;
  String get lastname => '$apellidoPaterno $apellidoMaterno';
  String get fullName => '$nombres $apellidoPaterno $apellidoMaterno';
}