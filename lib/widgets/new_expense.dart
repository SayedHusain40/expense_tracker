import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/material.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.onSaveExpense});

  final Function(Expense expense) onSaveExpense;

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

  void _submitExpense() {
    // check Validity

    final enteredAmount = double.tryParse(_amountController.text);

    if (_titleController.text.trim().isEmpty ||
        enteredAmount == null ||
        _date == null) {
      showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: Text('Invalid Data'),
            content: Text(
              'Please make sure you was entered title, amount, date correctly!',
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                },
                child: Text('Okay'),
              ),
            ],
          );
        },
      );

      return;
    }

    widget.onSaveExpense(
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
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _titleController,
            maxLength: 50,
            decoration: InputDecoration(label: Text('Title')),
          ),

          SizedBox(height: 10),

          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _amountController,
                  decoration: InputDecoration(label: Text('Amount')),
                ),
              ),

              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      _date == null
                          ? 'No Date Selected'
                          : formatter.format(_date!).toString(),
                    ),
                    SizedBox(width: 5),
                    IconButton(
                      onPressed: showDateTime,
                      icon: Icon(Icons.calendar_month),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 20),
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
                  if (value != null) {
                    setState(() {
                      _category = value;
                    });
                  }
                },
              ),
              Spacer(),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Cancel'),
                  ),
                  SizedBox(width: 5),
                  ElevatedButton(
                    onPressed: _submitExpense,
                    child: Text('Save'),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
