import 'package:flutter/material.dart';

class NewFolioScreen extends StatelessWidget {
  const NewFolioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nuevo Folio'),
        backgroundColor: const Color(0xFF671111),
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Pantalla de Nuevo Folio (En construcción)'),
      ),
    );
  }
}