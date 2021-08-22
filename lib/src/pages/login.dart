import 'dart:async';
import 'dart:convert';
import 'package:botanax_v5_9_produccion/src/pages/funciones.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'dialogos.dart';
import 'package:permission_handler/permission_handler.dart';

int idUsuario, state = 0;
String tipoUsuario, nombreUsuario;

class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() => new LoginPageState();
}

class LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  SharedPreferences sharedPreferences;
  bool _obscuredText = true;

  double _width = double.maxFinite;

  AnimationController _controller;
  Animation<double> _animation;

  @override
  initState() {
    super.initState();
    initPlatformState();

    _controller = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this, value: 0.1);
    _animation =
        CurvedAnimation(parent: _controller, curve: Curves.bounceInOut);

    _controller.forward();
  }

  initPlatformState() async {
    var status = await Permission.storage.status;

    print("PERMISO: " + status.toString());

    if (status.isUndetermined) {
      await Permission.storage.request();
    }
  }

  @override
  void dispose() {
    super.dispose();
    state = 0;
    _controller.dispose();
    //_controller.dispose();
  }

  TextEditingController user = new TextEditingController();
  TextEditingController pass = new TextEditingController();

  bool datosCorrectos = false;
  String msg = '', validateUser;

  Future _login() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      final result = await InternetAddress.lookup("www.google.com");

      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        final response = await http
            .post(Uri.parse("https://somadi.com.mx/botanax/app/login.php"), body: {
          "nombre_usuario": user.text,
          "pass": pass.text,
        });

        print("Response: " + response.statusCode.toString());

        if (response.statusCode == 200) {
          var datauser = json.decode(response.body);

          if (!datauser.isEmpty) {
            if (datauser[0]["nombre_usuario"] == user.text &&
                datauser[0]["pass"] == pass.text &&
                datauser[0]["tipo_usuario"] == "Vendedor") {
              idUsuario = int.parse(datauser[0]["id_u"]);
              tipoUsuario = datauser[0]["tipo_usuario"];

              nombreUsuario = datauser[0]["nombre"] +
                  " " +
                  datauser[0]["apellido_paterno"] +
                  " " +
                  datauser[0]["apellido_materno"];

              prefs.setString("nombre_usuario", user.text);

              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext ctx) => Funciones()));
            } else {
              Dialogos dialog = new Dialogos();
              dialog.noPermissionDialog(context);
            }
          } else {
            Dialogos dialog = new Dialogos();
            dialog.invalidDataDialog(context);
          }
        } else {
          Dialogos dialogo = new Dialogos();
          dialogo.errorDialog(context);
        }
      }
    } on SocketException catch (_) {
      Dialogos dialogo = new Dialogos();
      dialogo.connectionDialog(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final logo = Hero(
      tag: 'hero',
      child: Image.asset('img/botanaxLogo.png'),
    );

    final email = TextFormField(
      style: TextStyle(
        color: Colors.red,
      ),
      controller: user,
      onSaved: (String value) {
        validateUser = value;
      },
      keyboardType: TextInputType.emailAddress,
      autofocus: true,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.redAccent, width: 2.0),
          borderRadius: BorderRadius.circular(32.0),
        ),
        hintText: 'Usuario',
        hintStyle: TextStyle(
          color: Colors.red,
        ),
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32.0),
          borderSide: BorderSide(color: Colors.orange, width: 2.0),
        ),
      ),
    );

    final password = TextFormField(
      style: TextStyle(
        color: Colors.red,
      ),
      controller: pass,
      autofocus: false,
      obscureText: _obscuredText,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.redAccent, width: 2.0),
          borderRadius: BorderRadius.circular(32.0),
        ),
        suffixIcon: IconButton(
          color: Colors.red,
          onPressed: () {
            setState(() {
              if (_obscuredText)
                _obscuredText = false;
              else
                _obscuredText = true;
            });
          },
          icon: Icon(Icons.lock),
        ),
        hintText: 'Contraseña',
        hintStyle: TextStyle(
          color: Colors.red,
        ),
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32.0),
          borderSide: BorderSide(color: Colors.orange, width: 2.0),
        ),
      ),
    );

    final loginButton = Container(
      height: 48,
      width: _width,
      child: RaisedButton(
        animationDuration: Duration(milliseconds: 1000),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        padding: EdgeInsets.all(0),
        child: setUpButtonChild(),
        onPressed: () {
          setState(() {
            if (user.text.isEmpty || pass.text.isEmpty) {
              Dialogos dialogo = new Dialogos();

              dialogo.emptyBoxesDialog(context);
            } else {
              if (state == 0) {
                animateButton();
              }
            }
          });
        },
        elevation: 4,
        color: Colors.red,
      ),
    );

    return WillPopScope(
      child: Scaffold(
          backgroundColor: Colors.white,
          body: ScaleTransition(
            scale: _animation,
            child: Center(
              child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.only(left: 24.0, right: 24.0),
                children: <Widget>[
                  logo,
                  SizedBox(height: 80.0),
                  email,
                  SizedBox(height: 8.0),
                  password,
                  SizedBox(height: 24.0),
                  loginButton
                ],
              ),
            ),
          )),
      onWillPop: () {
        return Future.value(false);
      },
    );
  }

  setUpButtonChild() {
    if (state == 0) {
      return Text(
        "Iniciar sesión",
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      );
    } else if (state == 1) {
      return SizedBox(
        height: 36,
        width: 36,
        child: CircularProgressIndicator(
          value: null,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    }
  }

  void animateButton() {
    setState(() {
      state = 1;
    });

    _login();

    Timer(Duration(milliseconds: 54000), () {
      if (mounted) {
        setState(() {
          state = 0;
        });
      }
    });
  }

  /*_onChanged() async
  {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      sharedPreferences.setString("username", user.text);
      sharedPreferences.setString("password", pass.text);
      sharedPreferences.commit();
      getCredential();
    });
  }

  getCredential() async
  {
    sharedPreferences = await SharedPreferences.getInstance();

    user.text = sharedPreferences.getString("username");
    pass.text = sharedPreferences.getString("password");

    if(user.text.isEmpty)
      logOut();
    else
      _login();
  }

  logOut() async
  {
    sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.remove("username");
    sharedPreferences.remove("password");

    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
  }*/
}

class GetIDUsuario {
  int getID() {
    return idUsuario;
  }

  String getNombreUsuario() {
    return nombreUsuario;
  }
}

class GetTipoUsuario {
  String getTipoUsuario() {
    return tipoUsuario;
  }
}
