class User {
  String? nombre;
  String? apellido;
  int? edad;
  bool? sexo;
  String? url_foto;
  String? correo;
  String? telefono;

  User(
      {
        this.nombre,
        this.apellido,
        this.edad,
        this.sexo,
        this.url_foto,
        this.correo,
        this.telefono,
      }
      );

  User.fromMap(Map<String, dynamic> json) {
    nombre = json['nombre'];
    apellido = json['apellido'];
    edad = json['edad'];
    sexo = json['sexo'];
    url_foto = json['url_foto'];
    correo = json['correo'];
    telefono = json['telefono'];
  }

  User.fromJson(Map<String, dynamic> json) {
    nombre = json['nombre'];
    apellido = json['apellido'];
    edad = json['edad'];
    sexo = json['sexo'];
    url_foto = json['url_foto'];
    correo = json['correo'];
    telefono = json['telefono'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nombre'] = this.nombre;
    data['apellido'] = this.apellido;
    data['edad'] = this.edad;
    data['sexo'] = this.sexo;
    data['url_foto'] = this.url_foto;
    data['correo'] = this.correo;
    data['telefono'] = this.telefono;
    return data;
  }
}
