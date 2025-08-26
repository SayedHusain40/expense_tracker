import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

final formatter = DateFormat.yMd();

enum Category { food, work, leisure, travel }

const categoryIcons = {
  Category.food: Icons.food_bank,
  Category.work: Icons.work,
  Category.leisure: Icons.free_breakfast,
  Category.travel: Icons.travel_explore,
};

class Expense {
  final String title;
  final double amount;
  final DateTime date;
  final Category category;

  const Expense({
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
  });

  String get dateFormat {
    final String formattedDate = formatter.format(date);

    return formattedDate;
  }
}

class ExpenseBucket {
  ExpenseBucket({required this.expenses, required this.category});

  final Category category;
  final List<Expense> expenses;

  ExpenseBucket.forCategory(List<Expense> allExpense, this.category)
    : expenses = allExpense.where((expense) {
        return expense.category == category;
      }).toList();

  double get totalExpenseAmount {
    double sum = 0;
    for (final expense in expenses) {
      sum += expense.amount;
    }
    return sum;
  }
}
