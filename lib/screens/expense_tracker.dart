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
  List<BucketExpenses> get buckets {
    return [
      BucketExpenses.forCategory(_registeredExpense, Category.food),
      BucketExpenses.forCategory(_registeredExpense, Category.work),
      BucketExpenses.forCategory(_registeredExpense, Category.leisure),
      BucketExpenses.forCategory(_registeredExpense, Category.travel),
    ];
  }

  Color _getBarColor(Category category) {
    switch (category) {
      case Category.food:
        return Colors.orange.shade400;
      case Category.travel:
        return Colors.blue.shade400;
      case Category.leisure:
        return Colors.green.shade400;
      case Category.work:
        return Colors.red.shade400;
      default:
        return Colors.purple.shade400;
    }
  }

  double get maxExpensesAmountForCategories {
    double maxAmount = 0;

    for (final bucket in buckets) {
      if (bucket.totalExpensesAmountForCategory > maxAmount) {
        maxAmount = bucket.totalExpensesAmountForCategory;
      }
    }

    return maxAmount;
  }

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
    Expense(
      title: 'Cimea',
      amount: 100,
      date: DateTime.now(),
      category: Category.leisure,
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
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.all(8),
              height: 200,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.purple.shade50,
                    Colors.purple.shade100,
                    Colors.purple.shade200,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(10),
              ),

              child: Column(
                children: [
                  Expanded(
                    child: Row(
                      // 400
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        for (final bucket in buckets)
                          Expanded(
                            // 400 / 4 = 100 width for each bar
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                              ),
                              child: FractionallySizedBox(
                                heightFactor:
                                    bucket.totalExpensesAmountForCategory /
                                    maxExpensesAmountForCategories,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: _getBarColor(bucket.category),
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  // Icons
                  Row(
                    children: buckets.map((bucket) {
                      return Expanded(
                        child: Column(
                          children: [
                            Icon(categoryIcons[bucket.category]),
                            Text('${bucket.totalExpensesAmountForCategory}'),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

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
