import 'dart:io';

import 'package:botanax_v5_9_produccion/src/pages/actualizarCliente.dart';
import 'package:botanax_v5_9_produccion/src/pages/dialogos.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class UpdateClient extends StatefulWidget {
  @override
  _UpdateClientState createState() => _UpdateClientState();
}

class _UpdateClientState extends State<UpdateClient>
    with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;

  @override
  initState() {
    super.initState();

    nombreController.text = data.getName();
    apController.text = data.getFirstLastName();
    amController.text = data.getSecondLastName();
    telefonoController.text = data.getPhone();
    estadoController.text = data.getState();
    ciudadController.text = data.getCity();
    coloniaController.text = data.getColony();
    calleController.text = data.getStreet();
    numeroController.text = data.getNumber();

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

  TextEditingController nombreController = new TextEditingController();
  TextEditingController apController = new TextEditingController();
  TextEditingController amController = new TextEditingController();
  TextEditingController telefonoController = new TextEditingController();
  TextEditingController estadoController = new TextEditingController();
  TextEditingController ciudadController = new TextEditingController();
  TextEditingController coloniaController = new TextEditingController();
  TextEditingController calleController = new TextEditingController();
  TextEditingController numeroController = new TextEditingController();

  GetClientData data = new GetClientData();

  int credito = 0, respuesta;

  void updateClient() async {
    var url = "https://somadi.com.mx/botanax/app/updateClient.php";

    final response = await http.post(Uri.parse(url), body: {
      "id_c": data.getID().toString(),
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
      "tipo_cliente": data.getType()
    });

    print(response.statusCode);

    if (response.statusCode == 200) respuesta = 200;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _createFunctions(),
    );
  }

  Widget _createFunctions() {
    final logo = Hero(
      tag: 'hero',
      child: Image.asset('img/botanaxLogo.pngg'),
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
                Icons.people,
                color: Colors.red,
              ),
              hintText: 'Nombre',
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
                Icons.people,
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
                Icons.people,
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
          SizedBox(height: 30),
          new ButtonTheme(
            minWidth: 5.0,
            height: 60.0,
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              color: Colors.red,
              child: Text('ACTUALIZAR', style: TextStyle(color: Colors.white)),
              onPressed: () async {
                //print("Prueba " + idUsuario.getID().toString());
                print("Respuesta: " + respuesta.toString());

                Dialogos dialogo = new Dialogos();

                print("Prueba: " + data.getID().toString());

                if (telefonoController.text.length > 10 ||
                    telefonoController.text.length < 10) {
                  dialogo.invalidPhoneDialog(context);
                } else {
                  try {
                    final result =
                        await InternetAddress.lookup("www.google.com");

                    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                      updateClient();
                      dialogo.userUpdatedDialog(context);
                    }
                  } on SocketException catch (_) {
                    dialogo.connectionDialog(context);
                  }
                  //}
                  /*else
                    {
                      dialogo.errorDialog(context);
                    }*/

                  //Dialogos dialogo = new Dialogos();
                  //dialogo.insertedClientDialog(context);
                  /*Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Botanax()));*/
                }
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
              child: Text('REGRESAR', style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ActualizarClientes()),
                );
              },
            ),
          ),
          //],
          //)
        ],
      ),
    );
  }
}
