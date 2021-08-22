import 'dart:io';

import 'package:botanax_v5_9_produccion/src/pages/botanax.dart';
import 'package:botanax_v5_9_produccion/src/pages/dialogos.dart';
import 'package:botanax_v5_9_produccion/src/pages/funciones.dart';
import 'package:botanax_v5_9_produccion/src/pages/funciones_clientes.dart';
import 'package:botanax_v5_9_produccion/src/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class RegistrarClientes extends StatefulWidget {
  @override
  RegistrarClientesState createState() => RegistrarClientesState();
}

class RegistrarClientesState extends State<RegistrarClientes>
    with TickerProviderStateMixin {
  TextEditingController nombreController = new TextEditingController();
  TextEditingController apController = new TextEditingController();
  TextEditingController amController = new TextEditingController();
  TextEditingController telefonoController = new TextEditingController();
  TextEditingController estadoController = new TextEditingController();
  TextEditingController ciudadController = new TextEditingController();
  TextEditingController coloniaController = new TextEditingController();
  TextEditingController calleController = new TextEditingController();
  TextEditingController numeroController = new TextEditingController();

  GetIDUsuario idUsuario = new GetIDUsuario();

  bool respuesta = false;
  int credito = 0;
  String tipoCliente;

  void addClient() async {
    var url = "https://somadi.com.mx/botanax/app/addClient.php";

    final response = await http.post(Uri.parse(url), body: {
      "id_u": idUsuario.getID().toString(),
      "nombre": nombreController.text,
      "apellido_paterno": apController.text,
      "apellido_materno": amController.text,
      "telefono": telefonoController.text,
      "estado": estadoController.text,
      "ciudad": ciudadController.text,
      "colonia": coloniaController.text,
      "calle": calleController.text,
      "numero": numeroController.text,
      "credito": credito.toString(),
      "tipo_cliente": tipoCliente
    });

    if (response.statusCode == 200) respuesta = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _createFunctions(),
    );
  }

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

  Widget _createFunctions() {
    final logo = Hero(
      tag: 'hero',
      child: Image.asset('img/botanaxLogo.png'),
    );

    return ScaleTransition(
        scale: _animation,
        child: ListView(
          children: <Widget>[
            //Column(
            //children: <Widget>[
            logo,
            SizedBox(height: 10),
            new TextFormField(
              controller: nombreController,
              style: TextStyle(
                color: Colors.red,
              ),
              decoration: const InputDecoration(
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.redAccent, width: 2.0),
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(32.0),
                    )),
                icon: const Icon(
                  Icons.person,
                  color: Colors.red,
                ),
                hintText: 'Nombre',
                /*enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(32.0),
                    borderSide: BorderSide(color: Colors.orange, width: 2.0),
                  ),*/
              ),
            ),
            new TextFormField(
              controller: apController,
              style: TextStyle(
                color: Colors.red,
              ),
              decoration: const InputDecoration(
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.redAccent, width: 2.0),
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(32.0),
                    )),
                icon: const Icon(
                  Icons.person,
                  color: Colors.red,
                ),
                hintText: 'Apellido paterno',
              ),
            ),
            new TextFormField(
              controller: amController,
              style: TextStyle(
                color: Colors.red,
              ),
              decoration: const InputDecoration(
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.redAccent, width: 2.0),
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(32.0),
                    )),
                icon: const Icon(
                  Icons.person,
                  color: Colors.red,
                ),
                hintText: 'Apellido materno',
              ),
            ),
            new TextFormField(
              controller: telefonoController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                BlacklistingTextInputFormatter(new RegExp("[\\-|\\ |\\,|\\.]"))
              ],
              style: TextStyle(
                color: Colors.red,
              ),
              decoration: const InputDecoration(
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.redAccent, width: 2.0),
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(32.0),
                    )),
                icon: const Icon(
                  Icons.phone,
                  color: Colors.red,
                ),
                hintText: 'Teléfono',
              ),
            ),
            new TextFormField(
              controller: estadoController,
              style: TextStyle(
                color: Colors.red,
              ),
              decoration: const InputDecoration(
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.redAccent, width: 2.0),
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(32.0),
                    )),
                icon: const Icon(
                  Icons.location_city,
                  color: Colors.red,
                ),
                hintText: 'Estado',
              ),
            ),
            new TextFormField(
              controller: ciudadController,
              style: TextStyle(
                color: Colors.red,
              ),
              decoration: const InputDecoration(
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.redAccent, width: 2.0),
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(32.0),
                    )),
                icon: const Icon(
                  Icons.location_city,
                  color: Colors.red,
                ),
                hintText: 'Ciudad',
              ),
            ),
            new TextFormField(
              controller: coloniaController,
              style: TextStyle(
                color: Colors.red,
              ),
              decoration: const InputDecoration(
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.redAccent, width: 2.0),
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(32.0),
                    )),
                icon: const Icon(
                  Icons.location_city,
                  color: Colors.red,
                ),
                hintText: 'Colonia',
              ),
            ),
            new TextFormField(
              controller: calleController,
              style: TextStyle(
                color: Colors.red,
              ),
              decoration: const InputDecoration(
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.redAccent, width: 2.0),
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(32.0),
                    )),
                icon: const Icon(
                  Icons.location_city,
                  color: Colors.red,
                ),
                hintText: 'Calle',
              ),
            ),
            new TextFormField(
              controller: numeroController,
              style: TextStyle(
                color: Colors.red,
              ),
              decoration: const InputDecoration(
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.redAccent, width: 2.0),
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(32.0),
                    )),
                icon: const Icon(
                  Icons.confirmation_number,
                  color: Colors.red,
                ),
                hintText: 'Número',
              ),
            ),
            DropdownButton<String>(
              items: [
                DropdownMenuItem<String>(
                  child: Text('A'),
                  value: 'A',
                ),
                DropdownMenuItem<String>(
                  child: Text('B'),
                  value: 'B',
                )
              ],
              onChanged: (String value) {
                setState(() {
                  tipoCliente = value;
                });
              },
              hint: Text(
                'Tipo de cliente',
                style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
              value: tipoCliente,
              isExpanded: false,
              style: TextStyle(color: Colors.red),
            ),
            SizedBox(height: 30),
            new ButtonTheme(
              minWidth: 5.0,
              height: 60.0,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                color: Colors.red,
                child: Text('REGISTRAR', style: TextStyle(color: Colors.white)),
                onPressed: () async {
                  print("Prueba " + idUsuario.getID().toString());
                  print(respuesta);

                  Dialogos dialogo = new Dialogos();

                  if (nombreController.text == "" ||
                      apController.text == "" ||
                      amController.text == "" ||
                      telefonoController.text == "" ||
                      estadoController.text == "" ||
                      ciudadController.text == "" ||
                      coloniaController.text == "" ||
                      calleController.text == "" ||
                      numeroController.text == "" ||
                      tipoCliente == null)
                    dialogo.emptyDialog(context);
                  else if (telefonoController.text.length > 10 ||
                      telefonoController.text.length < 10) {
                    dialogo.invalidPhoneDialog(context);
                  } else {
                    try {
                      final result =
                          await InternetAddress.lookup("www.google.com");

                      if (result.isNotEmpty &&
                          result[0].rawAddress.isNotEmpty) {
                        addClient();
                        dialogo.insertedClientDialog(context);
                      }
                    } on SocketException catch (_) {
                      dialogo.connectionDialog(context);
                    }
                  }
                  /*Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Botanax()));*/
                },
              ),
            ),
            SizedBox(height: 10),
            new ButtonTheme(
              minWidth: 5.0,
              height: 60.0,
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
            SizedBox(height: 10),
            new ButtonTheme(
              minWidth: 5.0,
              height: 60.0,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                color: Colors.red,
                child: Text('VENTAS', style: TextStyle(color: Colors.white)),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Botanax()),
                  );
                },
              ),
            ),
            //],
            //)
          ],
        ));
  }
}
