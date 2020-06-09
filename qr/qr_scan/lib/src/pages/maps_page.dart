import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:qr_scan/src/bloc/scan_bloc.dart';
import 'package:qr_scan/src/models/scan_model.dart';
import 'package:qr_scan/src/utils/utilis.dart' as utils;

class MapsPage extends StatelessWidget {
  final scansBloc = new ScansBloc();

  @override
  Widget build(BuildContext context) {

    scansBloc.obtenerScans();

    return StreamBuilder<List<ScanModel>>(
      stream: scansBloc.scansStream,
      builder: (BuildContext context, AsyncSnapshot<List<ScanModel>> snapshot) {
        
        if ( !snapshot.hasData ) {
          return Center(child: CircularProgressIndicator());
        }

        final scans = snapshot.data;

        if ( scans.length == 0 ) {
          return Center(
            child: Text('No hay información'),
            
          );
        }

        return ListView.builder(
          itemCount: scans.length,
          itemBuilder: (context, i ) => Dismissible(
            key: UniqueKey(),
            background: Container( color: Colors.grey ),
            onDismissed: ( direction ) => scansBloc.borrarScans(scans[i].id),
            child: ListTile(
              leading: Icon( Icons.map, color: Theme.of(context).primaryColor ),
              title: Text( scans[i].valor ),
              subtitle: Text('ID: ${ scans[i].id }, Type: ${ scans[i].tipo } '),
              trailing: Icon( Icons.keyboard_arrow_right, color: Colors.grey ),
               
              onTap: () => utils.launchURL(context, ScanModel(valor: scans[i].valor)),
            )
          )          
        );


      },
    );

  }
}



