import 'dart:convert';
import 'dart:io';
import 'package:botanax_v5_9_produccion/src/pages/dialogos.dart';
import 'package:botanax_v5_9_produccion/src/pages/firma2.dart';
import 'package:botanax_v5_9_produccion/src/pages/funciones.dart';
import 'package:botanax_v5_9_produccion/src/pages/login.dart';
import 'package:botanax_v5_9_produccion/src/pages/registroCliente.dart';
import 'package:flutter/services.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

List<String> listaProductos = new List<String>();
List<String> listaProductosTicket = new List<String>();
List<String> listaPrecios = new List<String>();
List<int> listaCantidad = new List<int>();
List<int> listaID = new List<int>();
List<int> listaIDV = new List<int>();
List<int> listaIDC = new List<int>();
List<int> listaTipoPago = new List<int>();
List<int> listaTPV = new List<int>();
List<double> listaTotal = new List<double>();
List<String> listaTipoCliente = new List<String>();
List<String> productsReemboList = new List<String>();
List<int> productsReemboIDList = new List<int>();
List<int> sellerIDList = new List<int>();
List<int> reemboQuantityList = new List<int>();
List<int> reemboQuantityListSend = new List<int>();
List<int> reemboQuantityListShow = new List<int>();
List<String> tipoCambio = new List<String>();
List<String> tipoCambioSend = new List<String>();
List<String> tipoCambioShow = new List<String>();
List<Clients> listOfClients;
List<Products> listOfProducts;
Clients currentClient;

String selectedClient = "", valorCredito, tipoC, reembo, cambio;
int cantidad, credito, clientID, clientsID, idLength, reemboIndex;
double totalFinal = 0, totalFinal2 = 0;
bool presionado = false;
List<bool> isReemboQuantityZero = new List<bool>();
List<bool> isSaleQuantityZero = new List<bool>();

class Botanax extends StatefulWidget {
  @override
  BotanaxState createState() => BotanaxState();
}

class BotanaxState extends State<Botanax> with TickerProviderStateMixin {
  Products _currentProduct;
  GetIDUsuario idUsuario = new GetIDUsuario();

  bool isVisible = false, isReemboVisible = false, cargando = false;

  final String uri = 'https://somadi.com.mx/botanax/app/getproducts.php';

  Future<List<Products>> fetchProducts() async {
    try {
      final result = await InternetAddress.lookup("www.google.com");

      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        final response =
            await http.post(Uri.parse(uri), body: {"id_c": idUsuario.getID().toString()});

        if (response.statusCode == 200) {
          List<dynamic> items = json
              .decode(utf8.decode(response.bodyBytes))
              .cast<Map<String, dynamic>>();

          listOfProducts = items.map<Products>((json) {
            return Products.fromJson(json);
          }).toList();

          //print(listOfProducts);
        } else {
          Dialogos dialogo = new Dialogos();
          dialogo.errorDialog(context);
        }
      }
    } on SocketException catch (_) {
      Dialogos dialogo = new Dialogos();
      dialogo.connectionDialog(context);
    }

    return listOfProducts;
  }

  Future<List<Clients>> fetchClients() async {
    var response =
        await http.get(Uri.parse("https://somadi.com.mx/botanax/app/getClients.php"));

    if (response.statusCode == 200) {
      List<dynamic> items = json
          .decode(utf8.decode(response.bodyBytes))
          .cast<Map<String, dynamic>>();

      listOfClients = items.map<Clients>((json) {
        return Clients.fromJson(json);
      }).toList();

      //print(listOfProducts);
    } else {
      Dialogos dialogo = new Dialogos();
      dialogo.errorDialog(context);
    }

    return listOfClients;
  }

  GetTipoUsuario tipo = new GetTipoUsuario();

  int productIndex;
  int cantidad = 0, cantidadReembo = 0;
  double total = 0;
  List<double> removeProduct = new List<double>();

  TextEditingController cantidadController = new TextEditingController();
  TextEditingController cantidadReemboController = new TextEditingController();
  TextEditingController searchController = new TextEditingController();

  String currentProductName;
  int currentProductID, currentSellerID, currentQuantity, reemboQuantity;

  AnimationController _controller;
  Animation<double> _animation;

  initState() {
    //getClientsString();

    listaProductos.clear();
    listaProductosTicket.clear();
    listaID.clear();
    listaIDV.clear();
    listaCantidad.clear();
    listaTipoPago.clear();
    listaIDC.clear();
    listaTPV.clear();
    listaTipoCliente.clear();
    reemboQuantityListSend.clear();
    reemboQuantityListShow.clear();
    tipoCambio.clear();
    tipoCambioSend.clear();
    tipoCambioShow.clear();
    sellerIDList.clear();
    productsReemboIDList.clear();
    listaPrecios.clear();
    listaTotal.clear();
    totalFinal = 0;
    totalFinal2 = 0;
    selectedClient = "";
    isReemboQuantityZero.clear();
    isSaleQuantityZero.clear();
    productsReemboList.clear();
    reembo = null;

    if (listaProductos.isEmpty)
      cargando = true;
    else
      cargando = false;

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
    final logo = Hero(
      tag: 'hero',
      child: Image.asset('img/botanaxLogo.png'),
    );

    return Scaffold(
        backgroundColor: Colors.white,
        body: ScaleTransition(
          scale: _animation,
          child: Container(
              alignment: Alignment.center,
              child: ListView(
                children: <Widget>[
                  logo,
                  SizedBox(height: 20),
                  Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          //Text(_currentlySelected),
                          SizedBox(height: 2),
                          SizedBox(width: 25),
                          FutureBuilder<List<Clients>>(
                              future: fetchClients(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<List<Clients>> snapshot) {
                                if (!snapshot.hasData)
                                  return CircularProgressIndicator();

                                return SearchableDropdown(
                                  items: listOfClients.map((item) {
                                    return new DropdownMenuItem<Clients>(
                                        child: Text(item.nombreCliente +
                                            " " +
                                            item.apellidoPaterno +
                                            " " +
                                            item.apellidoMaterno),
                                        value: item);
                                  }).toList(),
                                  value: currentClient,
                                  onChanged: (value) {
                                    setState(() {
                                      listaProductos.clear();
                                      listaProductosTicket.clear();
                                      listaPrecios.clear();
                                      listaCantidad.clear();
                                      listaTotal.clear();
                                      listaID.clear();
                                      listaIDV.clear();
                                      listaTipoCliente.clear();
                                      listaTipoPago.clear();
                                      productsReemboList.clear();
                                      productsReemboIDList.clear();
                                      sellerIDList.clear();
                                      reemboQuantityList.clear();
                                      reemboQuantityListSend.clear();
                                      reemboQuantityListShow.clear();
                                      tipoCambio.clear();
                                      tipoCambioSend.clear();
                                      tipoCambioShow.clear();

                                      currentClient = value;
                                      selectedClient =
                                          currentClient.nombreCliente +
                                              " " +
                                              currentClient.apellidoPaterno +
                                              " " +
                                              currentClient.apellidoMaterno;

                                      credito =
                                          int.parse(currentClient.credito);
                                      clientID =
                                          int.parse(currentClient.idCliente);
                                      tipoC = currentClient.tipoCliente;

                                      print("Tipo cliente: " + tipoC);
                                      print("Client: " + clientID.toString());

                                      print("Tiene crédito: " +
                                          credito.toString());

                                      if (credito == 1) {
                                        isVisible = true;
                                      } else if (credito == 0) {
                                        isVisible = false;
                                        credito = 0;
                                        valorCredito = "Contado";
                                        //listaTipoPago.add(credito);
                                      }

                                      /*if(tipoC == "A")
                                    {
                                      listaProductos.clear();
                                      listaPrecios.clear();
                                      listaCantidad.clear();
                                      listaTotal.clear();
                                      listaID.clear();
                                      listaIDV.clear();
                                      print("Se elige el primer precio");
                                      listaPrecios.add(_currentProduct.precioVenta.toString());
                                      print("Precio del producto 1: " + _currentProduct.precioVenta.toString());
                                    }
                                    else if(tipoC == "B")
                                    {
                                      listaProductos.clear();
                                      listaPrecios.clear();
                                      listaCantidad.clear();
                                      listaTotal.clear();
                                      listaID.clear();
                                      listaIDV.clear();
                                      print("Se elige el segundo precio");
                                      listaPrecios.add(_currentProduct.precioVenta2.toString());
                                      print("Precio del producto 2: " + _currentProduct.precioVenta2.toString());
                                    }*/

                                      /*for(int i = 0; i < listaProductos.length; i ++)
                                    listaTipoPago.add(credito);*/
                                    });
                                  },
                                  isExpanded: false,
                                  style: TextStyle(color: Colors.red),
                                  //value: _currentUser,
                                  hint: Text(
                                    'Selecciona cliente',
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                );
                              }),
                          SizedBox(width: 40),
                          Flexible(
                            child: FloatingActionButton(
                              onPressed: () {
                                presionado = true;
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          RegistrarClientes()),
                                );
                              },
                              child: Icon(
                                Icons.add,
                                color: Colors.yellow,
                              ),
                              mini: true,
                              backgroundColor: Colors.red,
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          SizedBox(width: 25),
                          FutureBuilder<List<Products>>(
                              future: fetchProducts(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<List<Products>> snapshot) {
                                if (!snapshot.hasData)
                                  return CircularProgressIndicator();

                                return SearchableDropdown(
                                  items: listOfProducts.map((item) {
                                    return new DropdownMenuItem<Products>(
                                      child: Text(item.nombreProducto),
                                      value: item,
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      //print("Cliente elegido: " + selectedClient);

                                      if (selectedClient.isEmpty) {
                                        Dialogos dialogos = new Dialogos();
                                        dialogos.emptyClientDialog(context);
                                      } else {
                                        String shortName;
                                        _currentProduct = value;

                                        if (_currentProduct
                                                .nombreProducto.length >=
                                            5)
                                          shortName = _currentProduct
                                              .nombreProducto
                                              .replaceAll(" ", "")
                                              .substring(0, 5);
                                        else
                                          shortName =
                                              _currentProduct.nombreProducto;

                                        if (listaProductos.contains(
                                            _currentProduct.nombreProducto)) {
                                          Dialogos dialogos = new Dialogos();
                                          dialogos.itemSelectedDialog(context);
                                        } else {
                                          listaProductos.add(
                                              _currentProduct.nombreProducto);
                                          listaProductosTicket.add(shortName);
                                          cargando = false;

                                          if (tipoC == "A") {
                                            listaPrecios.add(_currentProduct
                                                .precioVenta
                                                .toString());
                                          } else if (tipoC == "B") {
                                            listaPrecios.add(_currentProduct
                                                .precioVenta2
                                                .toString());
                                          }

                                          cantidad = (int.parse(
                                                  _currentProduct.cantidad) -
                                              int.parse(
                                                  _currentProduct.cantidad));
                                          //cantidadReembo =
                                          listaCantidad.add(cantidad);
                                          listaTotal.add(0);
                                          listaID.add(int.parse(
                                              _currentProduct.idProducto));
                                          listaIDV.add(int.parse(_currentProduct
                                              .idVendedorActual));
                                          productsReemboList.add("");
                                          reemboQuantityList.add(0);
                                          reemboQuantityListSend.add(0);
                                          reemboQuantityListShow.add(0);
                                          productsReemboIDList.add(int.parse(
                                              _currentProduct.idProducto));
                                          tipoCambio.add("No hay cambios");
                                          tipoCambioSend.add("No hay cambios");
                                          tipoCambioShow.add("No hay cambios");
                                        }
                                      }
                                    });
                                  },
                                  isExpanded: false,
                                  style: TextStyle(color: Colors.red),
                                  //value: _currentUser,
                                  hint: Text(
                                    'Selecciona producto',
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                );
                              }),
                        ],
                      ),
                      Visibility(
                        visible: isVisible,
                        child: Row(
                          children: <Widget>[
                            SizedBox(width: 25),
                            DropdownButton<String>(
                              items: [
                                DropdownMenuItem<String>(
                                  child: Text('Crédito'),
                                  value: 'Crédito',
                                ),
                                DropdownMenuItem<String>(
                                  child: Text('Contado'),
                                  value: 'Contado',
                                )
                              ],
                              onChanged: (String value) {
                                setState(() {
                                  listaTipoPago.clear();

                                  valorCredito = value;

                                  //if(credito == 1)
                                  //{
                                });
                              },
                              hint: Text(
                                'Tipo de venta',
                                style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                              ),
                              value: valorCredito,
                              isExpanded: false,
                              style: TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  new Column(
                    children: <Widget>[
                      Center(
                        child: Text(
                          selectedClient,
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 18,
                          ),
                        ),
                      )
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      SizedBox(
                        height: 225,
                        child: cargando
                            ? Container(
                                child: Text("No se han seleccionado productos",
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 18,
                                    )))
                            : ListView.builder(
                                itemCount: listaProductos.length,
                                itemBuilder: (BuildContext ctxt, int index) {
                                  final item = listaProductos[index];
                                  final price = listaPrecios[index];
                                  final idProduct = listaID[index];
                                  final idSeller = listaIDV[index];

                                  return Dismissible(
                                    key: Key(item),
                                    onDismissed: (direction) {
                                      setState(() {
                                        listaProductos.removeAt(index);
                                        listaProductosTicket.removeAt(index);
                                        listaPrecios.removeAt(index);
                                        //listaTipoCliente.removeAt(index);

                                        print("Precio: " + price);
                                        totalFinal = totalFinal -
                                            (double.parse(price) *
                                                listaCantidad[index]);

                                        listaCantidad.removeAt(index);
                                        listaTotal.removeAt(index);
                                        listaID.removeAt(index);
                                        listaIDV.removeAt(index);
                                        reemboQuantityList.removeAt(index);
                                        reemboQuantityListSend.removeAt(index);
                                        reemboQuantityListShow.removeAt(index);
                                        tipoCambio.removeAt(index);
                                        tipoCambioSend.removeAt(index);
                                        tipoCambioShow.removeAt(index);
                                        productsReemboList.remove(item);
                                        productsReemboIDList.remove(idProduct);
                                        sellerIDList.remove(idSeller);
                                      });
                                    },
                                    background: Container(
                                      color: Colors.red,
                                      child: Center(
                                        child: Text(
                                          'Eliminar',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    child: Center(
                                        child: new Center(
                                      child: ListTile(
                                        title: Row(
                                          children: <Widget>[
                                            Flexible(
                                              child: Text(
                                                listaProductos[index],
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.red),
                                              ),
                                            ),
                                            SizedBox(width: 100),
                                            Flexible(
                                              child: Text(
                                                tipoCambio[index],
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.red),
                                              ),
                                            )
                                          ],
                                        ),
                                        subtitle: Row(
                                          children: <Widget>[
                                            Flexible(
                                              child: Text(
                                                "Cantidad a vender: " +
                                                    listaCantidad[index]
                                                        .toString(),
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.red),
                                              ),
                                            ),
                                            SizedBox(width: 20),
                                            Flexible(
                                              child: Text(
                                                "Cantidad a reembolsar: " +
                                                    reemboQuantityList[index]
                                                        .toString(),
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.red),
                                              ),
                                            )
                                          ],
                                        ),
                                        trailing: Text(
                                          listaPrecios[index],
                                          style: TextStyle(
                                              fontSize: 12, color: Colors.red),
                                        ),
                                        onTap: () {
                                          setState(() {
                                            productIndex = index;
                                            //cantidadController.text = listaCantidad[index].toString();
                                            //cantidadReemboController.text = reemboQuantityList[index].toString();

                                            /*if (reemboQuantityList[index] == 0)
                                      {
                                        reembo = null;
                                        cambio = null;
                                        isReemboVisible = false;
                                      }*/

                                            cantidadProducto(context);

                                            currentProductName = "";
                                            currentProductID = 0;
                                            currentSellerID = 0;
                                            currentQuantity = 0;

                                            currentProductName =
                                                listaProductos[index];
                                            currentProductID = listaID[index];
                                            currentSellerID = listaIDV[index];

                                            print("ID del producto actual: " +
                                                currentProductID.toString());
                                          });
                                        },
                                      ),
                                    )),
                                  );
                                },
                              ),
                      ),
                      SizedBox(height: 10),
                      new Column(
                        children: <Widget>[
                          new Text(
                            totalFinal.toString(),
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      new ButtonTheme(
                        minWidth: 200.0,
                        height: 44.0,
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          color: Colors.red,
                          child: Text(
                            'VENDER',
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                          onPressed: () {
                            String productName;
                            Dialogos dialogos = new Dialogos();

                            isReemboQuantityZero.clear();
                            isSaleQuantityZero.clear();

                            for (int i = 0; i < listaProductos.length; i++) {
                              if (reembo == "Si" &&
                                  reemboQuantityList[i] == 0) {
                                productName = listaProductos[i];
                                dialogos.noReemboQuantityDialog(
                                    context, productName);

                                isReemboQuantityZero.add(true);
                              } else
                                isReemboQuantityZero.add(false);

                              if (reemboQuantityList[i] == 0 &&
                                  (reembo == "Si" ||
                                      reembo == null ||
                                      reembo == "No") &&
                                  listaCantidad[i] == 0) {
                                String productName = listaProductos[i];
                                dialogos.noReemboAndProductDialog(
                                    context, productName);

                                isSaleQuantityZero.add(true);
                                //print("El producto " + productName + "no tiene cantidad de reembo");
                              } else
                                isSaleQuantityZero.add(false);
                            }

                            if (listaProductos.isEmpty)
                              dialogos.emptyListDialog(context);
                            else if (selectedClient.isEmpty)
                              dialogos.emptyClientDialog(context);
                            else if (valorCredito == null && totalFinal > 0)
                              dialogos.emptySellStatusDialog(context);
                            else if ((!isReemboQuantityZero.contains(true) &&
                                    !isSaleQuantityZero.contains(true) &&
                                    listaProductos.length >= 1) ||
                                (isReemboQuantityZero.contains(false) &&
                                    isSaleQuantityZero.contains(false) &&
                                    listaProductos.length == 1)) {
                              for (int i = 0; i < listaProductos.length; i++) {
                                listaIDC
                                    .add(int.parse(currentClient.idCliente));
                                listaTPV.add(2);

                                if (tipoC == "A")
                                  listaTipoCliente.add("A");
                                else if (tipoC == "B")
                                  listaTipoCliente.add("B");

                                if (credito == 1) {
                                  if (valorCredito == "Crédito")
                                    listaTipoPago.add(1);
                                  else if (valorCredito == "Contado")
                                    listaTipoPago.add(0);
                                } else if (credito == 0) {
                                  listaTipoPago.add(0);
                                }
                              }

                              if (reemboQuantityListShow.contains(0))
                                reemboQuantityListShow
                                    .removeWhere((q) => q == 0);

                              if (tipoCambioShow.contains(null) ||
                                  tipoCambioShow.contains("No hay cambios") ||
                                  tipoCambioShow.contains(0))
                                tipoCambioShow.removeWhere((tCambio) =>
                                    tCambio == null ||
                                    tCambio == "No hay cambios");

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignApp()),
                              );

                              print("ID de los productos vendidos: " +
                                  listaID.toString());
                              print("Cantidad vendida de cada producto: " +
                                  listaCantidad.toString());
                              print("ID de productos reembolsados: " +
                                  productsReemboIDList.toString());
                              print("Cantidad de los productos reembolsados: " +
                                  reemboQuantityListSend.toString());
                              print("Reembo quantity list show: " +
                                  reemboQuantityListShow.toString());
                            }
                          },
                        ),
                      ),
                      SizedBox(height: 10),
                      new ButtonTheme(
                        minWidth: 200.0,
                        height: 44.0,
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          color: Colors.red,
                          child: Text(
                            'MENÚ PRINCIPAL',
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Funciones()),
                            );
                          },
                        ),
                      ),
                    ],
                  )
                ],
              )),
        ));
  }

  void cantidadProducto(BuildContext context) {
    reembo = null;
    cambio = null;
    isReemboVisible = false;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(listaProductos[productIndex]),
          content: StatefulBuilder(
            builder: (BuildContext context, setState) {
              return SingleChildScrollView(
                  child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    controller: cantidadController,
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      BlacklistingTextInputFormatter(
                          new RegExp("[\\-|\\ |\\,|\\.]"))
                    ],
                    decoration: InputDecoration(hintText: "Cantidad"),
                  ),
                  DropdownButton<String>(
                    items: [
                      DropdownMenuItem<String>(
                        child: Text("Si"),
                        value: "Si",
                      ),
                      DropdownMenuItem<String>(
                        child: Text("No"),
                        value: "No",
                      )
                    ],
                    onChanged: (String value) {
                      setState(() {
                        reembo = value;
                        print("Reembo: " + reembo);

                        if (reembo == "Si" &&
                            isReemboVisible ==
                                false /*&& !productsReemboList.contains(currentProductName)*/) {
                          isReemboVisible = true;
                        } else if (reembo == "No" || reembo == null) {
                          isReemboVisible = false;
                        }
                      });
                    },
                    hint: Text(
                      '¿Reembo?',
                      style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                    value: reembo,
                    isExpanded: false,
                    style: TextStyle(color: Colors.red),
                  ),
                  Visibility(
                    visible: isReemboVisible,
                    child: Column(
                      children: <Widget>[
                        TextField(
                          controller: cantidadReemboController,
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: [
                            BlacklistingTextInputFormatter(
                                new RegExp("[\\-|\\ |\\,|\\.]"))
                          ],
                          decoration:
                              InputDecoration(hintText: "Cantidad reembo"),
                        ),
                        DropdownButton<String>(
                          items: [
                            DropdownMenuItem<String>(
                              child: Text('Reembo'),
                              value: 'Reembo',
                            ),
                            DropdownMenuItem<String>(
                              child: Text('Caducado'),
                              value: 'Caducado',
                            ),
                            DropdownMenuItem<String>(
                              child: Text('Cambio'),
                              value: 'Cambio',
                            )
                          ],
                          onChanged: (String value) {
                            setState(() {
                              cambio = value;
                            });
                          },
                          hint: Text(
                            'Motivo',
                            style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                          value: cambio,
                          isExpanded: false,
                          style: TextStyle(color: Colors.red),
                        )
                      ],
                    ),
                  )
                ],
              ));
            },
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Cancelar"),
              onPressed: () {
                Navigator.of(context).pop();
                cantidadController.text = "";
              },
            ),
            new FlatButton(
              child: new Text("Aceptar"),
              onPressed: () {
                setState(() {
                  Navigator.of(context).pop();

                  if (isReemboVisible &&
                      int.parse(cantidadReemboController.text) > 0 &&
                      !productsReemboList.contains(currentProductName)) {
                    productsReemboList[productIndex] = currentProductName;
                    productsReemboIDList[productIndex] = currentProductID;

                    for (int i = 0; i < listaProductos.length; i++) {
                      sellerIDList.add(currentSellerID);
                    }
                  } else if (!isReemboVisible &&
                      productsReemboList.contains(currentProductName)) {
                    productsReemboList.remove(currentProductName);
                    productsReemboIDList.remove(currentProductID);
                    sellerIDList.remove(currentSellerID);
                    reemboQuantityList[productIndex] = 0;
                    reemboQuantityListSend[productIndex] = 0;
                    reemboQuantityListShow[productIndex] = 0;
                    tipoCambio[productIndex] = "No hay cambios";
                    tipoCambioSend[productIndex] = "No hay cambios";
                    tipoCambioShow[productIndex] = "No hay cambios";
                  }

                  print("Is reembo visible: " + isReemboVisible.toString());

                  if (reembo == "Si" && cambio == null) {
                    Dialogos dialogos = new Dialogos();
                    dialogos.noReemboSelectionDialog(context);
                  } else if (reembo == "Si") {
                    if (cantidadReemboController.text != "") {
                      reemboQuantity = int.parse(cantidadReemboController.text);

                      if (reemboQuantity > 0) {
                        reemboQuantityList[productIndex] = reemboQuantity;
                        reemboQuantityListSend[productIndex] = reemboQuantity;
                        reemboQuantityListShow[productIndex] = reemboQuantity;
                        cantidadReemboController.text = "";
                        tipoCambio[productIndex] = cambio;
                        tipoCambioSend[productIndex] = cambio;
                        tipoCambioShow[productIndex] = cambio;
                      } else {
                        Dialogos dialogos = new Dialogos();
                        dialogos.invalidQuantityDialog(context);
                      }
                    } else {
                      Dialogos dialogos = new Dialogos();
                      dialogos.invalidQuantityDialog(context);
                    }
                  } else if (reembo == "No") {
                    tipoCambio[productIndex] = "No hay cambios";
                  }

                  if (cantidadController.text != "")
                    cantidad = int.parse(cantidadController.text);
                  else
                    cantidad = 0;

                  listaCantidad[productIndex] = cantidad;

                  total = total +
                      (double.parse(listaPrecios[productIndex]) *
                          listaCantidad[productIndex]);
                  listaTotal[productIndex] = total;

                  totalFinal = totalFinal + total;

                  print("Lista total: " + listaTotal.toString());

                  for (int i = 0; i < listaTotal.length; i++)
                    totalFinal2 = totalFinal2 + listaTotal[i];

                  print("Total final: " + totalFinal2.toString());

                  totalFinal = totalFinal2;
                  totalFinal2 = 0;
                  total = 0;
                  cantidadController.text = "";

                  SystemChannels.textInput.invokeMethod('TextInput.hide');

                  reembo = null;

                  print("Cantidad de cada producto a devolver: " +
                      reemboQuantityListSend.toString());
                  //isReemboVisible = false;
                });
              },
            ),
          ],
        );
      },
    );
  }
}

class GetBotana {
  List<String> getProducts() {
    return listaProductosTicket;
  }

  String getClient() {
    return selectedClient;
  }

  List<String> getPrices() {
    return listaPrecios;
  }

  List<int> getQuantity() {
    return listaCantidad;
  }

  List<double> getTotalPrices() {
    return listaTotal;
  }

  double getTotal() {
    return totalFinal;
  }
}

class Products {
  String idProducto;
  String idVendedorActual;
  String nombreProducto;
  String cantidad;
  String precioVenta;
  String precioVenta2;

  Products(
      {this.idProducto,
      this.idVendedorActual,
      this.nombreProducto,
      this.cantidad,
      this.precioVenta,
      this.precioVenta2});

  factory Products.fromJson(Map<String, dynamic> json) {
    return Products(
        idProducto: json['id_p'],
        idVendedorActual: json['id_v'],
        nombreProducto: json['nombre'],
        cantidad: json['cantidad_actual'],
        precioVenta: json['precio_venta'],
        precioVenta2: json['precio_venta2']);
  }

  Map<String, dynamic> toJson() {
    return {
      "id_producto": listaID,
      "id_vendedor": listaIDV,
      "id_cliente": listaIDC,
      "cantidad": listaCantidad,
      "tipo_pago": listaTipoPago,
      "tipo_c": listaTipoCliente,
      "tpv": listaTPV
    };
  }

  @override
  String toString() {
    return this.nombreProducto;
  }
}

class Clients {
  String idUsuario;
  String idCliente;
  String nombreCliente;
  String apellidoPaterno;
  String apellidoMaterno;
  String telefono;
  String estado;
  String ciudad;
  String colonia;
  String calle;
  String numero;
  String credito;
  String tipoCliente;

  Clients(
      {this.idUsuario,
      this.idCliente,
      this.nombreCliente,
      this.apellidoPaterno,
      this.apellidoMaterno,
      this.telefono,
      this.estado,
      this.ciudad,
      this.colonia,
      this.calle,
      this.numero,
      this.credito,
      this.tipoCliente});

  factory Clients.fromJson(Map<String, dynamic> json) {
    return Clients(
        idUsuario: json['id_u'],
        idCliente: json['id_c'],
        nombreCliente: json['nombre'],
        apellidoPaterno: json['apellido_paterno'],
        apellidoMaterno: json['apellido_materno'],
        telefono: json['telefono'],
        estado: json['estado'],
        ciudad: json['ciudad'],
        colonia: json['colonia'],
        calle: json['calle'],
        numero: json['numero'],
        credito: json['credito'],
        tipoCliente: json['tipo_cliente']);
  }

  Map<String, dynamic> toJson() {
    return {"id_cliente": clientID};
  }

  @override
  String toString() {
    return this.nombreCliente;
  }
}

class Presionado {
  bool botonPresionado() {
    return presionado;
  }
}

class UpdateProduct {
  void updateProduct() async {
    var url = "https://somadi.com.mx/botanax/app/sellProduct.php";
    final headers = {'Content-Type': 'application/json'};

    Products products = new Products();

    var productos = new Products.fromJson(products.toJson());

    String jsonBody = json.encode(productos);
    print(jsonBody);

    final response = await http.post(Uri.parse(url), headers: headers, body: jsonBody);

    print(response.statusCode);
  }
}

class Reembolsos {
  List<int> iVendedor, idCliente, idProducto, cantidad;
  List<String> motivo;

  Reembolsos(
      {this.iVendedor,
      this.idCliente,
      this.idProducto,
      this.cantidad,
      this.motivo});

  factory Reembolsos.fromJson(Map<String, dynamic> json) {
    return Reembolsos(
        iVendedor: json['id_u'],
        idCliente: json['id_c'],
        idProducto: json['id_p'],
        cantidad: json['cantidad'],
        motivo: json['motivo']);
  }

  Map<String, dynamic> toJson() {
    return {
      "id_u": listaIDV,
      "id_c": sellerIDList,
      "id_p": productsReemboIDList,
      "cantidad": reemboQuantityListSend,
      "motivo": tipoCambioSend
    };
  }

  List<String> getProduct() {
    return productsReemboList;
  }

  List<int> getQuantity() {
    return reemboQuantityListShow;
  }

  List<int> getProductID() {
    return listaID;
  }

  List<int> getSellerID() {
    return listaIDV;
  }

  List<int> getClientID() {
    return listaIDC;
  }

  List<String> getTipoCambio() {
    return tipoCambioShow;
  }
}

class InsertarReembo {
  void insertarReembo() async {
    var url = "https://somadi.com.mx/botanax/app/reembo.php";
    final headers = {'Content-Type': 'application/json'};

    Reembolsos reembolsos = new Reembolsos();

    var reembos = new Reembolsos.fromJson(reembolsos.toJson());

    String jsonBody = json.encode(reembos);
    print(jsonBody);

    final response = await http.post(Uri.parse(url), headers: headers, body: jsonBody);

    print(response.statusCode);
  }
}
