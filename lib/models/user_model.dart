class User {
  int? id;
  String username;
  String password;

  User({this.id, required this.username, required this.password});

  // Convierte un objeto User a un Mapa (para guardar en la BD)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'password': password,
    };
  }

  // Crea un objeto User desde un Mapa (al leer de la BD)
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      username: map['username'],
      password: map['password'],
    );
  }
}