import 'package:flutter/material.dart';
import 'package:appgastos/models/expense.dart';

class MyExpenseListScreen extends StatelessWidget {
  final List<Expense> expenses;

  MyExpenseListScreen({required this.expenses});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Gastos'),
      ),
      body: ListView.builder(
        itemCount: expenses.length,
        itemBuilder: (context, index) {
          final expense = expenses[index];
         
          return ListTile(
            title: Text(expense.description),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Gasto: ${expense.expense}'),
                Text('Descripción: ${expense.description}'),
                Text('Monto: \$${expense.amount.toStringAsFixed(2)}'),
                Text('Fecha: ${expense.date.toString()}'),
              ],
            ),
          );
        },
      ),
    );
  }
}
