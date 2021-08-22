import 'dart:io';

import 'package:botanax_v5_9_produccion/src/pages/dialogos.dart';
import 'package:botanax_v5_9_produccion/src/pages/ticket.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:image_picker_saver/image_picker_saver.dart';

import 'botanax.dart';

var filePath;
var now;
GlobalKey screen = new GlobalKey();

class FirmaPage extends StatefulWidget {
  @override
  _FirmaPageState createState() => new _FirmaPageState();
}

class _FirmaPageState extends State<FirmaPage> {
  List<Offset> _points = <Offset>[];
  ByteData byteData;
  ui.Image image;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: sign(),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            FloatingActionButton(
              heroTag: "btn1",
              child: Icon(
                Icons.clear,
                color: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  _points.clear();
                });
              },
            ),
            SizedBox(height: 10),
            FloatingActionButton(
              heroTag: "btn2",
              child: Icon(
                Icons.save,
                color: Colors.white,
              ),
              onPressed: () async {
                if(_points.isEmpty)
                {
                  Dialogos dialogo = new Dialogos();

                  dialogo.emptySignDialog(context);
                }
                else
                {
                  UpdateProduct update = new UpdateProduct();
                  InsertarReembo insertReembo = new InsertarReembo();

                  try
                  {
                    final result = await InternetAddress.lookup("www.google.com");

                    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty)
                    {
                      update.updateProduct();
                      insertReembo.insertarReembo();

                      _points.clear();

                      screenShot();

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => FirmaPDF()),
                      );
                    }
                  } on SocketException catch (_)
                  {
                    Dialogos dialogo = new Dialogos();
                    dialogo.connectionDialog(context);
                  }
                } 
              },
            ),
          ],
        )
      );
  }

  Widget sign()
  {
    Size size = MediaQuery.of(context).size;

    return RepaintBoundary(
          key: screen,
          child: Container(
            color: Colors.white,
            child: Column(
              children: <Widget>[
                new GestureDetector(
                  onPanUpdate: (DragUpdateDetails details) {
                    setState(() {
                      RenderBox object = context.findRenderObject();
                      Offset _localPosition =
                          object.globalToLocal(details.globalPosition);
                      _points = new List.from(_points)..add(_localPosition);
                    });
                  },
                  onPanEnd: (DragEndDetails details) => _points.add(null),
                  child: new CustomPaint(
                    painter: new Signature(points: _points),
                    size: size,
                  ),
                ),
              ],
            ),
          ),
        );
  }

  void screenShot() async {
    RenderRepaintBoundary boundary = screen.currentContext.findRenderObject();
    image = await boundary.toImage();
    byteData = await image.toByteData(format: ui.ImageByteFormat.png);

    filePath = await ImagePickerSaver.saveFile(
        fileData: byteData.buffer.asUint8List());

    print(filePath);
    print('BYTE: ' + image.toString());
  }
}

class Signature extends CustomPainter {
  List<Offset> points;

  Signature({this.points});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = new Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5.0;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i], points[i + 1], paint);
      }
    }
  }

  @override
  bool shouldRepaint(Signature oldDelegate) => oldDelegate.points != points;
}

class GetFirma
{
  dynamic getSign()
  {
    return filePath;
  }

  String formattedDate() {
    DateTime dateTime = DateTime.now();
    String dateTimeString = dateTime.year.toString() + "/" +
            dateTime.month.toString() + "/" +
            dateTime.day.toString()  + "    " +
            dateTime.hour.toString() +
            ':' + dateTime.minute.toString() +
            ':' + dateTime.second.toString();
    return dateTimeString;
  }
}