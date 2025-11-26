import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/folio_model.dart';

class NewFolioScreen extends StatefulWidget {
  final int currentUserId; 

  const NewFolioScreen({super.key, required this.currentUserId});

  @override
  State<NewFolioScreen> createState() => _NewFolioScreenState();
}

class _NewFolioScreenState extends State<NewFolioScreen> {
  final _folioController = TextEditingController();
  final _nombreController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _equipoController = TextEditingController();
  final _descController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Al abrir la pantalla, calculamos el folio
    _generateFolioCode();
  }

  // Lógica para generar folio automático
  void _generateFolioCode() async {
    // 1. Obtener cuántos folios tiene este usuario
    int count = await DatabaseHelper.instance.getFolioCount(widget.currentUserId);
    // 2. Sumar 1
    int nextNumber = count + 1;
    // 3. Formatear a 3 dígitos (ej: 1 -> "001")
    String code = nextNumber.toString().padLeft(3, '0');
    
    setState(() {
      _folioController.text = code;
    });
  }

  void _saveFolio() async {
    if (_folioController.text.isEmpty || _nombreController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('El Nombre es obligatorio'))
      );
      return;
    }

    Folio newFolio = Folio(
      folioCode: _folioController.text,
      nombreCliente: _nombreController.text,
      telefono: _telefonoController.text,
      equipo: _equipoController.text,
      descripcion: _descController.text,
      estado: 'Por reparar', // Estado inicial
      userId: widget.currentUserId, 
    );

    await DatabaseHelper.instance.createFolio(newFolio);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Folio guardado')));
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = const Color(0xFF671111);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFE0E0E0),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(15.0),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                decoration: BoxDecoration(color: primaryColor, borderRadius: BorderRadius.circular(10)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Registro', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
            ),

            Expanded(
              child: Stack(
                children: [
                  Positioned(
                    bottom: 0, left: 0,
                    child: ClipPath(
                      clipper: BottomCornerClipper(),
                      child: Container(width: size.width * 0.5, height: 100, color: primaryColor),
                    ),
                  ),
                  SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
                    child: Column(
                      children: [
                        // Folio es SOLO LECTURA (readOnly: true)
                        _buildCustomTextField(label: 'Folio', controller: _folioController, readOnly: true),
                        const SizedBox(height: 25),
                        _buildCustomTextField(label: 'Nombre', controller: _nombreController),
                        const SizedBox(height: 25),
                        _buildCustomTextField(label: 'Telefono', controller: _telefonoController, keyboardType: TextInputType.phone),
                        const SizedBox(height: 25),
                        _buildCustomTextField(label: 'Equipo', controller: _equipoController),
                        const SizedBox(height: 25),
                        _buildCustomTextField(label: 'Descripcion', controller: _descController, maxLines: 5),
                        const SizedBox(height: 40),

                        SizedBox(
                          width: 200,
                          child: ElevatedButton(
                            onPressed: _saveFolio,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF671111),
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                              elevation: 5,
                            ),
                            child: const Text('Guardar', style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w400)),
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

  Widget _buildCustomTextField({
    required String label,
    required TextEditingController controller,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    bool readOnly = false, // Nuevo parámetro
  }) {
    return Container(
      decoration: BoxDecoration(
        color: readOnly ? Colors.grey.shade200 : Colors.white, // Color gris si es solo lectura
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5))],
        border: Border.all(color: Colors.black12),
      ),
      child: TextField(
        controller: controller,
        readOnly: readOnly, // Bloquear edición
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