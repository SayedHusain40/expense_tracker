import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/chart/bar_chart.dart';
import 'package:flutter/material.dart';

class Chart extends StatelessWidget {
  const Chart(this._registeredExpenses, {super.key});

  final List<Expense> _registeredExpenses;

  List<BucketExpenses> get buckets {
    return [
      BucketExpenses.forCategory(_registeredExpenses, Category.food),
      BucketExpenses.forCategory(_registeredExpenses, Category.work),
      BucketExpenses.forCategory(_registeredExpenses, Category.leisure),
      BucketExpenses.forCategory(_registeredExpenses, Category.travel),
    ];
  }

  double get maxCategoryExpense {
    double maxAmount = 0;

    for (final bucket in buckets) {
      if (bucket.totalExpensesAmount > maxAmount) {
        maxAmount = bucket.totalExpensesAmount;
      }
    }

    return maxAmount;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(8),
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
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (final bucket in buckets)
                  BarChart(
                    fill: bucket.totalExpensesAmount == 0
                        ? 0
                        : bucket.totalExpensesAmount /
                              maxCategoryExpense,
                  ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          // Icons
          Row(
            children: buckets.map((bucket) {
              return Expanded(
                child: Column(
                  children: [
                    Icon(categoryIcons[bucket.category]),
                    Text('${bucket.totalExpensesAmount}'),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
