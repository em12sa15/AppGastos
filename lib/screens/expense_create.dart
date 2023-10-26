import 'package:flutter/material.dart';
import 'package:appgastos/models/expense.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:appgastos/screens/expensivelist.dart';
import 'package:firebase_database/firebase_database.dart';


class ExpenseCreateForm extends StatefulWidget {
  @override
  _ExpenseCreateFormState createState() => _ExpenseCreateFormState();
}

class _ExpenseCreateFormState extends State<ExpenseCreateForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _amountController = TextEditingController();
  TextEditingController _expenseController = TextEditingController();
  List<Expense> expensesList = [];
  List<Widget> expenseFields = []; 

  void addCategoryToFirebase(String nombre, String descripcion, double monto) {
  final DatabaseReference databaseReference = FirebaseDatabase.instance.reference();
  final categoryReference = databaseReference.child('categorias').push();

  categoryReference.set({
    'nombre': nombre,
    'descripcion': descripcion,
    'monto': monto,
    }).then((_) {
      print('Categoría agregada con éxito.');
    }).catchError((error) {
      print('Error al agregar la categoría: $error');
    });
}

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      duration: Duration(seconds: 2),
    ));
  }

  @override
  void initState() {
    super.initState();
    expenseFields.add(_buildExpenseFields()); 
  }

  Widget _buildExpenseFields() {
    return Row(
      children: <Widget>[
        Expanded(
          child: TextFormField(
            controller: _expenseController,
            decoration: InputDecoration(labelText: 'Gasto'),
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return 'Ingresa un gasto';
              }
              return null;
            },
          ),
        ),
        SizedBox(width: 16.0),
        Expanded(
          child: TextFormField(
            controller: _descriptionController,
            decoration: InputDecoration(labelText: 'Descripción'),
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return 'Ingresa una descripción del gasto';
              }
              return null;
            },
          ),
        ),
        SizedBox(width: 16.0),
        Expanded(
          child: TextFormField(
            controller: _amountController,
            decoration: InputDecoration(
              labelText: 'Monto',
              prefixText: '\$',
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return 'Ingresa un monto';
              }
              return null;
            },
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}$')),
            ],
          ),
        ),
      ],
    );
  }

  // ...

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registrar gastos'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              ...expenseFields, 
              SizedBox(height: 20.0),
              Align(
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          final description = _descriptionController.text;
                          final amount = double.parse(_amountController.text);
                          final expense = _expenseController.text;
                          final newExpense = Expense(
                            id: expensesList.length + 1,
                            description: description,
                            amount: amount,
                            expense: expense,
                            date: DateTime.now(),
                          );

                          addCategoryToFirebase('Alimentación', 'Canasta familiar', 2500.0);

                          setState(() {
                            expensesList.add(newExpense);
                            expenseFields.add(_buildExpenseFields());
                            _descriptionController.clear();
                            _amountController.clear();
                            _expenseController.clear();
                          });

                          _showSnackBar('Gasto registrado con éxito');
                        }
                      },
                      child: Text('Guardar gasto'),
                    ),
                    SizedBox(width: 16.0),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              MyExpenseListScreen(expenses: expensesList),
                        ));
                      },
                      child: Text('Ver lista de gastos'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

