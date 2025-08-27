import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/expense_list/expense_item.dart';
import 'package:flutter/material.dart';

class ExpenseList extends StatelessWidget {
  const ExpenseList({
    super.key,
    required this.registeredExpense,
    required this.onRemoveExpense,
  });

  final List<Expense> registeredExpense;

  final Function(Expense expense) onRemoveExpense;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: registeredExpense.length,
      itemBuilder: (context, index) {
        return Dismissible(
          key: ValueKey(registeredExpense[index]),
          background: Container(color: Colors.redAccent),
          child: ExpenseItem(registeredExpense[index]),
          onDismissed: (direction) {
            onRemoveExpense(registeredExpense[index]);
          },
        );
      },
    );
  }
}
