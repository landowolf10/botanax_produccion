import 'dart:ffi';
import 'dart:io' as Io;
import 'dart:typed_data';

import 'package:botanax_v5_9_produccion/src/pages/botanax.dart';
import 'package:botanax_v5_9_produccion/src/pages/firma2.dart';
import 'package:botanax_v5_9_produccion/src/pages/funciones.dart';
import 'package:botanax_v5_9_produccion/src/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart';
import 'dart:async';
import 'dart:convert';
import 'package:bluetooth_print/bluetooth_print.dart';
import 'package:bluetooth_print/bluetooth_print_model.dart';

class FirmaPDF extends StatefulWidget {
  @override
  FirmaPDFPageState createState() => new FirmaPDFPageState();
}

class FirmaPDFPageState extends State<FirmaPDF> 
{
  BluetoothPrint bluetoothPrint = BluetoothPrint.instance;

  bool _connected = false;
  BluetoothDevice _device;
  String tips = 'No existe dispositivo conectado';

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) => initBluetooth());
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initBluetooth() async {
    bluetoothPrint.startScan(timeout: Duration(seconds: 4));

    bool isConnected=await bluetoothPrint.isConnected;

    bluetoothPrint.state.listen((state) {
      print('Current device status: $state');

      switch (state) {
        case BluetoothPrint.CONNECTED:
          setState(() {
            _connected = true;
            tips = 'Conectado correctamente';
          });
          break;
        case BluetoothPrint.DISCONNECTED:
          setState(() {
            _connected = false;
            tips = 'Desconectado correctamente';
          });
          break;
        default:
          break;
      }
    });

    if (!mounted) return;

    if(isConnected) {
      setState(() {
        _connected=true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    GetBotana botana = new GetBotana();
    GetIDUsuario user = new GetIDUsuario();
    Reembolsos reembolsos = new Reembolsos();
    GetFirma firma = new GetFirma();

    final logo = Hero(
      tag: "hero",
      child: Image.asset("img/botanaxLogo.png"),
    );

    return new Scaffold(
        backgroundColor: Colors.white,
        body: RefreshIndicator(
            onRefresh: () => bluetoothPrint.startScan(timeout: Duration(seconds: 4)),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  logo,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        child: Text(tips),
                      ),
                    ],
                  ),
                  Divider(),
                  StreamBuilder<List<BluetoothDevice>>(
                    stream: bluetoothPrint.scanResults,
                    initialData: [],
                    builder: (c, snapshot) => Column(
                      children: snapshot.data.map((d) => ListTile(
                        title: Text(d.name??''),
                        subtitle: Text(d.address),
                        onTap: () async {
                          setState(() {
                            _device = d;
                          });
                        },
                        trailing: _device!=null && _device.address == d.address?Icon(
                          Icons.check,
                          color: Colors.green,
                        ):null,
                      )).toList(),
                    ),
                  ),
                  Divider(),
                  Container(
                    padding: EdgeInsets.fromLTRB(20, 5, 20, 10),
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            OutlinedButton(
                              child: Text('Conectar'),
                              onPressed:  _connected?null:() async {
                                if(_device!=null && _device.address !=null){
                                  await bluetoothPrint.connect(_device);
                                }else{
                                  setState(() {
                                    tips = 'Por favor seleccione un dispositivo';
                                  });
                                  print('Por favor seleccione un dispositivo');
                                }
                              },
                            ),
                            SizedBox(width: 10.0),
                            OutlinedButton(
                              child: Text('Desconectar'),
                              onPressed:  _connected?() async {
                                await bluetoothPrint.disconnect();
                              }:null,
                            ),
                          ],
                        ),
                        OutlinedButton(
                          child: Text('Imprimir ticket'),
                          onPressed:  _connected?() async {
                            Map<String, dynamic> config = Map();
                            List<LineText> list = [];

                            ByteData data = await rootBundle.load("img/botanaxLogo.png");
                            List<int> imageBytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
                            String base64Image = base64Encode(imageBytes);
                            list.add(LineText(type: LineText.TYPE_IMAGE, content: base64Image, align: LineText.ALIGN_LEFT, linefeed: 1));

                            //Image signData = decodeImage(firma.getSign());

                            //ByteData signData = Image.file(File('/storage/emulated/0/Android/data/com.example.botanax_v5_9_produccion/files/Signature/firma.png')) as ByteData;
                            print('DATA: ' + firma.getSign().toString());
                            final signBytes = Io.File('/storage/emulated/0/Android/data/com.example.botanax_v5_9_produccion/files/Signature/firma.png').readAsBytesSync();
                            String base64Sign = base64Encode(signBytes);

                            /*var signData = Image.file(File('/storage/emulated/0/Android/data/com.example.botanax_v5_9_produccion/files/Signature/firma.png')) as ByteData;
                            List<int> signBytes = signData.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
                            String base64Sign = base64Encode(signBytes);*/

                            list.add(LineText(type: LineText.TYPE_TEXT, content: 'Botanax del Puerto', weight: 1, align: LineText.ALIGN_CENTER, linefeed: 1));
                            list.add(LineText(type: LineText.TYPE_TEXT, content: 'RFC: 454613545342154', weight: 0, align: LineText.ALIGN_CENTER, linefeed: 1));
                            list.add(LineText(type: LineText.TYPE_TEXT, content: 'Ciudad: Lázaro Cárdenas', align: LineText.ALIGN_CENTER, linefeed: 1));
                            list.add(LineText(type: LineText.TYPE_TEXT, content: 'Col. Comunal Morelos', align: LineText.ALIGN_CENTER, linefeed: 1));
                            list.add(LineText(type: LineText.TYPE_TEXT, content: firma.formattedDate(), align: LineText.ALIGN_CENTER, linefeed: 1));
                            list.add(LineText(type: LineText.TYPE_TEXT, content: 'Vendedor: ' + user.getNombreUsuario(), align: LineText.ALIGN_CENTER, linefeed: 1));
                            list.add(LineText(type: LineText.TYPE_TEXT, content: 'Cliente: ' + botana.getClient(), align: LineText.ALIGN_CENTER, linefeed: 1));
                            list.add(LineText(linefeed: 1));
                            list.add(LineText(type: LineText.TYPE_TEXT, content: 'Prod:     Cant:    P/U:     P/T:', align: LineText.ALIGN_CENTER, linefeed: 1));
                            for(int i = 0; i < botana.getProducts().length; i++)
                              list.add(
                                LineText(
                                  type: LineText.TYPE_TEXT,
                                  content: botana.getProducts()[i] + '   ' +
                                           botana.getQuantity()[i].toString() + '     ' +
                                           botana.getPrices()[i].toString() + '      ' +
                                           botana.getTotalPrices()[i].toString(),
                                  align: LineText.ALIGN_CENTER, linefeed: 1
                                )
                              );
                            list.add(LineText(linefeed: 1));
                            list.add(LineText(type: LineText.TYPE_TEXT, content: 'Total a pagar', align: LineText.ALIGN_CENTER, linefeed: 1));
                            list.add(LineText(type: LineText.TYPE_TEXT, content: '\$' + botana.getTotal().toString(), align: LineText.ALIGN_CENTER, linefeed: 1));
                            list.add(LineText(linefeed: 1));

                            if(reembolsos.getQuantity().length > 0)
                            {
                              list.add(LineText(type: LineText.TYPE_TEXT, content: 'Cambios:', align: LineText.ALIGN_CENTER, linefeed: 1));
                              list.add(LineText(type: LineText.TYPE_TEXT, content: 'Nombre producto:       Cantidad:', align: LineText.ALIGN_CENTER, linefeed: 1));
                              
                              print("Productos reembo: " + reembolsos.getProduct().toString());
                              
                              for(int i = 0; i < reembolsos.getQuantity().length; i++)
                              {
                                List cleanReemboNames = reembolsos.getProduct();
                                cleanReemboNames.remove("");

                                list.add(
                                  LineText(
                                    type: LineText.TYPE_TEXT,
                                    content: cleanReemboNames[i] + '              ' +
                                             reembolsos.getQuantity()[i].toString(),
                                    align: LineText.ALIGN_LEFT,
                                    linefeed: 1
                                  )
                                );
                              }
                            }
                            list.add(LineText(linefeed: 1));
                            list.add(LineText(type: LineText.TYPE_TEXT, content: 'Firma del cliente:', align: LineText.ALIGN_CENTER, linefeed: 1));
                            list.add(LineText(type: LineText.TYPE_IMAGE, content: base64Sign, align: LineText.ALIGN_CENTER, linefeed: 1));
                            list.add(LineText(linefeed: 1));
                            list.add(LineText(type: LineText.TYPE_TEXT, content: 'Teléfono: 755 55 6 39 57', align: LineText.ALIGN_CENTER, linefeed: 1));
                            list.add(LineText(linefeed: 1));

                            await bluetoothPrint.printReceipt(config, list);
                          }:null,
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          floatingActionButton: StreamBuilder<bool>(
          stream: bluetoothPrint.isScanning,
          initialData: false,
          builder: (c, snapshot) {
            if (snapshot.data) {
              return FloatingActionButton(
                child: Icon(Icons.stop),
                onPressed: () => bluetoothPrint.stopScan(),
                backgroundColor: Colors.red,
              );
            } else {
              return FloatingActionButton(
                  child: Icon(Icons.search),
                  onPressed: () => bluetoothPrint.startScan(timeout: Duration(seconds: 4)));
            }
          },
        ),
    );
  }
}