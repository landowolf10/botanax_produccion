import 'dart:convert';
import 'dart:io';

import 'package:botanax_v5_9_produccion/src/pages/botanax.dart';
import 'package:botanax_v5_9_produccion/src/pages/dialogos.dart';
import 'package:botanax_v5_9_produccion/src/pages/funciones_clientes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

int idCliente;
double totalPago = 0, deudaTotal;
String deuda;
GetDeuda currentCliente;
String selectedCliente = "";
List<GetDeuda> clientesDeuda;

class ClienteDeuda extends StatefulWidget {
  @override
  ClienteDeudaState createState() => ClienteDeudaState();
}

class ClienteDeudaState extends State<ClienteDeuda>
    with TickerProviderStateMixin {
  TextEditingController pagoController = new TextEditingController();
  Dialogos dialogos = new Dialogos();

  AnimationController _controller;
  Animation<double> _animation;

  initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this, value: 0.1);
    _animation =
        CurvedAnimation(parent: _controller, curve: Curves.bounceInOut);

    _controller.forward();
  }

  @override
  dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white, body: selectClient());
  }

  BotanaxState botanax = new BotanaxState();

  Future<List<GetDeuda>> fetchClients() async {
    try {
      final result = await InternetAddress.lookup("www.google.com");

      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        var response = await http
            .get(Uri.parse("https://somadi.com.mx/botanax/app/cliente_deuda.php"));

        if (response.statusCode == 200) {
          final items = json.decode(response.body).cast<Map<String, dynamic>>();

          clientesDeuda = items.map<GetDeuda>((json) {
            return GetDeuda.fromJson(json);
          }).toList();

          //print(listOfProducts);

        } else {
          throw Exception('Failed to load internet');
        }
      }
    } on SocketException catch (_) {
      Dialogos dialogo = new Dialogos();
      dialogo.connectionDialog(context);
    }

    return clientesDeuda;
  }

  Widget selectClient() {
    GetTotalDeuda obtener = new GetTotalDeuda();

    final logo = Hero(
      tag: 'hero',
      child: Image.asset('img/botanaxLogo.png'),
    );

    return ScaleTransition(
        scale: _animation,
        child: Container(
          alignment: Alignment.center,
          child: ListView(
            children: <Widget>[
              logo,
              SizedBox(height: 50),
              Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      SizedBox(width: 25),
                      FutureBuilder<List<GetDeuda>>(
                          future: fetchClients(),
                          builder: (BuildContext context,
                              AsyncSnapshot<List<GetDeuda>> snapshot) {
                            if (!snapshot.hasData)
                              return CircularProgressIndicator();

                            return DropdownButton<GetDeuda>(
                              items: snapshot.data
                                  .map((cliente) => DropdownMenuItem<GetDeuda>(
                                        child: Text(cliente.nombreCliente),
                                        value: cliente,
                                      ))
                                  .toList(),
                              onChanged: (GetDeuda value) {
                                setState(() {
                                  currentCliente = value;
                                  selectedCliente =
                                      currentCliente.nombreCliente;

                                  print("Cliente: " + selectedCliente);

                                  idCliente = int.parse(currentCliente.cliente);
                                  print("Client: " + idCliente.toString());

                                  getDeuda();
                                });
                              },
                              isExpanded: false,
                              style: TextStyle(color: Colors.red),
                              //value: currentCliente,
                              hint: Text(
                                'Selecciona cliente',
                                style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                              ),
                            );
                          }),
                    ],
                  ),
                  SizedBox(height: 30),
                  Center(
                    child: Text(
                      //_currentClient.nombreCliente,
                      selectedCliente,
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      SizedBox(height: 50),
                      Text(
                        "${totalDeuda()}",
                        style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 25),
                      ),
                      SizedBox(height: 50),
                      new ButtonTheme(
                        minWidth: 200.0,
                        height: 50.0,
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          color: Colors.red,
                          child: Text('PAGAR DEUDA',
                              style: TextStyle(color: Colors.white)),
                          onPressed: () {
                            if (selectedCliente.isEmpty) {
                              dialogos.emptyClientDialog(context);
                            } else {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: new Text(selectedCliente),
                                    content: new TextField(
                                      controller: pagoController,
                                      keyboardType:
                                          TextInputType.numberWithOptions(
                                              decimal: true),
                                      inputFormatters: [
                                        BlacklistingTextInputFormatter(
                                            new RegExp("[\\-|\\ |\\,]")),
                                        WhitelistingTextInputFormatter(new RegExp(
                                            "^\$|^(0|([1-9][0-9]{0,}))(\\.[0-9]{0,})?\$"))
                                      ],
                                      decoration: InputDecoration(
                                          hintText: "Cantidad a pagar"),
                                    ),
                                    actions: <Widget>[
                                      new FlatButton(
                                        child: new Text("Cancelar"),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          pagoController.text = "";
                                        },
                                      ),
                                      new FlatButton(
                                        child: new Text("Pagar"),
                                        onPressed: () {
                                          Navigator.of(context).pop();

                                          setState(() async {
                                            if (pagoController.text != "") {
                                              totalPago = double.parse(
                                                  pagoController.text);
                                              print("Abono: " +
                                                  totalPago.toString());

                                              if (totalPago > 0) {
                                                if (totalPago > deudaTotal) {
                                                  dialogos.abonoAlertDialog(
                                                      context);
                                                } else {
                                                  try {
                                                    final result =
                                                        await InternetAddress
                                                            .lookup(
                                                                "www.google.com");

                                                    if (result.isNotEmpty &&
                                                        result[0]
                                                            .rawAddress
                                                            .isNotEmpty) {
                                                      //deuda = "";
                                                      obtener.insertarAbono();
                                                      //getDeuda();
                                                      //totalDeuda();

                                                      dialogos
                                                          .abonoDialog(context);

                                                      Future.delayed(Duration(
                                                              seconds: 1))
                                                          .then((value) {
                                                        getDeuda();
                                                      });
                                                    }
                                                  } on SocketException catch (_) {
                                                    Dialogos dialogo =
                                                        new Dialogos();
                                                    dialogo.connectionDialog(
                                                        context);
                                                  }
                                                }
                                              } else
                                                dialogos.abonoInvalidoDialog(
                                                    context);
                                            } else
                                              dialogos
                                                  .abonoInvalidoDialog(context);
                                          });

                                          SystemChannels.textInput
                                              .invokeMethod('TextInput.hide');
                                          pagoController.text = "";
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          },
                        ),
                      ),
                      SizedBox(height: 10),
                      new ButtonTheme(
                        minWidth: 200.0,
                        height: 50.0,
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          color: Colors.red,
                          child: Text('MENÚ CLIENTES',
                              style: TextStyle(color: Colors.white)),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FuncionesClientes()),
                            );
                          },
                        ),
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
        ));
  }

  void getDeuda() async {
    try {
      final result = await InternetAddress.lookup("www.google.com");

      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        final response = await http.post(
            Uri.parse("https://somadi.com.mx/botanax/app/getDeuda.php"),
            body: {"id_cliente": idCliente.toString()});

        setState(() {
          var dataDeuda = json.decode(response.body);

          print(dataDeuda);

          deuda = "";
          deuda = dataDeuda[0]["total_deuda"];
          deudaTotal = double.parse(deuda);

          print("Deuda: " + deudaTotal.toString());
        });
      }
    } on SocketException catch (_) {
      Dialogos dialogo = new Dialogos();
      dialogo.connectionDialog(context);
    }
  }

  String totalDeuda() {
    if (deuda == null) deuda = "";

    return deuda;
  }
}

class DeudaTotal {
  final int id_cliente, cantidad;

  DeudaTotal({this.id_cliente, this.cantidad});

  factory DeudaTotal.fromJson(Map<String, dynamic> json) {
    return DeudaTotal(
        id_cliente: json['id_cliente'], cantidad: json['cantidad_abono']);
  }

  Map<String, dynamic> toJson() {
    return {"id_c": idCliente, "cantidad_abonar": totalPago};
  }
}

class GetTotalDeuda {
  void insertarAbono() async {
    var url = "https://somadi.com.mx/botanax/app/abonar.php";
    final headers = {'Contehttpsnt-Type': 'application/json'};

    DeudaTotal dt = new DeudaTotal();

    var clientes = new DeudaTotal.fromJson(dt.toJson());

    String jsonBody = json.encode(clientes);
    print("Datos del abono: " + jsonBody.toString());

    final response = await http.post(Uri.parse(url), headers: headers, body: jsonBody);

    print(response.statusCode);
  }
}

class GetDeuda {
  String nombreCliente, cliente;

  GetDeuda({this.nombreCliente, this.cliente});

  factory GetDeuda.fromJson(Map<String, dynamic> json) {
    return GetDeuda(
        nombreCliente: json['nombre_cliente'], cliente: json['id_cliente']);
  }
}
