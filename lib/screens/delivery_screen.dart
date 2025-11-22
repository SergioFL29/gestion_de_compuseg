import 'package:flutter/material.dart';

class DeliveryScreen extends StatefulWidget {
  const DeliveryScreen({super.key});

  @override
  State<DeliveryScreen> createState() => _DeliveryScreenState();
}

class _DeliveryScreenState extends State<DeliveryScreen> {
  // Variable para controlar la selección del dropdown
  String? selectedEquipo;

  @override
  Widget build(BuildContext context) {
    final primaryColor = const Color(0xFF671111); // Color vino/marrón
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255), // Fondo gris claro
      body: SafeArea(
        child: Column(
          children: [
            // --- 1. ENCABEZADO PERSONALIZADO (Igual a Registro/Equipos) ---
            Container(
              color: Colors.white, // Fondo blanco detrás de la barra
              padding: const EdgeInsets.all(15.0),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Entrega',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
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

            // --- 2. CUERPO DEL FORMULARIO ---
            Expanded(
              child: Stack(
                children: [
                  // Decoración Triangular
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

                  // Formulario
                  SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
                    child: Column(
                      children: [
                        // Campo: Teléfono (con Lupa de búsqueda)
                        _buildSearchField(label: 'Telefono'),
                        const SizedBox(height: 25),

                        // Campo: Nombre (Read-only visualmente o normal)
                        _buildCustomTextField(label: 'Nombre'),
                        const SizedBox(height: 25),

                        // Campo: Equipo (Dropdown)
                        _buildCustomDropdown(
                          hint: 'Equipo',
                          value: selectedEquipo,
                          items: ['HP - VFD12', 'Lenovo - AVT21', 'Asus - HGT02'], // Datos de ejemplo
                          onChanged: (value) {
                            setState(() {
                              selectedEquipo = value;
                            });
                          },
                        ),
                        const SizedBox(height: 25),

                        // Campo: Observaciones (Grande)
                        _buildCustomTextField(label: 'Observaciones', maxLines: 5),
                        const SizedBox(height: 40),

                        // Botón: Guardar
                        SizedBox(
                          width: 200,
                          child: ElevatedButton(
                            onPressed: () {
                              // TODO: Lógica de guardar entrega
                              debugPrint('Guardar entrega presionado');
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

  // --- WIDGET: Campo de Texto Estándar ---
  Widget _buildCustomTextField({
    required String label,
    int maxLines = 1,
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
        decoration: InputDecoration(
          hintText: label,
          hintStyle: const TextStyle(color: Colors.black38),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          border: InputBorder.none,
        ),
      ),
    );
  }

  // --- WIDGET: Campo de Búsqueda (Teléfono) ---
  Widget _buildSearchField({required String label}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15), // Bordes muy redondeados
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
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
          hintText: label,
          hintStyle: const TextStyle(color: Colors.black38),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          border: InputBorder.none,
          // Icono de búsqueda a la derecha (SuffixIcon)
          suffixIcon: const Icon(Icons.search, color: Colors.black54),
        ),
      ),
    );
  }

  // --- WIDGET: Dropdown Personalizado (Equipo) ---
  Widget _buildCustomDropdown({
    required String hint,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
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
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(hint, style: const TextStyle(color: Colors.black38)),
          isExpanded: true, // Ocupa todo el ancho
          icon: const Icon(Icons.arrow_drop_down, color: Colors.black87),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

// --- CLIPPER (Mismo que en Registro) ---
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