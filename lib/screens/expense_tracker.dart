import 'package:expense_tracker/model/expense.dart';
import 'package:expense_tracker/widgets/expense_list/expense_list.dart';
import 'package:expense_tracker/widgets/new_expense.dart';
import 'package:flutter/material.dart';

class ExpenseTracker extends StatefulWidget {
  const ExpenseTracker({super.key});

  @override
  State<ExpenseTracker> createState() => _ExpenseTrackerState();
}

class _ExpenseTrackerState extends State<ExpenseTracker> {
  final List<Expense> _registeredExpense = [
    Expense(
      title: 'Burger',
      amount: 53.136,
      date: DateTime.now(),
      category: Category.food,
    ),
    Expense(
      title: 'Travel to Bahrain',
      amount: 100,
      date: DateTime.now(),
      category: Category.travel,
    ),
  ];

  void _addExpense(Expense expense) {
    setState(() {
      _registeredExpense.add(expense);
    });
  }

  void _removeExpense(Expense expense) {
    final indexExpense = _registeredExpense.indexOf(expense);
    setState(() {
      _registeredExpense.remove(expense);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: Duration(seconds: 5),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _registeredExpense.insert(indexExpense, expense);
            });
          },
        ),
        content: Text('Expense Deleted! '),
      ),
    );
  }

  void _showRegisteredOverlay() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) {
        return NewExpense(onSaveExpense: _addExpense);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter ExpenseTracker '),
        actions: [
          IconButton(onPressed: _showRegisteredOverlay, icon: Icon(Icons.add)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text('Chart'),
            SizedBox(height: 20),
            Expanded(
              child: ExpenseList(
                registeredExpense: _registeredExpense,
                onRemoveExpense: _removeExpense,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
