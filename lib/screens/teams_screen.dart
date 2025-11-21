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
  // Simulación del estado de los filtros (para la lógica)
  bool filterDelivered = false;
  bool filterPending = false;
  bool filterRepair = false;

  @override
  Widget build(BuildContext context) {
    final primaryColor = const Color(0xFF671111); // Color marrón/vino

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // PARTE SUPERIOR: Encabezado y Logo
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Encabezado con Menú de Acciones
                  buildHeaderWithActions(context, primaryColor),
                  const SizedBox(height: 15),

                  // 2. Logo COMPUSEG
                  Center(
                    child: Image.asset(
                      'assets/images/logo.png', // Logo que ya tienes
                      height: 80,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 3. Dropdown de Filtrar (Que abre el diálogo)
                  buildFilterDropdown(context, primaryColor),
                  const SizedBox(height: 10),
                ],
              ),
            ),

            // PARTE CENTRAL: Tabla de Datos
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black54),
                  ),
                  child: buildTeamsTable(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- WIDGETS AUXILIARES REVISADOS ---

  // 1. Encabezado con Botón de Menú Desplegable (Logout, Folio, Entrega)
  Widget buildHeaderWithActions(BuildContext context, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Equipos',
            style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.menu, color: Colors.white), // Ícono de menú de tres barras
            onSelected: (String result) {
              _handleMenuSelection(context, result);
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'Nuevo Folio',
                child: Row(children: [Icon(Icons.add), SizedBox(width: 8), Text('Nuevo Folio')]),
              ),
              const PopupMenuItem<String>(
                value: 'Entrega',
                child: Row(children: [Icon(Icons.delivery_dining), SizedBox(width: 8), Text('Entrega')]),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem<String>(
                value: 'Logout',
                child: Row(children: [Icon(Icons.logout), SizedBox(width: 8), Text('Cerrar Sesión')]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Lógica para manejar la navegación del menú desplegable
  void _handleMenuSelection(BuildContext context, String result) {
    if (result == 'Nuevo Folio') {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const NewFolioScreen()));
    } else if (result == 'Entrega') {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const DeliveryScreen()));
    } else if (result == 'Logout') {
      // TODO: Implementar lógica de deslogueo y regresar a Login
      Navigator.popUntil(context, (route) => route.isFirst); 
    }
  }

  // 2. Dropdown de Filtrar que abre el modal
  Widget buildFilterDropdown(BuildContext context, Color color) {
    return GestureDetector(
      onTap: () => _showFilterDialog(context), // Llama al diálogo al tocar
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5),
          color: Colors.white,
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Filtrar', style: TextStyle(color: Colors.black54)),
            Icon(Icons.arrow_drop_down, color: Colors.black54),
          ],
        ),
      ),
    );
  }

  // 3. Diálogo (Modal) que contiene los Checkboxes
  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Filtrar por Estado'),
          content: StatefulBuilder( // StatefulBuilder permite actualizar el diálogo
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  buildFilterCheckbox(setState, 'Entregadas', filterDelivered, (value) {
                    filterDelivered = value!;
                  }),
                  buildFilterCheckbox(setState, 'Por entregar', filterPending, (value) {
                    filterPending = value!;
                  }),
                  buildFilterCheckbox(setState, 'Por reparar', filterRepair, (value) {
                    filterRepair = value!;
                  }),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cerrar'),
            ),
            ElevatedButton(
              onPressed: () {
                // Al aplicar, se actualiza el estado de la pantalla principal
                // Y luego se cierra el diálogo
                Navigator.pop(context);
                setState(() {}); 
                // TODO: Llamar a la función de la BD para filtrar la tabla
              },
              child: const Text('Aplicar'),
            ),
          ],
        );
      },
    );
  }

  // 4. Widget auxiliar para los filtros de checkbox dentro del diálogo
  Widget buildFilterCheckbox(StateSetter dialogSetState, String title, bool value, ValueChanged<bool?> onChanged) {
    return Row(
      children: [
        Checkbox(
          value: value,
          onChanged: (bool? newValue) {
            dialogSetState(() { // Actualiza el estado dentro del diálogo
              onChanged(newValue);
            });
          },
          activeColor: Theme.of(context).primaryColor,
        ),
        Text(title),
      ],
    );
  }
  
  // 5. Widget para construir la Tabla (El mismo de antes)
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
                underline: Container(),
                isDense: true,
                items: ['Por reparar', 'Por entregar', 'Entregada'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: TextStyle(
                      fontSize: 12,
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