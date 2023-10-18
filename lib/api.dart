import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:inventario/main.dart';

Future<void> enviarDatos(Producto producto) async {
  final url = Uri.parse('http://localhost/insertprod.php');
  try{
  final response = await http.post(url, body: {'servername': 'localhost',
    'username': 'root',
    'password': '123456',
    'dbname': 'inventario',
    'tabla': 'productoS',
    'codigo': producto.codigo,
    'nombre': producto.nombre,
    'descripcion': producto.descripcion,
    'precio': producto.precio.toString()
    });
/*    'servername': 'localhost',
    'username': 'root',
    'password': '123456',
    'dbname': 'inventario',
    'tabla': 'producto',
    'codigo': producto.codigo,
    'nombre': producto.nombre,
    'descripcion': producto.descripcion,
    'precio': producto.precio.toString(),*/
  
   if (response.statusCode == 200) {
    // Procesar la respuesta de la API si es necesario
    if (kDebugMode) {
      print('Datos enviados correctamente.');
    }
  } else {
    // Manejar el error en caso de que la solicitud no sea exitosa
    if (kDebugMode) {
      print('Error al enviar los datos. Código de estado: ${response.statusCode}');
    }
  }
  }
catch(e){
  if (kDebugMode) {
    print("Error$e");
  }
}
 
}