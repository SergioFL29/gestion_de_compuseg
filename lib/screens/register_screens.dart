import 'package:flutter/material.dart';
import './diagonal_clipper.dart'; 
import '../database/database_helper.dart'; // Importamos la BD
import '../models/user_model.dart';      // Importamos el Modelo

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // 1. Controladores para leer el texto de los campos
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();

  // Función para guardar el usuario
  void _register() async {
    String user = _userController.text.trim();
    String pass = _passController.text.trim();
    String confirm = _confirmPassController.text.trim();

    // Validaciones básicas
    if (user.isEmpty || pass.isEmpty) {
      _showMessage('Por favor llena todos los campos');
      return;
    }

    if (pass != confirm) {
      _showMessage('Las contraseñas no coinciden');
      return;
    }

    // Crear el objeto usuario
    User newUser = User(username: user, password: pass);

    // Guardar en la Base de Datos
    int result = await DatabaseHelper.instance.registerUser(newUser);

    if (result != -1) {
      // Éxito
      _showMessage('Usuario creado con éxito');
      if (mounted) Navigator.pop(context); // Regresa al Login
    } else {
      // Error (probablemente usuario duplicado)
      _showMessage('El usuario ya existe');
    }
  }

  // Función auxiliar para mostrar mensajes (Snackbar)
  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(color: const Color(0xFF671111)),
          ClipPath(
            clipper: DiagonalClipper(),
            child: Container(
              height: size.height,
              width: size.width,
              color: Colors.white,
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Color(0xFF671111), size: 30),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  const SizedBox(height: 20),

                  Container(
                    width: size.width * 0.85,
                    padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 25),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: const [
                        BoxShadow(color: Colors.black26, blurRadius: 15, offset: Offset(0, 8)),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Crear Cuenta',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF671111)),
                        ),
                        const SizedBox(height: 30),

                        // Campo de Nuevo Usuario (Conectado al controlador)
                        TextField(
                          controller: _userController, // <--- CONEXIÓN
                          decoration: InputDecoration(
                            labelText: 'Nuevo Usuario',
                            border: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2.0)),
                            prefixIcon: const Icon(Icons.person_add, color: Colors.grey),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Campo de Contraseña (Conectado al controlador)
                        TextField(
                          controller: _passController, // <--- CONEXIÓN
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Contraseña',
                            border: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2.0)),
                            prefixIcon: const Icon(Icons.lock, color: Colors.grey),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Campo de Confirmar Contraseña (Conectado al controlador)
                        TextField(
                          controller: _confirmPassController, // <--- CONEXIÓN
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Confirmar Contraseña',
                            border: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2.0)),
                            prefixIcon: const Icon(Icons.lock_outline, color: Colors.grey),
                          ),
                        ),
                        const SizedBox(height: 40),

                        // Botón de Registrar
                        ElevatedButton(
                          onPressed: _register, // <--- LLAMA A LA LÓGICA
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF671111),
                            padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            elevation: 5,
                          ),
                          child: const Text(
                            'Registrar',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}