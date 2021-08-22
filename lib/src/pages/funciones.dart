import 'package:botanax_v5_9_produccion/src/pages/botanax.dart';
import 'package:botanax_v5_9_produccion/src/pages/funciones_clientes.dart';
import 'package:botanax_v5_9_produccion/src/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Funciones extends StatefulWidget {
  @override
  FuncionesState createState() => FuncionesState();
}

class FuncionesState extends State<Funciones> with TickerProviderStateMixin
{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: createFunctions(),
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

  Widget createFunctions() {
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
                  child: Text('VENTAS', style: TextStyle(color: Colors.white)),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Botanax()));
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
                  child:
                    Text('CLIENTES', style: TextStyle(color: Colors.white)),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FuncionesClientes()));
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
                  child: Text('CERRAR SESIÓN',
                      style: TextStyle(color: Colors.white)),
                  onPressed: () async {
                    WidgetsFlutterBinding.ensureInitialized();
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.remove("nombre_usuario");

                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginPage()));
                    //login.logOut();
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
