import 'package:syncronize/src/domain/models/auth_empresa_response.dart';
// import 'package:syncronize/src/domain/models/empresa.dart';

class EmpresaUserRolesResponse {
    bool success;
    List<Empresa> data;
    Meta meta;

    EmpresaUserRolesResponse({
        required this.success,
        required this.data,
        required this.meta,
    });

    factory EmpresaUserRolesResponse.fromJson(Map<String, dynamic> json) => EmpresaUserRolesResponse(
        success: json['success'] ?? false,
        data: (json['data'] as List<dynamic>?)
                ?.map((item) => Empresa.fromJson(item))
                .toList() ??
            [],
        meta: Meta.fromJson(json['meta'] ?? {}),
      );

    Map<String, dynamic> toJson() => {
        "success": success,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "meta": meta.toJson(),
    };
}

// class Datum {
//     String id;
//     String razonSocial;
//     String ruc;
//     String estado;
//     List<String> roles;

//     Datum({
//         required this.id,
//         required this.razonSocial,
//         required this.ruc,
//         required this.estado,
//         required this.roles,
//     });

//     factory Datum.fromJson(Map<String, dynamic> json) => Datum(
//         id: json["id"],
//         razonSocial: json["razonSocial"],
//         ruc: json["ruc"],
//         estado: json["estado"],
//         roles: List<String>.from(json["roles"].map((x) => x)),
//     );

//     Map<String, dynamic> toJson() => {
//         "id": id,
//         "razonSocial": razonSocial,
//         "ruc": ruc,
//         "estado": estado,
//         "roles": List<dynamic>.from(roles.map((x) => x)),
//     };
// }

class Meta {
    int total;
    String userId;
    String userDni;

    Meta({
        required this.total,
        required this.userId,
        required this.userDni,
    });

    factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        total: json["total"],
        userId: json["userId"],
        userDni: json["userDni"],
    );

    Map<String, dynamic> toJson() => {
        "total": total,
        "userId": userId,
        "userDni": userDni,
    };
}