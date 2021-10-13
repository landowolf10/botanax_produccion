import 'dart:io';
import 'dart:async';
import 'dart:ui' as ui;
import 'package:botanax_v5_9_produccion/src/pages/botanax.dart';
import 'package:botanax_v5_9_produccion/src/pages/dialogos.dart';
import 'package:botanax_v5_9_produccion/src/pages/ticket2.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

const directoryName = 'Signature';

List<Offset> _points = <Offset>[];

File filePath;
var file;
var firmaPath;
File firma;

class SignApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SignAppState();
  }
}

class SignAppState extends State<SignApp> {
  GlobalKey<SignatureState> signatureKey = GlobalKey();
  var image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Signature(key: signatureKey),
      persistentFooterButtons: <Widget>[
        FlatButton(
          child: Text('Limpiar'),
          onPressed: () {
            signatureKey.currentState.clearPoints();
          },
        ),
        FlatButton(
          child: Text('Continuar'),
          onPressed: ()  async {
            
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

                  await setRenderedImage(context);
                  signatureKey.currentState.clearPoints();

                  Navigator.push(context,
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
        )
      ],
    );
  }

  setRenderedImage(BuildContext context) async
  {
    ui.Image renderedImage = await signatureKey.currentState.rendered;

    image = renderedImage;

    var pngBytes = await image.toByteData(format: ui.ImageByteFormat.png);

    // Use plugin [path_provider] to export image to storage
    Directory directory = await getExternalStorageDirectory();
    String path = directory.path;

    // create directory on external storage
    await Directory('$path/$directoryName').create(recursive: true);

    // write to storage as a filename.png
    firma = File('$path/$directoryName/firma.png')
        ..writeAsBytesSync(pngBytes.buffer.asInt8List());

    print('Firma: ' + firma.toString());

    /*var pngBytes = await renderedImage.toByteData(format: ui.ImageByteFormat.png);
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;

    firma = p.join(tempDir.path, "firma.png");

    print(firma);

    filePath = new File(firma);

    File urlFile = await file.writeAsBytes(filePath);

    print(urlFile);*/

    //File('$tempDir/filename.png').writeAsBytesSync(pngBytes.buffer.asInt8List());

    //print(filePath);
  }

  String formattedDate()
  {
    DateTime dateTime = DateTime.now();
    String dateTimeString = 'Signature_' +
      dateTime.year.toString() +
      dateTime.month.toString() +
      dateTime.day.toString() +
      dateTime.hour.toString() +
      ':' + dateTime.minute.toString() +
      ':' + dateTime.second.toString() +
      ':' + dateTime.millisecond.toString() +
      ':' + dateTime.microsecond.toString();

    return dateTimeString;
  }
}

class Signature extends StatefulWidget
{
  Signature({Key key}): super(key: key);

  @override
  State<StatefulWidget> createState()
  {
    return SignatureState();
  }
}

class SignatureState extends State<Signature>
{
  Future<ui.Image> get rendered
  {
    ui.PictureRecorder recorder = ui.PictureRecorder();
    Canvas canvas = Canvas(recorder);
    SignaturePainter painter = SignaturePainter(points: _points);

    var size = context.size;
    painter.paint(canvas, size);

    return recorder.endRecording().toImage(size.width.floor(), size.height.floor());
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      body: Container(
        child: GestureDetector(
          onPanUpdate: (DragUpdateDetails details)
          {
            setState(()
            {
              RenderBox _object = context.findRenderObject();
              Offset _locationPoints = _object.localToGlobal(details.globalPosition);
              _points = new List.from(_points)..add(_locationPoints);
            });
          },
          onPanEnd: (DragEndDetails details)
          {
            setState(()
            {
              _points.add(null);
            });
          },
          child: CustomPaint(
            painter: SignaturePainter(points: _points),
            size: Size.infinite,
          ),
        ),
      ),
    );
  }

  void clearPoints()
  {
    setState(()
    {
      _points.clear();
    });
  }
}

class SignaturePainter extends CustomPainter
{
  List<Offset> points = <Offset>[];

  SignaturePainter({this.points});

  @override
  void paint(Canvas canvas, Size size)
  {
    var paint = Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.square
      ..strokeWidth = 5.0;

    for(int i=0; i < points.length - 1; i++)
    {
      if(points[i] != null && points[i+1] != null)
      {
        canvas.drawLine(points[i], points[i+1], paint);
      }
    }
  }

  @override
  bool shouldRepaint(SignaturePainter oldDelegate)
  {
    return oldDelegate.points != points;
  }
}

class GetFirma
{
  File getSign()
  {
    return firma;
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