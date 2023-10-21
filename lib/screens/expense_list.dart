import 'package:flutter/material.dart';
import 'package:appgastos/models/expense.dart';
import 'package:appgastos/screens/expense_create.dart';
import 'package:appgastos/models/expense_service.dart'; 

class ExpenseList extends StatefulWidget {
  @override
  _ExpenseListState createState() => _ExpenseListState();
}

class _ExpenseListState extends State<ExpenseList> {
  late Future<List<Expense>> futureExpenses;

  @override
  void initState() {
    super.initState();
    futureExpenses = ExpenseService.getExpenses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Gastos'), // Aplicando const aquí
        actions: [
          IconButton(
            icon: const Icon(Icons.add), // Aplicando const aquí
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ExpenseCreateForm(),
                ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Expense>>(
        future: futureExpenses,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(), // Aplicando const aquí
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            final expenses = snapshot.data ?? [];
            return ListView.builder(
              itemCount: expenses.length,
              itemBuilder: (context, index) {
                final expense = expenses[index];
                return ListTile(
                  title: Text(expense.description),
                  subtitle: Text('Monto: \$${expense.amount.toStringAsFixed(2)}'),
                  trailing: Text('Fecha: ${expense.date.toLocal().toString().split(' ')[0]}'),
                );
              },
            );
          }
        },
      ),
    );
  }
}
