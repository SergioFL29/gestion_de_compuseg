import 'package:flutter/material.dart';

// Esta clase define la forma diagonal que necesitamos.
class DiagonalClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    // 1. Crea un camino (Path) que define la forma a dibujar.
    final path = Path();

    // 2. Comienza en la esquina superior izquierda (0, 0)
    path.lineTo(0, size.height); 

    // 3. Dibuja la línea diagonal: comienza en la parte inferior izquierda 
    //    y termina en un punto del 40% de la altura en la derecha.
    //    Este punto define el ángulo de la diagonal.
    path.lineTo(size.width, size.height * 0.40); 

    // 4. Cierra la forma subiendo hasta la esquina superior derecha
    path.lineTo(size.width, 0); 

    // 5. Cierra el camino de vuelta a (0, 0)
    path.close();

    return path;
  }

  @override
  bool shouldReclip(DiagonalClipper oldClipper) => false;
}