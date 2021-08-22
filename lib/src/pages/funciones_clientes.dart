import 'dart:io';

import 'package:botanax_v5_9_produccion/src/pages/actualizarCliente.dart';
import 'package:botanax_v5_9_produccion/src/pages/dialogos.dart';
import 'package:botanax_v5_9_produccion/src/pages/funciones.dart';
import 'package:botanax_v5_9_produccion/src/pages/registroCliente.dart';
import 'package:botanax_v5_9_produccion/src/pages/seleccionarCliente.dart';
import 'package:flutter/material.dart';

class FuncionesClientes extends StatefulWidget {
  @override
  _FuncionesClientesState createState() => _FuncionesClientesState();
}

class _FuncionesClientesState extends State<FuncionesClientes> with TickerProviderStateMixin
{
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
    _controller = AnimationController(duration: const Duration(milliseconds: 2000), vsync: this, value: 0.1);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.bounceInOut);

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
          Column(
            children: <Widget>[
              logo,
              SizedBox(height: 20),
              new ButtonTheme(
                minWidth: 200.0,
                height: 100.0,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  color: Colors.red,
                  child: Text('REGISTRAR', style: TextStyle(color: Colors.white)),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegistrarClientes()),
                    );
                  },
                ),
              ),
              SizedBox(height: 30),
              new ButtonTheme(
                minWidth: 200.0,
                height: 100.0,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  color: Colors.red,
                  child: Text('ACTUALIZAR', style: TextStyle(color: Colors.white)),
                  onPressed: () async {
                    try
                    {
                      final result = await InternetAddress.lookup("www.google.com");

                      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty)
                      {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => ActualizarClientes()));
                      }
                    } on SocketException catch (_)
                    {
                      Dialogos dialogo = new Dialogos();
                      dialogo.connectionDialog(context);
                    }
                  },
                ),
              ),
              SizedBox(height: 30),
              new ButtonTheme(
                minWidth: 200.0,
                height: 100.0,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  color: Colors.red,
                  child: Text('DEUDA', style: TextStyle(color: Colors.white)),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ClienteDeuda()));
                  },
                ),
              ),
              SizedBox(height: 30),
              new ButtonTheme(
                minWidth: 200.0,
                height: 100.0,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  color: Colors.red,
                  child: Text('MENÚ PRINCIPAL', style: TextStyle(color: Colors.white)),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Funciones()));
                  },
                ),
              ),
            ],
          )
        ],
      )
    );
  }
}