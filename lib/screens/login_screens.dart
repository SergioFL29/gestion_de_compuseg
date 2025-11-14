import 'package:flutter/material.dart';
import './diagonal_clipper.dart'; // Asegúrate de que esta ruta sea correcta

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtenemos la altura de la pantalla para el fondo diagonal
    final size = MediaQuery.of(context).size;

    return Scaffold(
      // Evita que el contenido se mueva si aparece el teclado
      resizeToAvoidBottomInset: false, 
      
      body: Stack(
        children: [
          // 1. Fondo de color sólido (Marrón/Vino de tu diseño)
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

          // 3. Contenido Principal (Logo, Formulario, Texto)
          Center(
            child: SingleChildScrollView( // Permite desplazamiento si la pantalla es pequeña
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Área del Logo y Formulario (tarjeta blanca con sombra)
                  Container(
                    width: 350, 
                    padding: const EdgeInsets.all(30),
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
                        // Simulación del Logo COMPUSEG
                        Image.asset(
                          'assets/images/logo.png',
                          height: 240,
                        ),
                        const SizedBox(height: 30),

                        // Campo de Usuario
                        TextField(
                          decoration: InputDecoration(
                            labelText: 'Usuario',
                            border: const OutlineInputBorder(),
                            prefixIcon: const Icon(Icons.person),
                            // Color del borde cuando está enfocado
                            focusedBorder: OutlineInputBorder( 
                              borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2.0),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),

                        // Campo de Contraseña
                        TextField(
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Contraseña',
                            border: const OutlineInputBorder(),
                            prefixIcon: const Icon(Icons.lock),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2.0),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),

                        // Botón de Login
                        ElevatedButton(
                          onPressed: () {
                            // TODO: Implementar la navegación a la pantalla de Equipos
                            print('Login presionado');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF671111),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 60, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Login',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),

                        const SizedBox(height: 20),
                        // Nombre del ingeniero
                        const Text(
                          'Ing. Jose Ramon Rubio Bojorquez',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
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