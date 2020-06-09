import 'package:flutter/material.dart';
import 'package:formval/src/bloc/provider.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _crearFondo(context),
          _loginForm(context),
        ],
      ),
    );
  }
}

Widget _loginForm(BuildContext context) {
  final bloc = Provider.of(context);
  final size = MediaQuery.of(context).size;

  return SingleChildScrollView(
    child: Column(
      children: <Widget>[
        SafeArea(
          child: Container(
            height: 180,
          ),
        ),
        Container(
          width: size.width * .85,
          margin: EdgeInsets.symmetric(vertical: 30),
          padding: EdgeInsets.symmetric(vertical: 50),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 3,
                  offset: Offset(0, 5),
                  spreadRadius: 3,
                )
              ]),
          child: Column(
            children: <Widget>[
              Text('Ingreso', style: TextStyle(fontSize: 20)),
              SizedBox(height: 40),
              _crearEmail(bloc),
              SizedBox(height: 30),
              _crearPassword(bloc),
              SizedBox(height: 30),
              _crearBoton(bloc),
            ],
          ),
        ),
        Text('¿Olvido la contraseña?'),
        SizedBox(height: 100),
      ],
    ),
  );
}

Widget _crearEmail(LoginBloc bloc) {
  return StreamBuilder(
      stream: bloc.emailStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: TextField(
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              icon: Icon(Icons.alternate_email, color: Colors.deepPurple),
              hintText: 'ejemplo@coreo.com',
              labelText: 'Correo electrónico',
              counterText: snapshot.data,
              errorText: snapshot.error,
            ),
            onChanged: bloc.changeEmail,
          ),
        );
      });
}

Widget _crearPassword(LoginBloc bloc) {
  return StreamBuilder(
      stream: bloc.passwordStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: TextField(
            obscureText: true,
            decoration: InputDecoration(
              icon: Icon(Icons.lock, color: Colors.deepPurple),
              labelText: 'Contraseña',
              counterText: snapshot.data,
              errorText: snapshot.error,
            ),
            onChanged: bloc.changePassword,
          ),
        );
      });
}

Widget _crearBoton(LoginBloc bloc) {
  return StreamBuilder(
      stream: bloc.formValidStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return RaisedButton(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 80, vertical: 20),
            child: Text('Ingresar'),
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          elevation: 0,
          color: Colors.deepPurple,
          textColor: Colors.white,
          onPressed: snapshot.hasData ? () => _login(context, bloc) : null
        );
      });
}


_login(BuildContext context, LoginBloc bloc) {
  print('${bloc.email}, ${bloc.password}');
  Navigator.pushReplacementNamed(context, 'home');
}


Widget _crearFondo(BuildContext context) {
  final size = MediaQuery.of(context).size;

  final fondomorado = Container(
    height: size.height * 0.4,
    width: double.infinity,
    decoration: BoxDecoration(
      gradient: LinearGradient(colors: <Color>[
        Color.fromRGBO(63, 63, 156, 1),
        Color.fromRGBO(90, 70, 178, 1),
      ]),
    ),
  );

  final circulo = Container(
    width: 100,
    height: 100,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(100),
      color: Color.fromRGBO(255, 255, 255, 0.5),
    ),
  );

  return Stack(
    children: <Widget>[
      fondomorado,
      Positioned(top: 90, left: 30, child: circulo),
      Positioned(top: -50, right: -10, child: circulo),
      Positioned(top: -50, left: -20, child: circulo),
      Container(
        padding: EdgeInsets.only(top: 80),
        child: Column(
          children: <Widget>[
            Icon(Icons.person_pin, color: Colors.white, size: 100),
            SizedBox(height: 10, width: double.infinity),
            Text('Inicia Sesion',
                style: TextStyle(color: Colors.white, fontSize: 25)),
          ],
        ),
      ),
    ],
  );
}


