import 'package:flutter/material.dart';

// Importa las pantallas que vamos a necesitar
import './new_folio_screen.dart'; // Crearemos esta después
import './delivery_screen.dart'; // Crearemos esta después

class TeamsScreen extends StatefulWidget {
  const TeamsScreen({super.key});

  @override
  State<TeamsScreen> createState() => _TeamsScreenState();
}

class _TeamsScreenState extends State<TeamsScreen> {
  // Simulación de los estados del filtro
  bool filterDelivered = false;
  bool filterPending = false;
  bool filterRepair = false;

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor; // Color vino/marrón
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // PARTE SUPERIOR: Encabezado, Logo y Botones de Acción
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Encabezado (Color Marrón/Vino en el fondo)
                  Container(
                    width: size.width,
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Equipos',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        // Botón de Salida (Logout)
                        IconButton(
                          icon: const Icon(Icons.logout, color: Colors.white),
                          onPressed: () {
                            // TODO: Implementar Logout y regresar a Login
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),

                  // Logo COMPUSEG (Simulado)
                  Image.asset(
                    'assets/images/logo.png', // Usa el logo que ya tienes
                    height: 80,
                  ),
                  const SizedBox(height: 20),

                  // Fila de Botones: Nuevo Folio y Entrega
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Botón Nuevo Folio
                      buildActionButton(context, 'Nuevo Folio', primaryColor, Icons.add, () {
                        // Navegar a la pantalla de Nuevo Folio
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => const NewFolioScreen())); 
                      }),
                      const SizedBox(width: 10),
                      // Botón Entrega
                      buildActionButton(context, 'Entrega', primaryColor, Icons.delivery_dining, () {
                        // Navegar a la pantalla de Entrega
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => const DeliveryScreen()));
                      }),
                    ],
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),

            // PARTE CENTRAL: Filtros y Tabla
            Expanded(
              child: Row(
                children: [
                  // COLUMNA 1: Tabla de Equipos (Ocupa la mayor parte del espacio)
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15, right: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Dropdown de Filtrar (Simulado)
                          Container(
                            height: 40,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                isExpanded: true,
                                value: 'Filtrar',
                                items: [
                                  DropdownMenuItem(value: 'Filtrar', child: Text('Filtrar')),
                                ],
                                onChanged: null,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          
                          // TABLA DE DATOS (Lista de Equipos)
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black54),
                              ),
                              child: buildTeamsTable(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // COLUMNA 2: Opciones de Filtro (Checkboxes)
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: const EdgeInsets.only(right: 15, left: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Filtros:', style: TextStyle(fontWeight: FontWeight.bold)),
                          buildFilterCheckbox('Entregadas', filterDelivered, (value) {
                            setState(() => filterDelivered = value!);
                          }),
                          buildFilterCheckbox('Por entregar', filterPending, (value) {
                            setState(() => filterPending = value!);
                          }),
                          buildFilterCheckbox('Por reparar', filterRepair, (value) {
                            setState(() => filterRepair = value!);
                          }),
                        ],
                      ),
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
  
  // Widget auxiliar para los botones de acción (Nuevo Folio, Entrega)
  Widget buildActionButton(BuildContext context, String text, Color color, IconData icon, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 5,
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16, color: Colors.white),
      ),
    );
  }

  // Widget auxiliar para los filtros de checkbox
  Widget buildFilterCheckbox(String title, bool value, ValueChanged<bool?> onChanged) {
    return Row(
      children: [
        Checkbox(
          value: value,
          onChanged: onChanged,
          activeColor: Theme.of(context).primaryColor,
        ),
        Text(title, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  // Widget para construir la Tabla (Simulación)
  Widget buildTeamsTable() {
    // Definimos las columnas de la tabla (simulado para el diseño)
    List<Map<String, String>> mockData = [
      {'Folio': 'HGT02', 'Maquina': 'Asus', 'Estado': 'Por reparar'},
      {'Folio': 'AVT21', 'Maquina': 'Lenovo', 'Estado': 'Por entregar'},
      {'Folio': 'VFD12', 'Maquina': 'HP', 'Estado': 'Entregada'},
      // Añadir más filas vacías para simular la altura de la tabla
      {'Folio': '', 'Maquina': '', 'Estado': ''},
      {'Folio': '', 'Maquina': '', 'Estado': ''},
      {'Folio': '', 'Maquina': '', 'Estado': ''},
      {'Folio': '', 'Maquina': '', 'Estado': ''},
      {'Folio': '', 'Maquina': '', 'Estado': ''},
    ];

    return DataTable(
      columnSpacing: 10,
      horizontalMargin: 10,
      dataRowMinHeight: 35,
      dataRowMaxHeight: 35,
      headingRowHeight: 40,
      columns: const [
        DataColumn(label: Text('Folio', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13))),
        DataColumn(label: Text('Maquina', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13))),
        DataColumn(label: Text('Estado', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13))),
      ],
      rows: mockData.map((data) {
        return DataRow(
          cells: [
            DataCell(Text(data['Folio']!, style: const TextStyle(fontSize: 12))),
            DataCell(Text(data['Maquina']!, style: const TextStyle(fontSize: 12))),
            DataCell(
              DropdownButton<String>(
                value: data['Estado']!.isNotEmpty ? data['Estado'] : null,
                hint: const Text('Estado'),
                underline: Container(), // Quita la línea del dropdown
                isDense: true,
                items: ['Por reparar', 'Por entregar', 'Entregada'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: TextStyle(
                      fontSize: 12,
                      // Simulación de color para el estado
                      color: value == 'Por reparar' ? Colors.red.shade700 : 
                             value == 'Por entregar' ? Colors.amber.shade700 : 
                             value == 'Entregada' ? Colors.green.shade700 : Colors.black
                    )),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  // TODO: Implementar lógica de cambio de estado en la BD
                },
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}