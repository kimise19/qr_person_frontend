import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class Person {
  final String? nombre;
  final String? apellido;
  final String? cedula;
  bool isFound;

  Person({
    required this.nombre,
    required this.apellido,
    required this.cedula,
    this.isFound = false,
  });

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      nombre: json['nombre'],
      apellido: json['apellido'],
      cedula: json['cedula'],
    );
  }
}

class ListPersonsPage extends StatefulWidget {
  @override
  _ListPersonsPageState createState() => _ListPersonsPageState();
}

class _ListPersonsPageState extends State<ListPersonsPage> {
  List<Person> persons = [];
  int counter = 0;

  Future<void> fetchPersons() async {
    final response =
        await http.get(Uri.parse('http://192.168.101.10:3000/api/personas'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      persons = jsonData.map((data) => Person.fromJson(data)).toList();
      counter = persons.length;
      setState(() {});
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> scanQRCode() async {
    String scannedCedula = await FlutterBarcodeScanner.scanBarcode(
      '#ff6666',
      'Cancelar',
      true,
      ScanMode.QR,
    );

    if (scannedCedula != '-1') {
      Person foundPerson = persons.firstWhere(
          (person) => person.cedula == scannedCedula,
          orElse: () => Person(nombre: '', apellido: '', cedula: ''));

      if (foundPerson.nombre!.isNotEmpty) {
        setState(() {
          foundPerson.isFound = true;
          counter--; // Restar 1 al contador
        });

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Usuario Encontrado'),
              content: Text(
                  'Cédula: ${foundPerson.cedula}\nNombre: ${foundPerson.nombre} ${foundPerson.apellido}'),
            );
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Usuario no Encontrado'),
              content: Text('El usuario con cédula $scannedCedula no existe.'),
            );
          },
        );
      }
    }
  }

  @override
  void initState() {
    fetchPersons();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Personas'),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                Text(
                  'Personas: $counter/${persons.length}',
                  style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: scanQRCode,
                  child: Text('Escanear QR'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: persons.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  color: persons[index].isFound ? Colors.green : Colors.red,
                  padding: EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(
                      '${persons[index].nombre} ${persons[index].apellido}',
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      'Cédula: ${persons[index].cedula}',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
