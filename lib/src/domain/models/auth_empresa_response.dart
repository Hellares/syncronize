import 'package:syncronize/src/domain/models/user.dart';

class AuthEmpresaResponse {
    bool? success;
    String message;
    Data? data;

    AuthEmpresaResponse({
        required this.success,
        required this.message,
        required this.data,
    });

    factory AuthEmpresaResponse.fromJson(Map<String, dynamic> json) => AuthEmpresaResponse(
        success: json["success"] as bool?,
        message: json["message"] as String? ?? 'Sin mensaje', // Valor por defecto
        data: json["data"] != null ? Data.fromJson(json["data"]) : null,
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data?.toJson(),
    };
}

class Data {
    String token;
    User user;
    List<Empresa> empresas;
    bool isSuperAdmin;
    bool needsEmpresaSelection;

    Data({
        required this.token,
        required this.user,
        required this.empresas,
        required this.isSuperAdmin,
        required this.needsEmpresaSelection,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        token: json["token"],
        user: User.fromJson(json["user"]),
        empresas: List<Empresa>.from(json["empresas"].map((x) => Empresa.fromJson(x))),
        isSuperAdmin: json["isSuperAdmin"],
        needsEmpresaSelection: json["needsEmpresaSelection"],
    );

    Map<String, dynamic> toJson() => {
        "token": token,
        "user": user.toJson(),
        "empresas": List<dynamic>.from(empresas.map((x) => x.toJson())),
        "isSuperAdmin": isSuperAdmin,
        "needsEmpresaSelection": needsEmpresaSelection,
    };
}

class Empresa {
    String id;
    String razonSocial;
    String ruc;
    String estado;
    List<String> roles;
    String principalRole;
    List<String> permissions;
    Rubro rubro;

    Empresa({
        required this.id,
        required this.razonSocial,
        required this.ruc,
        required this.estado,
        required this.roles,
        required this.principalRole,
        required this.permissions,
        required this.rubro,
    });

    factory Empresa.fromJson(Map<String, dynamic> json) => Empresa(
        id: json["id"],
        razonSocial: json["razonSocial"],
        ruc: json["ruc"],
        estado: json["estado"],
        roles: List<String>.from(json["roles"].map((x) => x)),
        principalRole: json["principalRole"],
        permissions: List<String>.from(json["permissions"].map((x) => x)),
        rubro: Rubro.fromJson(json["rubro"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "razonSocial": razonSocial,
        "ruc": ruc,
        "estado": estado,
        "roles": List<dynamic>.from(roles.map((x) => x)),
        "principalRole": principalRole,
        "permissions": List<dynamic>.from(permissions.map((x) => x)),
        "rubro": rubro.toJson(),
    };
}

class Rubro {
    String id;
    String nombre;

    Rubro({
        required this.id,
        required this.nombre,
    });

    factory Rubro.fromJson(Map<String, dynamic> json) => Rubro(
        id: json["id"],
        nombre: json["nombre"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
    };
}

