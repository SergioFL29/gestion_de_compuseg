import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/folio_model.dart';
import 'package:url_launcher/url_launcher.dart';

class DeliveryScreen extends StatefulWidget {
  final int currentUserId; // Recibimos el usuario actual

  const DeliveryScreen({super.key, required this.currentUserId});

  @override
  State<DeliveryScreen> createState() => _DeliveryScreenState();
}

class _DeliveryScreenState extends State<DeliveryScreen> {
  // Listas para guardar los datos de la base de datos
  List<Folio> pendingFolios = []; 
  List<String> phoneNumbers = [];

  // Controladores
  final _nombreController = TextEditingController();
  final _obsController = TextEditingController();
  final _precioController = TextEditingController();
  
  // Guardamos el folio seleccionado para poder actualizarlo
  Folio? selectedFolio;

  @override
  void initState() {
    super.initState();
    _loadPendingFolios();
  }

  // Cargar folios que NO están entregados
 void _loadPendingFolios() async {
    // 1. Cambiamos getFoliosByUserId por getFoliosFull
    final List<Map<String, dynamic>> data = await DatabaseHelper.instance.getFoliosFull(widget.currentUserId);
    
    setState(() {
      // 2. Convertimos los mapas a objetos Folio manualmente
      List<Folio> allFolios = data.map((json) => Folio(
        id: json['id'],
        folioCode: json['folioCode'],
        nombreCliente: json['nombre'], // Viene del JOIN de la tabla clientes
        telefono: json['telefono'],    // Viene del JOIN de la tabla clientes
        equipo: json['equipo'],
        descripcion: json['descripcion'],
        estado: json['estado'],
        userId: json['userId'],
      )).toList();

      // 3. Filtramos los que no han sido entregados
      pendingFolios = allFolios.where((f) => f.estado != 'Entregada').toList();
      
      // 4. Extraemos los teléfonos únicos
      phoneNumbers = pendingFolios.map((f) => f.telefono).toSet().toList();
    });
  }
void _showEquipmentPicker(List<Folio> foliosDelCliente) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Seleccionar Equipo'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: foliosDelCliente.length,
              itemBuilder: (context, index) {
                final f = foliosDelCliente[index];
                return ListTile(
                  title: Text(f.equipo),
                  subtitle: Text('Folio: ${f.folioCode} - ${f.estado}'),
                  onTap: () {
                    setState(() {
                      selectedFolio = f;
                      _nombreController.text = f.nombreCliente;
                    });
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
  // Guardar la entrega
void _saveDelivery() async {
    if (selectedFolio == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor busca y selecciona un teléfono válido'))
      );
      return;
    }

    String observaciones = _obsController.text.trim();
    String precio = _precioController.text.trim();
    
    if (observaciones.isEmpty) observaciones = "Reparación finalizada";
    if (precio.isEmpty) precio = "0.00";

    try {
      // 1. Cambiamos el estado a 'Lista' en lugar de 'Entregada'
      await DatabaseHelper.instance.updateFolioStatus(selectedFolio!.id!, 'Lista');

      // 2. Enviamos el mensaje con el precio real
      await _sendWhatsAppReceipt(selectedFolio!, observaciones, precio);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('¡Equipo marcado como LISTO y aviso enviado!'))
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'))
      );
    }
  }
Future<void> _sendWhatsAppReceipt(Folio folio, String obs, String costo) async {
    final phone = folio.telefono.replaceAll(RegExp(r'\D'), '');
    
    // Formato de recibo profesional
    final String message = 
       "✅ *COMPUSEG - EQUIPO LISTO*\n"
        "------------------------------------------\n"
        "Estimado cliente, su equipo ya está reparado.\n"
        "------------------------------------------\n"
        "📄 *Folio:* ${folio.folioCode}\n"
        "💻 *Equipo:* ${folio.equipo}\n"
        "🔧 *Servicio:* $obs\n"
        "💰 *Total a pagar:* \$$costo\n"
        "------------------------------------------\n"
        "📦 *Estado:* LISTO PARA ENTREGA\n"
        "------------------------------------------\n"
        "¡Le esperamos en Compuseg!";

    final Uri whatsappUrl = Uri.parse(
      "https://wa.me/52$phone?text=${Uri.encodeComponent(message)}"
    );

    if (await canLaunchUrl(whatsappUrl)) {
      await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
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
            // --- ENCABEZADO ---
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
                    const Text('Entrega', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
            ),

            // --- FORMULARIO ---
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
                        
                        // 1. EL BUSCADOR DE TELÉFONOS (AUTOCOMPLETADO)
                        _buildSearchAutocomplete(),
                        const SizedBox(height: 25),

                        // 2. Campo Nombre (Se llena solo, es de lectura)
                        _buildCustomTextField(label: 'Nombre', controller: _nombreController, readOnly: true),
                        const SizedBox(height: 25),

                        // 3. Campo Equipo (Se llena solo visualmente)
                        _buildEquipoDisplay(),
                        const SizedBox(height: 25),

                        // 4. Observaciones
                        _buildCustomTextField(label: 'Observaciones', controller: _obsController, maxLines: 5),
                        const SizedBox(height: 40),
                        // Nuevo campo para el Precio
                       _buildCustomTextField(
                       label: 'Costo de reparación (\$)', 
                       controller: _precioController,
                       keyboardType: TextInputType.number, // Para que salga el teclado numérico
                       ),

                       const SizedBox(height: 40),

                        // Botón Guardar
                        SizedBox(
                          width: 200,
                          child: ElevatedButton(
                            onPressed: _saveDelivery,
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

  // --- WIDGET: BUSCADOR AUTOCOMPLETADO ---
  Widget _buildSearchAutocomplete() {
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        // CAMBIO AQUÍ: Si el texto está vacío, mostramos TODOS los números
        if (textEditingValue.text.isEmpty) {
          return phoneNumbers; 
        }
        // Si escribió algo, filtramos
        return phoneNumbers.where((String option) {
          return option.contains(textEditingValue.text);
        });
      },
      // Esto es para que la lista aparezca apenas tocas el campo
      displayStringForOption: (String option) => option,
      onSelected: (String selection) {
        // Buscamos todos los folios de este teléfono
        final foliosDelCliente = pendingFolios.where((f) => f.telefono == selection).toList();
        
        if (foliosDelCliente.length > 1) {
          // Si tiene más de uno, podríamos mostrar un diálogo para elegir
          _showEquipmentPicker(foliosDelCliente);
        } else {
          setState(() {
            selectedFolio = foliosDelCliente.first;
            _nombreController.text = selectedFolio!.nombreCliente;
          });
        }
      },
      fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5))],
            border: Border.all(color: Colors.black12),
          ),
          child: TextField(
            controller: textEditingController,
            focusNode: focusNode,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              hintText: 'Toca para ver teléfonos',
              hintStyle: TextStyle(color: Colors.black38),
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              border: InputBorder.none,
              suffixIcon: Icon(Icons.arrow_drop_down, color: Colors.black54), // Icono de flecha
            ),
          ),
        );
      },
      // Personalizamos cómo se ve la lista desplegable
      optionsViewBuilder: (context, onSelected, options) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 4.0,
            child: SizedBox(
              height: 200, // Altura de la lista
              width: MediaQuery.of(context).size.width - 60, // Ancho ajustado
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: options.length,
                itemBuilder: (BuildContext context, int index) {
                  final String option = options.elementAt(index);
                  return ListTile(
                    title: Text(option),
                    onTap: () => onSelected(option),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  // --- WIDGET: Mostrar el Equipo asociado ---
  Widget _buildEquipoDisplay() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.grey.shade200, // Gris porque es de solo lectura
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.black12),
      ),
      child: Text(
        selectedFolio != null ? selectedFolio!.equipo : 'Equipo (Selecciona un teléfono)',
        style: TextStyle(
          color: selectedFolio != null ? Colors.black : Colors.black38,
          fontSize: 16,
        ),
      ),
    );
  }

  // --- WIDGET: Campo de Texto ---
Widget _buildCustomTextField({
    required String label,
    required TextEditingController controller,
    int maxLines = 1,
    bool readOnly = false,
    TextInputType keyboardType = TextInputType.text, // <--- AGREGA ESTA LÍNEA
  }) {
    return Container(
      decoration: BoxDecoration(
        color: readOnly ? Colors.grey.shade200 : Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5))],
        border: Border.all(color: Colors.black12),
      ),
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        maxLines: maxLines,
        keyboardType: keyboardType, // <--- Y USA EL PARÁMETRO AQUÍ
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