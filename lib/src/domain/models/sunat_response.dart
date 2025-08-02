
class SunatResponse {
    int status;
    String message;
    Data data;
    int fuente;

    SunatResponse({
        required this.status,
        required this.message,
        required this.data,
        required this.fuente,
    });

    factory SunatResponse.fromJson(Map<String, dynamic> json) => SunatResponse(
        status: json["status"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
        fuente: json["fuente"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data.toJson(),
        "fuente": fuente,
    };
}

class Data {
    String numero;
    String nombres;
    String apellidoPaterno;
    String apellidoMaterno;
    String nombreCompleto;
    String departamento;
    String provincia;
    String distrito;
    String direccion;
    String direccionCompleta;
    String ubigeoReniec;
    String ubigeoSunat;
    List<String>? ubigeo;
    String fechaNacimiento;
    String estadoCivil;
    String foto;
    String sexo;

    Data({
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
        this.ubigeo,
        required this.fechaNacimiento,
        required this.estadoCivil,
        required this.foto,
        required this.sexo,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        numero: json["numero"],
        nombres: json["nombres"],
        apellidoPaterno: json["apellido_paterno"],
        apellidoMaterno: json["apellido_materno"],
        nombreCompleto: json["nombre_completo"],
        departamento: json["departamento"],
        provincia: json["provincia"],
        distrito: json["distrito"],
        direccion: json["direccion"],
        direccionCompleta: json["direccion_completa"],
        ubigeoReniec: json["ubigeo_reniec"],
        ubigeoSunat: json["ubigeo_sunat"],
        ubigeo: json["ubigeo"] != null
          ? List<String>.from(json["ubigeo"].map((x) => x))
          : null,
        fechaNacimiento: json["fecha_nacimiento"],
        estadoCivil: json["estado_civil"],
        foto: json["foto"],
        sexo: json["sexo"],
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
        "ubigeo": ubigeo != null ? List<dynamic>.from(ubigeo!.map((x) => x)) : null,
        "fecha_nacimiento": fechaNacimiento,
        "estado_civil": estadoCivil,
        "foto": foto,
        "sexo": sexo,
    };
}