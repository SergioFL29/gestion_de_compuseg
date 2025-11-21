import 'package:flutter/material.dart';
import './diagonal_clipper.dart'; // Importa el clipper para el fondo

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false, // Evita que el contenido se mueva con el teclado
      body: Stack(
        children: [
          // 1. Fondo de color sólido (Marrón/Vino)
          Container(
            color: const Color(0xFF671111), 
          ),
          
          // 2. Fondo Diagonal Blanco (La superposición)
          ClipPath(
            clipper: DiagonalClipper(), 
            child: Container(
              height: size.height,
              width: size.width,
              color: Colors.white,
            ),
          ),

          // 3. Contenido Principal (Título y Formulario de Registro)
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Botón de regreso (para cerrar la pantalla de registro)
                  Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Color(0xFF671111), size: 30,),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  const SizedBox(height: 20), // Espacio después del botón de regreso

                  // Área del Formulario de Registro (tarjeta blanca con sombra)
                  Container(
                    width: size.width * 0.85,
                    padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 25),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 15,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Crear Cuenta', // Título de la pantalla
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF671111)),
                        ),
                        const SizedBox(height: 30),

                        // Campo de Nuevo Usuario
                        TextField(
                          decoration: InputDecoration(
                            labelText: 'Nuevo Usuario',
                            border: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2.0),
                            ),
                            prefixIcon: const Icon(Icons.person_add, color: Colors.grey),
                            labelStyle: const TextStyle(color: Colors.grey),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Campo de Contraseña
                        TextField(
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Contraseña',
                            border: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2.0),
                            ),
                            prefixIcon: const Icon(Icons.lock, color: Colors.grey),
                            labelStyle: const TextStyle(color: Colors.grey),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Campo de Confirmar Contraseña
                        TextField(
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Confirmar Contraseña',
                            border: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2.0),
                            ),
                            prefixIcon: const Icon(Icons.lock_outline, color: Colors.grey),
                            labelStyle: const TextStyle(color: Colors.grey),
                          ),
                        ),
                        const SizedBox(height: 40),

                        // Botón de Crear Cuenta
                        ElevatedButton(
                          onPressed: () {
                            // TODO: Implementar la lógica para guardar el usuario
                            debugPrint('Cuenta creada');
                            Navigator.of(context).pop(); // Regresa a la pantalla anterior (Login)
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF671111),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 60, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 5,
                          ),
                          child: const Text(
                            'Registrar', // Cambiado a "Registrar"
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