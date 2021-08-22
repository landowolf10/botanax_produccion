import 'package:botanax_v5_9_produccion/src/pages/funciones.dart';
import 'package:botanax_v5_9_produccion/src/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
 
Future<void> main() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var userName = prefs.getString("nombre_usuario");
  print("Usuario: " + userName);
  runApp(MaterialApp(home: userName == null ? MyApp() : Funciones()));
}
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Botanax',
      home: LoginPage()
    );
  }
}