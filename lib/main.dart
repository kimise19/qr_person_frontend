import 'package:flutter/material.dart';
import 'package:qr_personas/src/list_person.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Navegación de Ejemplo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ListPersonsPage(), // Mostrar la página de inicio de sesión primero
    );
  }
}
