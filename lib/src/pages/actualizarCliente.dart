import 'dart:io';

import 'package:botanax_v5_9_produccion/src/pages/botanax.dart';
import 'package:botanax_v5_9_produccion/src/pages/dialogos.dart';
import 'package:botanax_v5_9_produccion/src/pages/funciones_clientes.dart';
import 'package:botanax_v5_9_produccion/src/pages/updateClient.dart';
import 'package:flutter/material.dart';

int idCliente;
String telefono, nombre, ap, am, estado, ciudad, colonia, calle, numero, tipoC;

class ActualizarClientes extends StatefulWidget {
  @override
  _ActualizarClientesState createState() => _ActualizarClientesState();
}

class _ActualizarClientesState extends State<ActualizarClientes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white, body: _updateClients());
  }

  BotanaxState botanax = new BotanaxState();

  TextEditingController searchController = new TextEditingController();

  List<Clients> clientes = List();
  List<Clients> filteredClients = List();

  @override
  void initState() {
    super.initState();

    botanax.fetchClients().then((clientsFromServer) {
      setState(() {
        clientes = clientsFromServer;
        filteredClients = clientes;
      });
    });
  }

  Widget _updateClients() {
    final logo = Hero(
      tag: 'hero',
      child: Image.asset('img/botanaxLogo.png'),
    );

    return Column(
      children: <Widget>[
        logo,
        new ButtonTheme(
          minWidth: 5.0,
          height: 40.0,
          child: RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            color: Colors.red,
            child: Text('MENÚ CLIENTES', style: TextStyle(color: Colors.white)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FuncionesClientes()),
              );
            },
          ),
        ),
        TextFormField(
          controller: searchController,
          style: TextStyle(
            color: Colors.red,
          ),
          decoration: const InputDecoration(
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.redAccent, width: 2.0),
                borderRadius: const BorderRadius.all(
                  const Radius.circular(32.0),
                )),
            prefixIcon: Icon(
              Icons.search,
              color: Colors.red,
            ),
            hintText: 'Buscar',
          ),
          onChanged: (value) {
            setState(() {
              filteredClients = clientes
                  .where((u) => ((u.nombreCliente +
                          " " +
                          u.apellidoPaterno +
                          " " +
                          u.apellidoMaterno)
                      .toLowerCase()
                      .contains(value.toLowerCase())))
                  .toList();
            });
          },
        ),
        SizedBox(height: 2),
        Flexible(
          child: FutureBuilder<List<Clients>>(
              future: botanax.fetchClients(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<Clients>> snapshot) {
                if (!snapshot.hasData) return CircularProgressIndicator();

                return new ListView(
                  children: <Widget>[
                    SizedBox(
                      height: 400,
                      child: ListView.builder(
                        itemCount: filteredClients.length,
                        itemBuilder: (BuildContext ctxt, int index) {
                          return ListTile(
                            onTap: () async {
                              try {
                                final result = await InternetAddress.lookup(
                                    "www.google.com");

                                if (result.isNotEmpty &&
                                    result[0].rawAddress.isNotEmpty) {
                                  idCliente = int.parse(
                                      filteredClients[index].idCliente);
                                  tipoC = filteredClients[index].tipoCliente;

                                  nombre = filteredClients[index].nombreCliente;
                                  ap = filteredClients[index].apellidoPaterno;
                                  am = filteredClients[index].apellidoMaterno;
                                  telefono = filteredClients[index].telefono;
                                  estado = filteredClients[index].estado;
                                  ciudad = filteredClients[index].ciudad;
                                  colonia = filteredClients[index].colonia;
                                  calle = filteredClients[index].calle;
                                  numero = filteredClients[index].numero;

                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              UpdateClient()));
                                }
                              } on SocketException catch (_) {
                                Dialogos dialogo = new Dialogos();
                                dialogo.connectionDialog(context);
                              }
                            },
                            title: Text(
                              filteredClients[index].nombreCliente +
                                  " " +
                                  filteredClients[index].apellidoPaterno +
                                  " " +
                                  filteredClients[index].apellidoMaterno,
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              }),
        ),
      ],
    );
  }
}

class GetClientData {
  int getID() {
    return idCliente;
  }

  String getName() {
    return nombre;
  }

  String getFirstLastName() {
    return ap;
  }

  String getSecondLastName() {
    return am;
  }

  String getPhone() {
    return telefono;
  }

  String getState() {
    return estado;
  }

  String getCity() {
    return ciudad;
  }

  String getColony() {
    return colonia;
  }

  String getStreet() {
    return calle;
  }

  String getNumber() {
    return numero;
  }

  String getType() {
    return tipoC;
  }
}
