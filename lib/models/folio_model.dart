class Folio {
  int? id;
  String folioCode; // El código ej: HGT02
  String nombreCliente;
  String telefono;
  String equipo;
  String descripcion;
  String estado; // 'Por reparar', 'Por entregar', 'Entregada'
  int userId; // <--- ESTO ES CLAVE: El ID del usuario que lo registró

  Folio({
    this.id,
    required this.folioCode,
    required this.nombreCliente,
    required this.telefono,
    required this.equipo,
    required this.descripcion,
    required this.estado,
    required this.userId,
  });

  // Convertir a Mapa para la BD
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'folioCode': folioCode,
      'nombreCliente': nombreCliente,
      'telefono': telefono,
      'equipo': equipo,
      'descripcion': descripcion,
      'estado': estado,
      'userId': userId,
    };
  }

  // Crear desde Mapa (Leer de la BD)
  factory Folio.fromMap(Map<String, dynamic> map) {
    return Folio(
      id: map['id'],
      folioCode: map['folioCode'],
      nombreCliente: map['nombreCliente'],
      telefono: map['telefono'],
      equipo: map['equipo'],
      descripcion: map['descripcion'],
      estado: map['estado'],
      userId: map['userId'],
    );
  }
}