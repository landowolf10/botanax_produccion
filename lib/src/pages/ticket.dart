import 'dart:io';
import 'dart:typed_data';

import 'package:botanax_v5_9_produccion/src/pages/botanax.dart';
import 'package:botanax_v5_9_produccion/src/pages/firma2.dart';
import 'package:botanax_v5_9_produccion/src/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class FirmaPDF extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: PdfPreview(
          build: (format) => _generatePdf(),
        ),
      ),
    );
  }

  Future<Uint8List> _generatePdf() async
  {
    final pdf = pw.Document();
    GetBotana botana = new GetBotana();
    GetFirma firma = new GetFirma();
    GetIDUsuario user = new GetIDUsuario();
    Reembolsos reembolsos = new Reembolsos();

    final image = pw.MemoryImage(
      File('/storage/emulated/0/Android/data/com.example.botanax_v5_9_produccion/files/Signature/firma.png').readAsBytesSync(),
    );

    final imgLogo = pw.MemoryImage(
      (await rootBundle.load('img/botanaxLogo.png')).buffer.asUint8List()
    );

    pdf.addPage(
          pw.Page(
            pageFormat: PdfPageFormat.a4,
            build: (pw.Context context){
              return pw.ConstrainedBox(
                constraints: const pw.BoxConstraints.expand(),
                  child: pw.FittedBox(
                    child: pw.ListView(children: <pw.Widget>[
                          pw.Image(imgLogo),
                          pw.Text('Botanax del Puerto',
                            style: pw.TextStyle(
                              fontSize: 150
                            )
                          ),
                          pw.SizedBox(height: 5),
                          pw.Text('RFC: 454613545342154',
                          style: pw.TextStyle(
                              fontSize: 150
                            )
                          ),
                          pw.SizedBox(height: 5),
                          pw.Text('Ciudad Lázaron Cárdenas',
                          style: pw.TextStyle(
                              fontSize: 150
                            )
                          ),
                          pw.SizedBox(height: 5),
                          pw.Text('Col. Comunal Morelos',
                          style: pw.TextStyle(
                              fontSize: 150
                            )
                          ),
                          pw.Text(firma.formattedDate(),
                          style: pw.TextStyle(
                              fontSize: 150
                            )
                          ),
                          pw.SizedBox(height: 30),
                          pw.Text('Vendedor: ' + user.getNombreUsuario(),
                          style: pw.TextStyle(
                              fontSize: 150
                            )
                          ),
                          pw.Text("Cliente: " + botana.getClient(),
                          style: pw.TextStyle(
                              fontSize: 150
                            )
                          ),
                          pw.SizedBox(height: 70),
                          pw.Row(
                            children: <pw.Widget>[
                            //pw.SizedBox(width: 20),
                            pw.Column(children: <pw.Widget>[
                              pw.Text("Prod",
                                style: pw.TextStyle(
                                  fontSize: 150
                                )
                              ),
                              pw.SizedBox(height: 20),
                              pw.Paragraph(
                                text: botana
                                  .getProducts()
                                  .toString()
                                  .replaceAll(",", "\n")
                                  .replaceAll("[", " ")
                                  .replaceAll("]", ""),
                                style: pw.TextStyle(
                                  fontSize: 150
                                )
                              ),
                            ]),
                            pw.SizedBox(width: 20),
                            pw.Column(children: <pw.Widget>[
                              pw.Text("Cant", 
                              style: pw.TextStyle(
                                  fontSize: 150
                                )
                              ),
                              pw.SizedBox(height: 20),
                              pw.Paragraph(
                                text: botana
                                  .getQuantity()
                                  .toString()
                                  .replaceAll(",", "\n")
                                  .replaceAll("[", " ")
                                  .replaceAll("]", ""),
                                style: pw.TextStyle(
                                  fontSize: 150
                                )
                              ),
                            ]),
                            pw.SizedBox(width: 20),
                            pw.Column(children: <pw.Widget>[
                              pw.Text("P/U",
                                style: pw.TextStyle(
                                  fontSize: 150
                                )
                              ),
                              pw.SizedBox(height: 20),
                              pw.Paragraph(
                                text: botana
                                  .getPrices()
                                  .toString()
                                  .replaceAll(",", "\n")
                                  .replaceAll("[", " ")
                                  .replaceAll("]", ""),
                                style: pw.TextStyle(
                                  fontSize: 150
                                )
                              ),
                            ]),
                            pw.SizedBox(width: 150),
                            pw.Column(children: <pw.Widget>[
                              pw.Text("P/T",
                                style: pw.TextStyle(
                                  fontSize: 150
                                )
                              ),
                              pw.SizedBox(height: 20),
                              pw.Paragraph(
                                text: botana
                                  .getTotalPrices()
                                  .toString()
                                  .replaceAll(",", "\n")
                                  .replaceAll("[", " ")
                                  .replaceAll("]", ""),
                                style: pw.TextStyle(
                                    fontSize: 150
                                )
                              ),
                            ]),
                          ]),
                          pw.SizedBox(height: 70),
                          pw.Text("Total a pagar: \$" + botana.getTotal().toString(),
                            style: pw.TextStyle(
                              fontSize: 150
                            )
                          ),
                          pw.SizedBox(height: 200),
                          pw.Text("Cambios: ",
                            style: pw.TextStyle(
                              fontSize: 150
                            )
                          ),
                          pw.Row(children: <pw.Widget>[
                            //pw.SizedBox(width: 70),
                            pw.Column(children: <pw.Widget>[
                              pw.Text("Nombre producto",
                                style: pw.TextStyle(
                                  fontSize: 150
                                )
                              ),
                              //pw.SizedBox(height: 10),
                              pw.Paragraph(
                                text: reembolsos
                                  .getProduct()
                                  .toString()
                                  .replaceAll(",", "\n")
                                  .replaceAll("[", " ")
                                  .replaceAll("]", ""),
                                style: pw.TextStyle(
                                  fontSize: 150
                                )
                              ),
                            ]),
                            pw.SizedBox(width: 80),
                            pw.Column(children: <pw.Widget>[
                              pw.Text("Cantidad",
                                style: pw.TextStyle(
                                  fontSize: 150
                                )
                              ),
                              pw.SizedBox(height: 20),
                              pw.Paragraph(
                                text: reembolsos
                                  .getQuantity()
                                  .toString()
                                  .replaceAll(",", "\n")
                                  .replaceAll("[", " ")
                                  .replaceAll("]", ""),
                                style: pw.TextStyle(
                                  fontSize: 150
                                )  
                              ),
                            ])
                          ]),
                          pw.SizedBox(height: 20),
                          pw.Text("Firma del cliente",
                            style: pw.TextStyle(
                              fontSize: 150
                            )
                          ),
                          pw.Image(image),
                          pw.Text("Teléfono: 755 55 6 39 57",
                            style: pw.TextStyle(
                              fontSize: 150
                            )
                          ),
                        ])
                   )
              );
            }
          ),
        );

    return pdf.save();
  }
}