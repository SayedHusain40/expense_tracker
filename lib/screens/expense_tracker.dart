import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/chart/chart.dart';
import 'package:expense_tracker/widgets/expense_list/expense_list.dart';
import 'package:expense_tracker/widgets/new_expense.dart';
import 'package:flutter/material.dart';

class ExpenseTracker extends StatefulWidget {
  const ExpenseTracker({super.key});

  @override
  State<ExpenseTracker> createState() => _ExpenseTrackerState();
}

class _ExpenseTrackerState extends State<ExpenseTracker> {
  final List<Expense> _registeredExpenses = [
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
    Expense(
      title: 'Cinema',
      amount: 100,
      date: DateTime.now(),
      category: Category.leisure,
    ),
    Expense(
      title: 'Cinema',
      amount: 100,
      date: DateTime.now(),
      category: Category.leisure,
    ),
    Expense(
      title: 'Cinema',
      amount: 100,
      date: DateTime.now(),
      category: Category.leisure,
    ),
    Expense(
      title: 'Cinema',
      amount: 100,
      date: DateTime.now(),
      category: Category.leisure,
    ),
    Expense(
      title: 'Cinema',
      amount: 100,
      date: DateTime.now(),
      category: Category.leisure,
    ),
  ];

  void _addExpense(Expense expense) {
    setState(() {
      _registeredExpenses.add(expense);
    });
  }

  void _removeExpense(Expense expense) {
    final removedExpenseIndex = _registeredExpenses.indexOf(expense);
    setState(() {
      _registeredExpenses.remove(expense);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 5),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _registeredExpenses.insert(removedExpenseIndex, expense);
            });
          },
        ),
        content: const Text('Expense Deleted! '),
      ),
    );
  }

  void _openNewExpenseModal() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      useSafeArea: true,
      // barrierColor: Colors.amber,
      constraints: const BoxConstraints(
        maxWidth: double.infinity,
        minHeight: double.infinity,
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
          ),
          child: NewExpense(onAddExpense: _addExpense),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    Widget mainContent = const Center(
      child: Text('No Expense found. Start adding some!'),
    );

    if (_registeredExpenses.isNotEmpty) {
      mainContent = ExpenseList(
        registeredExpense: _registeredExpenses,
        onRemoveExpense: _removeExpense,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter ExpenseTracker '),
        actions: [
          IconButton(
            onPressed: _openNewExpenseModal,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: width < 600
            ? Column(
                children: [
                  Chart(_registeredExpenses),
                  Expanded(child: mainContent),
                ],
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: Chart(_registeredExpenses)),
                  Expanded(child: mainContent),
                ],
              ),
      ),
    );
  }
}
