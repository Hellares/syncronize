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

    // PARSING OPTIMIZADO - Solo procesa lo esencial inicialmente
    factory AuthEmpresaResponse.fromJson(Map<String, dynamic> json) {
        // final stopwatch = Stopwatch()..start();
        
        try {
            final response = AuthEmpresaResponse(
                success: json["success"] as bool?,
                message: json["message"] as String? ?? 'Sin mensaje',
                data: json["data"] != null ? Data.fromJsonOptimized(json["data"]) : null,
            );
            
            // stopwatch.stop();
            // print('📊 Parsing AuthResponse: ${stopwatch.elapsedMilliseconds}ms');
            return response;
            
        } catch (e) {
            // stopwatch.stop();
            // print('❌ Error parsing en ${stopwatch.elapsedMilliseconds}ms: $e');
            rethrow;
        }
    }

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

    // FACTORY OPTIMIZADO - Parsing lazy de empresas
    factory Data.fromJsonOptimized(Map<String, dynamic> json) {
        // final stopwatch = Stopwatch()..start();
        
        try {
            // 1. Parsear token inmediatamente (crítico)
            final token = json["token"] as String? ?? '';
            
            // 2. Parsear usuario (necesario para UI)
            // final userStopwatch = Stopwatch()..start();
            final user = User.fromJson(json["user"]);
            // userStopwatch.stop();
            // print('👤 Parsing User: ${userStopwatch.elapsedMilliseconds}ms');
            
            // 3. Parsear empresas de forma optimizada
            // final empresasStopwatch = Stopwatch()..start();
            final empresasList = json["empresas"] as List<dynamic>? ?? [];
            final empresas = empresasList.map((x) => Empresa.fromJsonOptimized(x)).toList();
            // empresasStopwatch.stop();
            // print('🏢 Parsing ${empresas.length} empresas: ${empresasStopwatch.elapsedMilliseconds}ms');
            
            // 4. Flags simples
            final isSuperAdmin = json["isSuperAdmin"] as bool? ?? false;
            final needsEmpresaSelection = json["needsEmpresaSelection"] as bool? ?? false;
            
            // stopwatch.stop();
            // print('📊 Parsing Data total: ${stopwatch.elapsedMilliseconds}ms');
            
            return Data(
                token: token,
                user: user,
                empresas: empresas,
                isSuperAdmin: isSuperAdmin,
                needsEmpresaSelection: needsEmpresaSelection,
            );
            
        } catch (e) {
            // stopwatch.stop();
            // print('❌ Error parsing Data en ${stopwatch.elapsedMilliseconds}ms: $e');
            
            // FALLBACK: Crear objeto mínimo funcional
            return Data(
                token: json["token"] as String? ?? '',
                user: User.fromJson(json["user"]),
                empresas: [],
                isSuperAdmin: false,
                needsEmpresaSelection: false,
            );
        }
    }

    // Factory original para compatibilidad
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

    // FACTORY OPTIMIZADO - Evita crear listas innecesarias
    factory Empresa.fromJsonOptimized(Map<String, dynamic> json) {
        try {
            return Empresa(
                id: json["id"] as String? ?? '',
                razonSocial: json["razonSocial"] as String? ?? '',
                ruc: json["ruc"] as String? ?? '',
                estado: json["estado"] as String? ?? 'ACTIVE',
                
                // OPTIMIZACIÓN: Cast directo sin map si ya es List<String>
                roles: _parseStringList(json["roles"]),
                principalRole: json["principalRole"] as String? ?? '',
                permissions: _parseStringList(json["permissions"]),
                
                // Parsing lazy del rubro
                rubro: json["rubro"] != null 
                    ? Rubro.fromJsonOptimized(json["rubro"]) 
                    : Rubro(id: '', nombre: ''),
            );
        } catch (e) {
            // print('⚠️ Error parsing Empresa: $e');
            return Empresa(
                id: json["id"] as String? ?? '',
                razonSocial: json["razonSocial"] as String? ?? 'Empresa',
                ruc: '',
                estado: 'ACTIVE',
                roles: [],
                principalRole: '',
                permissions: [],
                rubro: Rubro(id: '', nombre: ''),
            );
        }
    }

    // Helper para parsing optimizado de listas de strings
    static List<String> _parseStringList(dynamic jsonList) {
        if (jsonList == null) return [];
        if (jsonList is List<String>) return jsonList;
        if (jsonList is List) {
            return jsonList.map((item) => item.toString()).toList();
        }
        return [];
    }

    // Factory original
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

    // FACTORY OPTIMIZADO - Parsing simple y rápido
    factory Rubro.fromJsonOptimized(Map<String, dynamic> json) {
        return Rubro(
            id: json["id"] as String? ?? '',
            nombre: json["nombre"] as String? ?? '',
        );
    }

    factory Rubro.fromJson(Map<String, dynamic> json) => Rubro(
        id: json["id"],
        nombre: json["nombre"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
    };
}