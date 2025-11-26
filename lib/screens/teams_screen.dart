import 'package:flutter/material.dart';

// Importa las pantallas que vamos a necesitar
import '../models/user_model.dart';   // <--- Importar modelo de Usuario
import '../models/folio_model.dart';
import './new_folio_screen.dart'; // Crearemos esta después
import './delivery_screen.dart'; // Crearemos esta después
import './login_screens.dart';
import '../database/database_helper.dart';

class TeamsScreen extends StatefulWidget {
  final User currentUser; 

  const TeamsScreen({super.key, required this.currentUser});

  @override
  State<TeamsScreen> createState() => _TeamsScreenState();
}

class _TeamsScreenState extends State<TeamsScreen> {
  // Filtros
  bool filterDelivered = false;
  bool filterPending = false;
  bool filterRepair = false;

  // Listas de datos
  List<Folio> allFolios = [];      // Todos los datos de la BD
  List<Folio> displayedFolios = []; // Los datos que se ven en la tabla (filtrados)
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _refreshFolios();
  }

  // Cargar datos de la BD
  Future<void> _refreshFolios() async {
    setState(() => isLoading = true);
    if (widget.currentUser.id != null) {
      // 1. Obtenemos TODOS los folios del usuario
      allFolios = await DatabaseHelper.instance.getFoliosByUserId(widget.currentUser.id!);
      // 2. Aplicamos los filtros actuales para decidir qué mostrar
      _applyFilters();
    }
    setState(() => isLoading = false);
  }

  // Lógica de Filtrado Combinado
  void _applyFilters() {
    // Si NINGÚN filtro está marcado, mostramos TODO (o puedes cambiarlo a mostrar nada)
    if (!filterDelivered && !filterPending && !filterRepair) {
      displayedFolios = List.from(allFolios);
    } else {
      // Si hay filtros marcados, filtramos la lista original
      displayedFolios = allFolios.where((folio) {
        if (filterDelivered && folio.estado == 'Entregada') return true;
        if (filterPending && folio.estado == 'Por entregar') return true;
        if (filterRepair && folio.estado == 'Por reparar') return true;
        return false;
      }).toList();
    }
  }

  // Actualizar estado en BD desde la tabla
  void _updateStatus(Folio folio, String newStatus) async {
    await DatabaseHelper.instance.updateFolioStatus(folio.id!, newStatus);
    // Recargamos los datos para asegurar que todo esté sincronizado
    _refreshFolios();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = const Color(0xFF671111);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildHeaderWithActions(context, primaryColor),
                  const SizedBox(height: 15),
                  Center(
                    child: Image.asset('assets/images/logo.png', height: 200),
                  ),
                  const SizedBox(height: 20),
                  buildFilterDropdown(context, primaryColor),
                  const SizedBox(height: 10),
                ],
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
                child: Container(
                  decoration: BoxDecoration(border: Border.all(color: Colors.black54)),
                  child: isLoading 
                      ? const Center(child: CircularProgressIndicator()) 
                      : buildTeamsTable(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildHeaderWithActions(BuildContext context, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Equipos', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
          PopupMenuButton<String>(
            icon: const Icon(Icons.menu, color: Colors.white),
            onSelected: (String result) => _handleMenuSelection(context, result),
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(value: 'Nuevo Folio', child: Row(children: [Icon(Icons.add), SizedBox(width: 8), Text('Nuevo Folio')])),
              const PopupMenuItem<String>(value: 'Entrega', child: Row(children: [Icon(Icons.delivery_dining), SizedBox(width: 8), Text('Entrega')])),
              const PopupMenuDivider(),
              const PopupMenuItem<String>(value: 'Logout', child: Row(children: [Icon(Icons.logout), SizedBox(width: 8), Text('Cerrar Sesión')])),
            ],
          ),
        ],
      ),
    );
  }

  void _handleMenuSelection(BuildContext context, String result) async {
    if (result == 'Nuevo Folio') {
      final bool? result = await Navigator.push(
        context, 
        MaterialPageRoute(builder: (context) => NewFolioScreen(currentUserId: widget.currentUser.id!))
      );
      if (result == true) _refreshFolios();
    } else if (result == 'Entrega') {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const DeliveryScreen()));
    } else if (result == 'Logout') {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false, 
      );
    }
  }

  Widget buildFilterDropdown(BuildContext context, Color color) {
    return GestureDetector(
      onTap: () => _showFilterDialog(context),
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(5), color: Colors.white),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text('Filtrar', style: TextStyle(color: Colors.black54)), Icon(Icons.arrow_drop_down, color: Colors.black54)],
        ),
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Filtrar por Estado'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  buildFilterCheckbox(setState, 'Entregadas', filterDelivered, (v) => filterDelivered = v!),
                  buildFilterCheckbox(setState, 'Por entregar', filterPending, (v) => filterPending = v!),
                  buildFilterCheckbox(setState, 'Por reparar', filterRepair, (v) => filterRepair = v!),
                ],
              );
            },
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cerrar')),
            ElevatedButton(
              onPressed: () { 
                Navigator.pop(context); 
                // Al cerrar el diálogo, aplicamos los filtros a la lista principal
                setState(() {
                  _applyFilters(); 
                }); 
              }, 
              child: const Text('Aplicar')
            ),
          ],
        );
      },
    );
  }

  Widget buildFilterCheckbox(StateSetter dialogSetState, String title, bool value, ValueChanged<bool?> onChanged) {
    return Row(
      children: [
        Checkbox(
          value: value,
          onChanged: (bool? newValue) {
            dialogSetState(() { onChanged(newValue); });
          },
          activeColor: Theme.of(context).primaryColor,
        ),
        Text(title),
      ],
    );
  }
void _showFolioDetails(Folio folio) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Container(
            padding: const EdgeInsets.only(bottom: 10),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xFF671111), width: 2)),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: Color(0xFF671111)),
                const SizedBox(width: 10),
                Text('Folio ${folio.folioCode}', style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min, // Se ajusta al contenido
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow(Icons.computer, 'Equipo:', folio.equipo),
              const SizedBox(height: 15),
              _buildDetailRow(Icons.person, 'Cliente:', folio.nombreCliente),
              const SizedBox(height: 15),
              _buildDetailRow(Icons.phone, 'Teléfono:', folio.telefono),
              const SizedBox(height: 15),
              const Text('Descripción:', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF671111))),
              const SizedBox(height: 5),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.black12),
                ),
                child: Text(folio.descripcion),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cerrar', style: TextStyle(color: Color(0xFF671111), fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  // Widget auxiliar para las filas del diálogo
  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 10),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(color: Colors.black, fontSize: 16),
              children: [
                TextSpan(text: '$label ', style: const TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: value),
              ],
            ),
          ),
        ),
      ],
    );
  }

Widget buildTeamsTable() {
    if (displayedFolios.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Text(
            'No hay equipos con estos filtros.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columnSpacing: 25,
          horizontalMargin: 15,
          dataRowMinHeight: 60,
          dataRowMaxHeight: 60,
          headingRowHeight: 55,
          border: TableBorder.all(color: Colors.black12, width: 1),
          
          columns: const [
            DataColumn(label: Text('Folio', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
            DataColumn(label: Text('Máquina', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
            DataColumn(label: Text('Estado', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
          ],
          rows: displayedFolios.map((folio) {
            return DataRow(
              cells: [
                // 1. Celda Folio
                DataCell(Text(folio.folioCode, style: const TextStyle(fontSize: 15))),
                
                // 2. Celda Máquina (¡AQUÍ ESTÁ EL CAMBIO!)
                DataCell(
                  Row(
                    children: [
                      Text(folio.equipo, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                      const SizedBox(width: 5),
                      // Icono pequeño para indicar que se puede tocar
                      const Icon(Icons.info, size: 16, color: Colors.blueGrey), 
                    ],
                  ),
                  // Acción al tocar la celda
                  onTap: () {
                    _showFolioDetails(folio);
                  },
                ),

                // 3. Celda Estado
                DataCell(
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButton<String>(
                      value: folio.estado,
                      isDense: true,
                      underline: Container(),
                      icon: const Icon(Icons.arrow_drop_down, size: 24),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: folio.estado == 'Por reparar' ? Colors.red.shade700 
                             : folio.estado == 'Por entregar' ? Colors.amber.shade800 
                             : Colors.green.shade700
                      ),
                      items: ['Por reparar', 'Por entregar', 'Entregada'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          _updateStatus(folio, newValue);
                        }
                      },
                    ),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}