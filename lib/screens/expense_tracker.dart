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
      title: 'Burger at McDonald\'s',
      amount: 12.50,
      date: DateTime.now().subtract(const Duration(days: 1)),
      category: Category.food,
    ),
    Expense(
      title: 'Lunch at Subway',
      amount: 8.75,
      date: DateTime.now().subtract(const Duration(days: 2)),
      category: Category.food,
    ),
    Expense(
      title: 'Uber Ride',
      amount: 15.20,
      date: DateTime.now().subtract(const Duration(days: 1)),
      category: Category.travel,
    ),
    Expense(
      title: 'Flight to Bahrain',
      amount: 250.00,
      date: DateTime.now().subtract(const Duration(days: 5)),
      category: Category.travel,
    ),
    Expense(
      title: 'Office Supplies',
      amount: 45.30,
      date: DateTime.now().subtract(const Duration(days: 3)),
      category: Category.work,
    ),
    Expense(
      title: 'Freelance Project Payment',
      amount: 300.00,
      date: DateTime.now().subtract(const Duration(days: 4)),
      category: Category.work,
    ),
    Expense(
      title: 'Movie Night',
      amount: 20.00,
      date: DateTime.now().subtract(const Duration(days: 2)),
      category: Category.leisure,
    ),
    Expense(
      title: 'Coffee with Friends',
      amount: 5.50,
      date: DateTime.now().subtract(const Duration(days: 1)),
      category: Category.leisure,
    ),
    Expense(
      title: 'Concert Ticket',
      amount: 75.00,
      date: DateTime.now().subtract(const Duration(days: 6)),
      category: Category.leisure,
    ),
    Expense(
      title: 'Dinner at Italian Restaurant',
      amount: 45.00,
      date: DateTime.now(),
      category: Category.food,
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
