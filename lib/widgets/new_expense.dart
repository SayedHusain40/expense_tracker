import 'dart:io';
import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.onAddExpense});

  final Function(Expense expense) onAddExpense;

  @override
  State<NewExpense> createState() => _NewExpenseState();
}

class _NewExpenseState extends State<NewExpense> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  DateTime? _date;
  Category _category = Category.food;

  void showDateTime() async {
    final DateTime dateNow = DateTime.now();

    final selectedDate = await showDatePicker(
      context: context,
      initialDate: dateNow,
      firstDate: DateTime(dateNow.year - 1, dateNow.month, dateNow.day),
      lastDate: dateNow,
    );

    setState(() {
      _date = selectedDate;
    });
  }

  void _showDialog() {
    if (Platform.isIOS) {
      showCupertinoDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: const Text('Invalid Data'),
            content: const Text(
              'Please make sure you was entered title, amount, date correctly!',
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                },
                child: const Text('Okay'),
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: const Text('Invalid Data'),
            content: const Text(
              'Please make sure you was entered title, amount, date correctly!',
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                },
                child: const Text('Okay'),
              ),
            ],
          );
        },
      );
    }
  }

  void _submitExpense() {
    // check Validity

    final enteredAmount = double.tryParse(_amountController.text);

    if (_titleController.text.trim().isEmpty ||
        enteredAmount == null ||
        enteredAmount < 1 ||
        _date == null) {
      _showDialog();

      return;
    }

    widget.onAddExpense(
      Expense(
        title: _titleController.text,
        amount: enteredAmount,
        date: _date!,
        category: _category,
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final keyboard = MediaQuery.of(context).viewInsets.bottom;

    return LayoutBuilder(
      builder: (ctx, constraints) {
        final width = constraints.maxWidth;

        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, keyboard + 16),
            child: Column(
              children: [
                if (width >= 600)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _titleController,
                          maxLength: 50,
                          decoration: const InputDecoration(
                            label: Text('Title'),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _amountController,
                          decoration: const InputDecoration(
                            label: Text('Amount'),
                          ),
                        ),
                      ),
                    ],
                  )
                else
                  TextField(
                    controller: _titleController,
                    maxLength: 50,
                    decoration: const InputDecoration(label: Text('Title')),
                  ),
                if (width >= 600)
                  Row(
                    children: [
                      DropdownButton(
                        value: _category,
                        items: Category.values.map((category) {
                          return DropdownMenuItem(
                            value: category,
                            child: Text(category.name.toUpperCase()),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value == null) {
                            return;
                          }
                          setState(() {
                            _category = value;
                          });
                        },
                      ),

                      const Spacer(),

                      Text(
                        _date == null
                            ? 'No Date Selected'
                            : formatter.format(_date!).toString(),
                      ),
                      const SizedBox(width: 5),
                      IconButton(
                        onPressed: showDateTime,
                        icon: const Icon(Icons.calendar_month),
                      ),
                    ],
                  )
                else
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _amountController,
                          decoration: const InputDecoration(
                            label: Text('Amount'),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),

                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              _date == null
                                  ? 'No Date Selected'
                                  : formatter.format(_date!).toString(),
                            ),
                            const SizedBox(width: 5),
                            IconButton(
                              onPressed: showDateTime,
                              icon: const Icon(Icons.calendar_month),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 16),
                if (width >= 600)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Cancel'),
                      ),
                      const SizedBox(width: 5),
                      ElevatedButton(
                        onPressed: _submitExpense,
                        child: const Text('Save'),
                      ),
                    ],
                  )
                else
                  Row(
                    children: [
                      DropdownButton(
                        value: _category,
                        items: Category.values.map((category) {
                          return DropdownMenuItem(
                            value: category,
                            child: Text(category.name.toUpperCase()),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value == null) {
                            return;
                          }
                          setState(() {
                            _category = value;
                          });
                        },
                      ),

                      const Spacer(),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Cancel'),
                      ),
                      const SizedBox(width: 5),
                      ElevatedButton(
                        onPressed: _submitExpense,
                        child: const Text('Save'),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
