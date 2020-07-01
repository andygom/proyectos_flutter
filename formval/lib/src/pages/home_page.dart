import 'package:flutter/material.dart';
import 'package:formval/src/bloc/provider.dart';
import 'package:formval/src/models/product_model.dart';
import 'package:formval/src/providers/product_provider.dart';

class HomePage extends StatelessWidget {
  final productosProvider = new ProductosProvider();
  
  @override
  
  Widget build(BuildContext context) {
    
    final bloc = Provider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Validación de forms'),
      ),
      body: _crearListado(),
      floatingActionButton: _crearBoton(context),

      /*  Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Email: ${bloc.email}'),
            Divider(),
            Text('Password: ${bloc.password}')
          ],
        ),
      ), */
    );
  }

  Widget _crearListado() {
    return FutureBuilder(
        future: productosProvider.cargarProductos(),
        builder: (BuildContext context,
            AsyncSnapshot<List<ProductoModel>> snapshot) {
          if (snapshot.hasData) {
            final productos = snapshot.data;
            return ListView.builder(
              itemCount: productos.length,
              itemBuilder: (context, i) => _crearItem(context, productos[i]),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
          /*  return snapshot.hasData
              ? ListView.builder(
                  itemCount: productos.length,
                  itemBuilder: (context, i) =>
                      _crearItem(context, productos[i]),
                )
              : Center(child: CircularProgressIndicator()); */
        });
  }

  Widget _crearItem(BuildContext context, ProductoModel producto) {
    return Dismissible(
      key: UniqueKey(),
      background: Container(
        color: Colors.red,
        child: Icon(
          Icons.delete,
          color: Colors.white,
        ),
        alignment: Alignment.centerRight,
      ),
      onDismissed: (direction) => productosProvider.borrarProducto(producto.id),
      child: ListTile(
        title: Text('${producto.titulo} - ${producto.valor}'),
        subtitle: Text(producto.id),
        onTap: () =>
            Navigator.pushNamed(context, 'product', arguments: producto),
      ),
    );
  }

  _crearBoton(BuildContext context) {
    return FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.deepPurple,
        onPressed: () => Navigator.pushNamed(context, 'product'));
  }
}
