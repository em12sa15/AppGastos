import 'package:appgastos/models/expense.dart'; 

class ExpenseService {
 
  static Future<List<Expense>> getExpenses() async {
   
    return [
      Expense(id: 1,  expense: 'Transporte', description: 'Comida', amount: 20.0, date: DateTime.now()),
      Expense(id: 2, expense: 'Transporte', description: 'Transporte', amount: 10.0, date: DateTime.now()),
      
    ];
  }
}
