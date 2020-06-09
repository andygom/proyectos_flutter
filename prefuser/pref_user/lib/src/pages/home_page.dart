import 'package:flutter/material.dart';
import 'package:pref_user/src/shared_prefs/preferencias_usuario.dart';
import 'package:pref_user/src/widgets/menu_widget.dart';

class HomePage extends StatelessWidget {
  static final String routeName = 'home';
  final prefs = new PreferenciasUsuario();

  @override
  Widget build(BuildContext context) {

    String genero = '';
    if (prefs.genero == 1){
      genero = 'Masculino';
    }else {
      genero = 'Femenino';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Preferencias de Usuario'),
        backgroundColor: (prefs.colorSecundario) ? Colors.teal : Colors.blue,
      ),
      drawer: MenuWidget(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('Color secundario: ${ prefs.colorSecundario }'),
          Divider(),
          Text('Genero: ${ genero }'),
          Divider(),
          Text('Nombre de usuario: ${ prefs.nombreUsuario }'),
          Divider(),
        ],
      ),
    );
  }
}

