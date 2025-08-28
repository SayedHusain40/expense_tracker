import 'package:expense_tracker/screens/expense_tracker.dart';
import 'package:flutter/material.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  // ]).then((Fn) {

  // });

  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ExpenseTracker(),
    ),
  );
}
