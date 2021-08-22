import 'package:botanax_v5_9_produccion/src/pages/botanax.dart';
import 'package:botanax_v5_9_produccion/src/pages/firma2.dart';
import 'package:botanax_v5_9_produccion/src/pages/funciones.dart';
import 'package:botanax_v5_9_produccion/src/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart' as pdfLib;
import 'package:pdf/pdf.dart';
import 'dart:io';
import 'package:image/image.dart' as obtenerFirma;
import 'package:flutter/rendering.dart';
import 'package:printing/printing.dart';

class FirmaPDF extends StatefulWidget {
  @override
  FirmaPDFPageState createState() => new FirmaPDFPageState();
}

class FirmaPDFPageState extends State<FirmaPDF> 
{
  @override
  Widget build(BuildContext context) {
    final logo = Hero(
      tag: "hero",
      child: Image.asset("img/botanaxLogo.png"),
    );

    return new Scaffold(
        backgroundColor: Colors.white,
        body: new Container(
            alignment: Alignment.center,
            child: Column(
              children: <Widget>[
                logo,
                SizedBox(height: 150),
                new ButtonTheme(
                  minWidth: 200.0,
                  height: 100.0,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    color: Colors.red,
                    child: Text("MOSTRAR TICKET",
                        style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      _printDocument();

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Funciones()),
                      );
                    },
                  ),
                )
              ],
            )
        )
    );
  }

  void _printDocument()
  {
    Printing.layoutPdf(
      onLayout: (pageFormat) async
      {
        final doc = pdfLib.Document();

        GetBotana botana = new GetBotana();
        GetFirma firma = new GetFirma();
        GetIDUsuario user = new GetIDUsuario();
        Reembolsos reembolsos = new Reembolsos();

        //final img = firma.getSign().readAsBytesSync();

        /*final image = PdfImage(
          doc.document,
          image: img,
          width: 60,
          height: 60,
        );*/

        //final image = PdfImage.file(doc.document, bytes: File('/storage/emulated/0/Android/data/com.example.botanax_v5_9_produccion/files/Signature/firma.png').readAsBytesSync());

        final image = pdfLib.MemoryImage(
          File('/storage/emulated/0/Android/data/com.example.botanax_v5_9_produccion/files/Signature/firma.png').readAsBytesSync(),
        );

        //final imgLogo = await flutterImageProvider(NetworkImage('img/botanaxLogo.png'));

        final imgLogo = pdfLib.MemoryImage(
          (await rootBundle.load('img/botanaxLogo.png')).buffer.asUint8List()
        );

        doc.addPage(
          pdfLib.Page(
            pageFormat: PdfPageFormat.a4,
            build: (pdfLib.Context context){
              return pdfLib.ConstrainedBox(
                constraints: const pdfLib.BoxConstraints.expand(),
                  child: pdfLib.FittedBox(
                    child: pdfLib.ListView(children: <pdfLib.Widget>[
                          pdfLib.Image(imgLogo),
                          pdfLib.Text('Botanax del Puerto',
                            style: pdfLib.TextStyle(
                              fontSize: 150
                            )
                          ),
                          pdfLib.SizedBox(height: 5),
                          pdfLib.Text('RFC: 454613545342154',
                          style: pdfLib.TextStyle(
                              fontSize: 150
                            )
                          ),
                          pdfLib.SizedBox(height: 5),
                          pdfLib.Text('Ciudad Lázaron Cárdenas',
                          style: pdfLib.TextStyle(
                              fontSize: 150
                            )
                          ),
                          pdfLib.SizedBox(height: 5),
                          pdfLib.Text('Col. Comunal Morelos',
                          style: pdfLib.TextStyle(
                              fontSize: 150
                            )
                          ),
                          pdfLib.Text(firma.formattedDate(),
                          style: pdfLib.TextStyle(
                              fontSize: 150
                            )
                          ),
                          pdfLib.SizedBox(height: 30),
                          pdfLib.Text('Vendedor: ' + user.getNombreUsuario(),
                          style: pdfLib.TextStyle(
                              fontSize: 150
                            )
                          ),
                          pdfLib.Text("Cliente: " + botana.getClient(),
                          style: pdfLib.TextStyle(
                              fontSize: 150
                            )
                          ),
                          pdfLib.SizedBox(height: 70),
                          pdfLib.Row(
                            children: <pdfLib.Widget>[
                            //pdfLib.SizedBox(width: 20),
                            pdfLib.Column(children: <pdfLib.Widget>[
                              pdfLib.Text("Prod",
                                style: pdfLib.TextStyle(
                                  fontSize: 150
                                )
                              ),
                              pdfLib.SizedBox(height: 20),
                              pdfLib.Paragraph(
                                text: botana
                                  .getProducts()
                                  .toString()
                                  .replaceAll(",", "\n")
                                  .replaceAll("[", " ")
                                  .replaceAll("]", ""),
                                style: pdfLib.TextStyle(
                                  fontSize: 150
                                )
                              ),
                            ]),
                            pdfLib.SizedBox(width: 20),
                            pdfLib.Column(children: <pdfLib.Widget>[
                              pdfLib.Text("Cant", 
                              style: pdfLib.TextStyle(
                                  fontSize: 150
                                )
                              ),
                              pdfLib.SizedBox(height: 20),
                              pdfLib.Paragraph(
                                text: botana
                                  .getQuantity()
                                  .toString()
                                  .replaceAll(",", "\n")
                                  .replaceAll("[", " ")
                                  .replaceAll("]", ""),
                                style: pdfLib.TextStyle(
                                  fontSize: 150
                                )
                              ),
                            ]),
                            pdfLib.SizedBox(width: 20),
                            pdfLib.Column(children: <pdfLib.Widget>[
                              pdfLib.Text("P/u",
                                style: pdfLib.TextStyle(
                                  fontSize: 150
                                )
                              ),
                              pdfLib.SizedBox(height: 20),
                              pdfLib.Paragraph(
                                text: botana
                                  .getPrices()
                                  .toString()
                                  .replaceAll(",", "\n")
                                  .replaceAll("[", " ")
                                  .replaceAll("]", ""),
                                style: pdfLib.TextStyle(
                                  fontSize: 150
                                )
                              ),
                            ]),
                            pdfLib.SizedBox(width: 150),
                            pdfLib.Column(children: <pdfLib.Widget>[
                              pdfLib.Text("P/t",
                                style: pdfLib.TextStyle(
                                  fontSize: 150
                                )
                              ),
                              pdfLib.SizedBox(height: 20),
                              pdfLib.Paragraph(
                                text: botana
                                  .getTotalPrices()
                                  .toString()
                                  .replaceAll(",", "\n")
                                  .replaceAll("[", " ")
                                  .replaceAll("]", ""),
                                style: pdfLib.TextStyle(
                                    fontSize: 150
                                )
                              ),
                            ]),
                          ]),
                          pdfLib.SizedBox(height: 70),
                          pdfLib.Text("Total a pagar: " + botana.getTotal().toString(),
                            style: pdfLib.TextStyle(
                              fontSize: 150
                            )
                          ),
                          pdfLib.SizedBox(height: 200),
                          pdfLib.Text("Cambios: ",
                            style: pdfLib.TextStyle(
                              fontSize: 150
                            )
                          ),
                          pdfLib.Row(children: <pdfLib.Widget>[
                            //pdfLib.SizedBox(width: 70),
                            pdfLib.Column(children: <pdfLib.Widget>[
                              pdfLib.Text("Nombre producto",
                                style: pdfLib.TextStyle(
                                  fontSize: 150
                                )
                              ),
                              //pdfLib.SizedBox(height: 10),
                              pdfLib.Paragraph(
                                text: reembolsos
                                  .getProduct()
                                  .toString()
                                  .replaceAll(",", "\n")
                                  .replaceAll("[", " ")
                                  .replaceAll("]", ""),
                                style: pdfLib.TextStyle(
                                  fontSize: 150
                                )
                              ),
                            ]),
                            pdfLib.SizedBox(width: 80),
                            pdfLib.Column(children: <pdfLib.Widget>[
                              pdfLib.Text("Cantidad",
                                style: pdfLib.TextStyle(
                                  fontSize: 150
                                )
                              ),
                              pdfLib.SizedBox(height: 20),
                              pdfLib.Paragraph(
                                text: reembolsos
                                  .getQuantity()
                                  .toString()
                                  .replaceAll(",", "\n")
                                  .replaceAll("[", " ")
                                  .replaceAll("]", ""),
                                style: pdfLib.TextStyle(
                                  fontSize: 150
                                )  
                              ),
                            ])
                          ]),
                          pdfLib.SizedBox(height: 20),
                          pdfLib.Text("Firma del cliente",
                            style: pdfLib.TextStyle(
                              fontSize: 150
                            )
                          ),
                          pdfLib.Image(image),
                          pdfLib.Text("Teléfono: 755 55 6 39 57",
                            style: pdfLib.TextStyle(
                              fontSize: 150
                            )
                          ),
                        ])
                   )
              );
            }
          ),
        );

        return doc.save();
      },
    );
  }
}