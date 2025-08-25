import 'package:expense_tracker/screens/expense_tracker.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const ExpenseTracker(),
    ),
  );
}
