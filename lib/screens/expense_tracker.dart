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
  
List<ExpenseBucket> get buckets {
  return [
    ExpenseBucket.forCategory(_registeredExpense, Category.food),
    ExpenseBucket.forCategory(_registeredExpense, Category.work),
    ExpenseBucket.forCategory(_registeredExpense, Category.leisure),
    ExpenseBucket.forCategory(_registeredExpense, Category.travel),
  ];
}


  double get maxTotalExpense {
    double maxTotalExpenseAmount = 0;

    for (final bucket in buckets) {
      if (bucket.totalExpenseAmount > maxTotalExpenseAmount) {
        maxTotalExpenseAmount = bucket.totalExpenseAmount;
      }
    }

    return maxTotalExpenseAmount;
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
            // Chart container
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
              width: double.infinity,
              height: 200, // Fixed height for the chart
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(8),
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primary.withOpacity(0.3),
                    Theme.of(context).colorScheme.primary.withOpacity(0.0),
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
              child: Column(
                children: [
                  // Bars
                  Expanded(
                    child: Row(
                      crossAxisAlignment:
                          CrossAxisAlignment.end, 
                      children: [
                        for (final bucket
                            in buckets) 
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                              ), // Space between bars
                              child: FractionallySizedBox(
                                heightFactor: bucket.totalExpenseAmount == 0
                                    ? 0
                                    : bucket.totalExpenseAmount /
                                          maxTotalExpense, // Scale bar height 0-1
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary, // Bar color
                                    shape:
                                        BoxShape.rectangle, // Rectangular shape
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(
                                        8,
                                      ), // Rounded top corners only
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12), // Space between bars and icons
                  // Category icons under bars
                  Row(
                    children: buckets
                        .map(
                          (bucket) => Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                              ), // Space between icons
                              child: Column(
                                children: [
                                  Icon(categoryIcons[bucket.category]),
                                  Text('${bucket.totalExpenseAmount}'),
                                ],
                              ), // Category icon
                            ),
                          ),
                        )
                        .toList(),
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
