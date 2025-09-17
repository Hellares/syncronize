// // class Empresa {
// //   final String id;
// //   final String razonSocial;
// //   final String ruc;
// //   final String estado;
// //   final List<String> roles;

// //   Empresa({
// //     required this.id,
// //     required this.razonSocial,
// //     required this.ruc,
// //     required this.estado,
// //     required this.roles,
// //   });

// //   factory Empresa.fromJson(Map<String, dynamic> json) => Empresa(
// //         id: json['id'] ?? '',
// //         razonSocial: json['razonSocial'] ?? '',
// //         ruc: json['ruc'] ?? '',
// //         estado: json['estado'] ?? '',
// //         roles: List<String>.from(json['roles'] ?? []),
// //       );

// //   Map<String, dynamic> toJson() => {
// //         'id': id,
// //         'razonSocial': razonSocial,
// //         'ruc': ruc,
// //         'estado': estado,
// //         'roles': roles,
// //       };
// // }

// class Empresa {
//     String id;
//     String razonSocial;
//     String ruc;
//     String estado;
//     List<String> roles;
//     String principalRole;
//     List<String> permissions;
//     Rubro rubro;

//     Empresa({
//         required this.id,
//         required this.razonSocial,
//         required this.ruc,
//         required this.estado,
//         required this.roles,
//         required this.principalRole,
//         required this.permissions,
//         required this.rubro,
//     });

//     // FACTORY OPTIMIZADO - Evita crear listas innecesarias
//     factory Empresa.fromJsonOptimized(Map<String, dynamic> json) {
//         try {
//             return Empresa(
//                 id: json["id"] as String? ?? '',
//                 razonSocial: json["razonSocial"] as String? ?? '',
//                 ruc: json["ruc"] as String? ?? '',
//                 estado: json["estado"] as String? ?? 'ACTIVE',
                
//                 // OPTIMIZACIÓN: Cast directo sin map si ya es List<String>
//                 roles: _parseStringList(json["roles"]),
//                 principalRole: json["principalRole"] as String? ?? '',
//                 permissions: _parseStringList(json["permissions"]),
                
//                 // Parsing lazy del rubro
//                 rubro: json["rubro"] != null 
//                     ? Rubro.fromJsonOptimized(json["rubro"]) 
//                     : Rubro(id: '', nombre: ''),
//             );
//         } catch (e) {
//             // print('⚠️ Error parsing Empresa: $e');
//             return Empresa(
//                 id: json["id"] as String? ?? '',
//                 razonSocial: json["razonSocial"] as String? ?? 'Empresa',
//                 ruc: '',
//                 estado: 'ACTIVE',
//                 roles: [],
//                 principalRole: '',
//                 permissions: [],
//                 rubro: Rubro(id: '', nombre: ''),
//             );
//         }
//     }

//     // Helper para parsing optimizado de listas de strings
//     static List<String> _parseStringList(dynamic jsonList) {
//         if (jsonList == null) return [];
//         if (jsonList is List<String>) return jsonList;
//         if (jsonList is List) {
//             return jsonList.map((item) => item.toString()).toList();
//         }
//         return [];
//     }

//     // Factory original
//     factory Empresa.fromJson(Map<String, dynamic> json) => Empresa(
//         id: json["id"],
//         razonSocial: json["razonSocial"],
//         ruc: json["ruc"],
//         estado: json["estado"],
//         roles: List<String>.from(json["roles"].map((x) => x)),
//         principalRole: json["principalRole"],
//         permissions: List<String>.from(json["permissions"].map((x) => x)),
//         rubro: Rubro.fromJson(json["rubro"]),
//     );

//     Map<String, dynamic> toJson() => {
//         "id": id,
//         "razonSocial": razonSocial,
//         "ruc": ruc,
//         "estado": estado,
//         "roles": List<dynamic>.from(roles.map((x) => x)),
//         "principalRole": principalRole,
//         "permissions": List<dynamic>.from(permissions.map((x) => x)),
//         "rubro": rubro.toJson(),
//     };
// }

// class Rubro {
//     String id;
//     String nombre;

//     Rubro({
//         required this.id,
//         required this.nombre,
//     });

//     // FACTORY OPTIMIZADO - Parsing simple y rápido
//     factory Rubro.fromJsonOptimized(Map<String, dynamic> json) {
//         return Rubro(
//             id: json["id"] as String? ?? '',
//             nombre: json["nombre"] as String? ?? '',
//         );
//     }

//     factory Rubro.fromJson(Map<String, dynamic> json) => Rubro(
//         id: json["id"],
//         nombre: json["nombre"],
//     );

//     Map<String, dynamic> toJson() => {
//         "id": id,
//         "nombre": nombre,
//     };
// }