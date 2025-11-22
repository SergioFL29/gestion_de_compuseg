import 'package:flutter/material.dart';

class NewFolioScreen extends StatelessWidget {
  const NewFolioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = const Color(0xFF671111); // Color vino/marrón
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255), // Fondo gris claro para el cuerpo
      body: SafeArea(
        child: Column(
          children: [
            // --- 1. ENCABEZADO PERSONALIZADO (Estilo Equipos) ---
            Container(
              color: Colors.white, // Fondo blanco detrás de la barra roja
              padding: const EdgeInsets.all(15.0),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(10), // Bordes redondeados
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Registro',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    // Botón de regreso a la derecha
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            ),

            // --- 2. CUERPO DEL FORMULARIO (Con el triángulo y campos) ---
            Expanded(
              child: Stack(
                children: [
                  // Decoración Triangular en la esquina inferior izquierda
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: ClipPath(
                      clipper: BottomCornerClipper(),
                      child: Container(
                        width: size.width * 0.5,
                        height: 100,
                        color: primaryColor,
                      ),
                    ),
                  ),

                  // Formulario con Scroll
                  SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
                    child: Column(
                      children: [
                        // Campo: Folio
                        _buildCustomTextField(label: 'Folio'),
                        const SizedBox(height: 25),

                        // Campo: Nombre
                        _buildCustomTextField(label: 'Nombre'),
                        const SizedBox(height: 25),

                        // Campo: Telefono
                        _buildCustomTextField(label: 'Telefono', keyboardType: TextInputType.phone),
                        const SizedBox(height: 25),

                        // Campo: Equipo
                        _buildCustomTextField(label: 'Equipo'),
                        const SizedBox(height: 25),

                        // Campo: Descripcion
                        _buildCustomTextField(label: 'Descripcion', maxLines: 5),
                        const SizedBox(height: 40),

                        // Botón: Guardar
                        SizedBox(
                          width: 200,
                          child: ElevatedButton(
                            onPressed: () {
                              // TODO: Guardar en la base de datos local
                              debugPrint('Guardar folio presionado');
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF671111),
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              elevation: 5,
                            ),
                            child: const Text(
                              'Guardar',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 50), 
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget auxiliar para los campos de texto
  Widget _buildCustomTextField({
    required String label,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(color: Colors.black12),
      ),
      child: TextField(
        maxLines: maxLines,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: label,
          hintStyle: const TextStyle(color: Colors.black38),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          border: InputBorder.none,
        ),
      ),
    );
  }
}

// Clipper para el triángulo inferior
class BottomCornerClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(0, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}