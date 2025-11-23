import 'package:flutter/material.dart';
import 'diagonal_clipper.dart'; 
import 'register_screens.dart';
import 'teams_screen.dart'; 
import '../database/database_helper.dart'; // Importar BD
import '../models/user_model.dart';      // Importar Modelo

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // 1. Controladores
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  // Función de Login
  void _login() async {
    String user = _userController.text.trim();
    String pass = _passController.text.trim();

    if (user.isEmpty || pass.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor ingresa usuario y contraseña'))
      );
      return;
    }

    // Consultar a la BD
    User? loggedUser = await DatabaseHelper.instance.loginUser(user, pass);

    if (loggedUser != null) {
      // Login Exitoso
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const TeamsScreen()),
        );
      }
    } else {
      // Credenciales incorrectas
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Usuario o contraseña incorrectos'))
        );
      }
    }
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
                        Image.asset('assets/images/logo.png', height: 120),
                        const SizedBox(height: 30),
                        
                        // Campo Usuario
                        TextField(
                          controller: _userController, // <--- CONEXIÓN
                          decoration: InputDecoration(
                            labelText: 'Usuario',
                            border: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2.0)),
                            prefixIcon: const Icon(Icons.person, color: Colors.grey),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Campo Contraseña
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
                        const SizedBox(height: 40),

                        // Botón Login
                        ElevatedButton(
                          onPressed: _login, // <--- LLAMA A LA LÓGICA
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF671111),
                            padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            elevation: 5,
                          ),
                          child: const Text(
                            'Login',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                        const SizedBox(height: 15),

                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const RegisterScreen()),
                            );
                          },
                          child: const Text(
                            'Crear Cuenta',
                            style: TextStyle(color: Color(0xFF671111), decoration: TextDecoration.underline),
                          ),
                        ),

                        const SizedBox(height: 30),
                        const Text(
                          'Ing. Jose Ramon Rubio Bojorquez',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16, color: Colors.black87, fontWeight: FontWeight.w600),
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