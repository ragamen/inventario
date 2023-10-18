import 'package:flutter/material.dart';
import 'package:inventario/api.dart';

import 'package:postgres/postgres.dart';

void main() {
  runApp(const MaterialApp(
    home: RegistrarProductoScreen(),
  ));
}

class RegistrarProductoScreen extends StatefulWidget {
  const RegistrarProductoScreen({super.key});

  @override
  RegistrarProductoScreenState createState() => RegistrarProductoScreenState();
}

class RegistrarProductoScreenState extends State<RegistrarProductoScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _codigo;
  late String _nombre;
  late String _descripcion;
  late double _precio;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Producto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Código'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa el código del producto';
                  }
                  return null;
                },
                onChanged: (value) {
                  _codigo = value;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa el nombre del producto';
                  }
                  return null;
                },
                onChanged: (value) {
                  _nombre = value;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Descripción'),
                onChanged: (value) {
                  _descripcion = value;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Precio'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingresa el precio del producto';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Por favor, ingresa un valor numérico válido';
                  }
                  return null;
                },
                onChanged: (value) {
                  _precio = double.parse(value);
                },
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
              
                  if (_formKey.currentState!.validate()) {
                    // Crear el objeto Producto con los datos ingresados
                    Producto producto = Producto(
                      codigo: _codigo,
                      nombre: _nombre,
                      descripcion: _descripcion,
                      precio: _precio,
                    );
                    enviarDatos(producto);
                    //DatabaseHelper._instance.insertProducto(producto);
                    // Aquí puedes realizar las operaciones necesarias para registrar el producto en la base de datos o almacenarlo en alguna estructura de datos

                    // Mostrar un mensaje de éxito
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Producto registrado con éxito')),
                    );

                    // Reiniciar los campos del formulario
                    _formKey.currentState!.reset();
                  }
                },
                child: const Text('Registrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Producto {
  final String codigo;
  final String nombre;
  final String descripcion;
  final double precio;

  Producto({required this.codigo, required this.nombre, required this.descripcion, required this.precio});
}




class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;

  static late PostgreSQLConnection _connection;

  DatabaseHelper.internal();

  Future<PostgreSQLConnection> get connection async {
    //return _connection;
  
    _connection = await initConnection();
    return _connection;
  }

  Future<PostgreSQLConnection> initConnection() async {
    final connection = PostgreSQLConnection(
      'host',
      5432,
      'database',
      username: 'username',
      password: 'password',
    );

    await connection.open();

    return connection;
  }

  Future<void> insertProducto(Producto producto) async {
    final connection = await this.connection;
    await connection.query('''
      INSERT INTO productos (codigo, nombre, descripcion, precio)
      VALUES (@codigo, @nombre, @descripcion, @precio)
    ''', substitutionValues: {
      'codigo': producto.codigo,
      'nombre': producto.nombre,
      'descripcion': producto.descripcion,
      'precio': producto.precio,
    });
  }
}



