import 'package:flutter/material.dart';
// ¡Asegúrate que el nombre 'gestion_de_compuseg' coincida con el nombre de tu proyecto!
import 'package:gestion_de_compuseg/screens/login_screens.dart'; 

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'COMPUSEG App',
      theme: ThemeData(
        // Tema general: El color primario se puede usar para botones y enfoque
        primarySwatch: Colors.red,
        primaryColor: const Color(0xFF671111), 
      ),
      // La pantalla inicial de la aplicación es el Login
      home: const LoginScreen(), 
    );
  }
}