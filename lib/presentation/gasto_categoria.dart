import 'package:flutter/material.dart';
import 'package:mi_app_gastos/db_project.dart';
import 'package:mi_app_gastos/presentation/gasto.dart';

void main() {
  runApp(
    MaterialApp(
      home: GastosScreen(),
    ),
  );
}

class GastosScreen extends StatefulWidget {
  @override
  _GastosScreenState createState() => _GastosScreenState();
}

class _GastosScreenState extends State<GastosScreen> {
  List<Gasto> gastos = [];

  @override
  void initState() {
    super.initState();
    _loadGastosFromDatabase();
  }

  Future<void> _loadGastosFromDatabase() async {
    final sqlDb = SQLdb.instance;
    final gastosFromDB = await sqlDb.getAllData();
    setState(() {
      gastos = gastosFromDB.map((data) {
        return Gasto(
          id: data['id'],
          descripcion: data['descripcion'],
          cantidad: data['cantidad'],
        );
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        leading: Icon(Icons.menu),
        title: Text('Gastos'),
      ),
      body: Container(
        color: Colors.white,
        child: ListView.builder(
          itemCount: gastos.length,
          itemBuilder: (context, index) {
            return GastoItem(
              gasto: gastos[index],
              onEdit: () {
                _editGasto(context, gastos[index]);
              },
              onDelete: () {
                _deleteGasto(context, gastos[index]);
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final descripcionController = TextEditingController();
          final cantidadController = TextEditingController();

          final result = await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Agregar Nuevo Gasto'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      decoration: InputDecoration(labelText: 'Descripción'),
                      controller: descripcionController,
                    ),
                    TextField(
                      decoration: InputDecoration(labelText: 'Cantidad'),
                      controller: cantidadController,
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                    child: Text('Cancelar'),
                  ),
                  TextButton(
                    onPressed: () async {
                      final descripcion = descripcionController.text;
                      final cantidad = cantidadController.text;
                      final cantidadInt = int.tryParse(cantidad ?? '');

                      if (cantidadInt != null) {
                        final id = await SQLdb.instance.createData(descripcion, cantidadInt);
                        Navigator.pop(context, id > 0);
                        if (id > 0) {
                          _loadGastosFromDatabase();
                        }
                      } else {
                        print('Error al convertir la cantidad a un valor entero.');
                      }
                    },
                    child: Text('Guardar'),
                  ),
                ],
              );
            },
          );

          if (result != null && result) {
            // La lista de gastos se actualizará automáticamente después de guardar el nuevo gasto
          }
        },
        backgroundColor: Colors.red,
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void _editGasto(BuildContext context, Gasto gasto) async {
    final descripcionController = TextEditingController(text: gasto.descripcion);
    final cantidadController = TextEditingController(text: gasto.cantidad.toString());

    final result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Editar Gasto'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Descripción'),
                controller: descripcionController,
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Cantidad'),
                controller: cantidadController,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                final descripcion = descripcionController.text;
                final cantidad = cantidadController.text;
                final cantidadInt = int.tryParse(cantidad ?? '');

                if (cantidadInt != null) {
                  final id = await SQLdb.instance.updateData(gasto.id, descripcion, cantidadInt);
                  Navigator.pop(context, id > 0);
                  if (id > 0) {
                    _loadGastosFromDatabase();
                  }
                } else {
                  print('Error al convertir la cantidad a un valor entero.');
                }
              },
              child: Text('Guardar'),
            ),
          ],
        );
      },
    );

    if (result != null && result) {
      // La lista de gastos se actualizará automáticamente después de editar un gasto
    }
  }

  void _deleteGasto(BuildContext context, Gasto gasto) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Eliminar Gasto'),
          content: Text('¿Estás seguro de que deseas eliminar este gasto?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                await SQLdb.instance.deleteData(gasto.id);
                Navigator.pop(context, true);
              },
              child: Text('Eliminar'),
            ),
          ],
        );
      },
    );

    if (shouldDelete == true) {
      _loadGastosFromDatabase();
    }
  }
}

class GastoItem extends StatelessWidget {
  final Gasto gasto;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  GastoItem({
    required this.gasto,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onEdit,
      leading: CircleAvatar(
        // Agrega aquí la imagen del gasto si es necesario
      ),
      title: Text(gasto.descripcion),
      subtitle: Text("Cantidad: \$${gasto.cantidad}"),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: onEdit,
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}
