class Empresa {
  final String id;
  final String razonSocial;
  final String ruc;
  final String estado;
  final List<String> roles;

  Empresa({
    required this.id,
    required this.razonSocial,
    required this.ruc,
    required this.estado,
    required this.roles,
  });

  factory Empresa.fromJson(Map<String, dynamic> json) => Empresa(
        id: json['id'] ?? '',
        razonSocial: json['razonSocial'] ?? '',
        ruc: json['ruc'] ?? '',
        estado: json['estado'] ?? '',
        roles: List<String>.from(json['roles'] ?? []),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'razonSocial': razonSocial,
        'ruc': ruc,
        'estado': estado,
        'roles': roles,
      };
}