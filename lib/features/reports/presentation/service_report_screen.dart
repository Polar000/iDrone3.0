import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../../app/theme/app_colors.dart';

class ServiceReportScreen extends StatelessWidget {
  const ServiceReportScreen({super.key});

  Future<Uint8List> _generatePdfReport() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Header(
                level: 0,
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('iDrone Guatemala', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold, color: PdfColors.teal900)),
                    pw.Text('Reporte de Servicio Agrícola', style: pw.TextStyle(fontSize: 14, color: PdfColors.grey700)),
                  ],
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Text('Cliente: Bryan Morales', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
              pw.Text('Finca: Finca El Retiro — Parcela Sur'),
              pw.Text('Cultivo: Café'),
              pw.Text('Servicio: Monitoreo agrícola multiespectral'),
              pw.Text('Área tratada: 15.00 manzanas (10.48 ha)'),
              pw.Text('Fecha: 24 de Febrero de 2026'),
              pw.Text('Operador: Carlos Ramos • Dron: DJI Agras T40'),
              pw.SizedBox(height: 20),
              pw.Divider(),
              pw.SizedBox(height: 10),
              pw.Text('Resumen de Ejecución:', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 8),
              pw.Text('Se realizó el vuelo de monitoreo multiespectral cubriendo el 100% de la parcela planificada. Las fotos y datos de NDVI han sido procesados satisfactoriamente.'),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(title: const Text('Reporte del Servicio')),
      body: PdfPreview(
        build: (format) => _generatePdfReport(),
        allowPrinting: true,
        allowSharing: true,
      ),
    );
  }
}
