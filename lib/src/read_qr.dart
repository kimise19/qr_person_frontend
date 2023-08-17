import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class QrReaderPage extends StatefulWidget {
  @override
  _QrReaderPageState createState() => _QrReaderPageState();
}

class _QrReaderPageState extends State<QrReaderPage> {
  String cedula = '';

  Future<void> scanQrCode() async {
    String qrCode = await FlutterBarcodeScanner.scanBarcode(
      '#ff6666', // Color personalizado para la pantalla de escaneo
      'Cancelar', // Texto del botón de cancelar
      true, // Usar la cámara trasera
      ScanMode.QR, // Tipo de código para escanear
    );

    if (!mounted) return; // Verificar si el widget está montado

    setState(() {
      cedula = qrCode; // Actualizar la cédula escaneada
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lector de QR'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Cédula escaneada:',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              cedula,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: scanQrCode,
              child: Text('Escanear QR'),
            ),
          ],
        ),
      ),
    );
  }
}
