import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qr_scan/src/bloc/scan_bloc.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:qr_scan/src/models/scan_model.dart';
import 'package:qr_scan/src/pages/direcciones_page.dart';
import 'package:qr_scan/src/pages/maps_page.dart';
import 'package:qr_scan/src/utils/utilis.dart' as utils;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final scansBloc = new ScansBloc();

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Scanner'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete_forever),
            onPressed: () => _showMyDialog(context, scansBloc),
            //onPressed: scansBloc.borrarScansTodos,
          )
        ],
      ),
      body: _callPage(currentIndex),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.map), title: Text('Mapa')),
            BottomNavigationBarItem(
                icon: Icon(Icons.adjust), title: Text('Direcciones')),
          ]),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.filter_center_focus),
        onPressed: () => _scanQR(context),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }

  _scanQR(BuildContext context) async {
    //https://web.whatsapp.com/
    //geo:40.73359922990751,-74.17897596796878

    var result = await BarcodeScanner.scan();
    /* print(result.type); // The result type (barcode, cancelled, failed)
  print(result.rawContent); // The barcode content
  print(result.format); // The barcode format (as enum)
  print(result.formatNote); // If a unknown format was scanned this field contains a note
  */

    String futureString = result.rawContent;

    if (futureString != null) {
      //print('tenemos informacion');
      final scan = ScanModel(valor: futureString);
      scansBloc.agregarScans(scan);

      if (Platform.isIOS) {
        Future.delayed(Duration(milliseconds: 750), () {
          utils.launchURL(context, scan);
        });
      } else {
        utils.launchURL(context, scan);
      }
    }
    /* try {
      await BarcodeScanner.scan();
    } catch (e) {
      futureString = e.toString();
    }

  

    print('String: $result');

    if (futureString != null) {
      print('tenemos informacion');
      final scan = ScanModel(valor: futureString);
      scansBloc.agregarScans(scan); */

    /*  final scan2 =
          ScanModel(valor: 'geo:40.73359922990751,-74.17897596796878');
      scansBloc.agregarScans(scan2);
 */
    /*     */

/*    if( futureString != null ) {
    final scan = ScanModel ( valor: futureString );
    DBProvider.db.nuevoScan(scan);
  }  */
  }

  Widget _callPage(int paginaActual) {
    switch (paginaActual) {
      case 0:
        return MapsPage();
      case 1:
        return DirectionsPage();

      default:
        return MapsPage();
    }
  }
}

Future<void> _showMyDialog(context, scansBloc) async {

  return showDialog<void>(
    
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Borrar registros'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Se borrarán los registros de mapas y direcciones'),
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Cancelar'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: Text('Aceptar'),
             onPressed: () {
              Navigator.of(context).pop(scansBloc.borrarScansTodos());
            }, 
           //onPressed: scansBloc.borrarScansTodos,
          ),
        ],
      );
    },
  );
}
