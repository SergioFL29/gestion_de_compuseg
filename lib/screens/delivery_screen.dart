import 'package:flutter/material.dart';

class DeliveryScreen extends StatelessWidget {
  const DeliveryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Entrega'),
        backgroundColor: const Color(0xFF671111),
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Pantalla de Entrega (En construcción)'),
      ),
    );
  }
}