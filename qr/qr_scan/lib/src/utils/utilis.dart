import 'package:flutter/material.dart';

import 'package:qr_scan/src/models/scan_model.dart';
import 'package:qr_scan/src/pages/home_page.dart';
import 'package:url_launcher/url_launcher.dart';

launchURL(BuildContext context, ScanModel scan) async {
  if (scan.tipo == 'http') {
    if (await canLaunch(scan.valor)) {
      await launch(scan.valor);
    } else {
      throw 'Could not launch ${scan.valor}';
    }
  } else if (scan.tipo == 'geo') {
    Navigator.pushNamed(context, 'mapa', arguments: scan);
  } else {
    print('OK');
  }
}


/* 
abrirScan(BuildContext context, ScanModel scan ) async {
  
  if ( scan.tipo == 'http' ) {

    if (await canLaunch( scan.valor )) {
      await launch(scan.valor);
    } else {
      throw 'Could not launch ${ scan.valor }';
    }
  } 
}  */
