import 'package:expense_calculator/classes/expense.dart';
import 'package:expense_calculator/classes/expense_list_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FormPage extends StatefulWidget {
  FormPage({Key key, this.expense}) : super(key: key);
  final Expense expense;

  @override
  _FormPageState createState() {
    return _FormPageState(expense: expense);
  }
}

class _FormPageState extends State<FormPage> {
  _FormPageState({Key key, Expense expense}) {
    if (this.expense == null) {
      this.expense = new Expense.empty();
    }
  }

  Expense expense;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

  void _submit() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      Navigator.pop(context, this.expense);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Enter expense details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                style: TextStyle(fontSize: 22),
                decoration: const InputDecoration(
                    icon: const Icon(Icons.monetization_on),
                    labelText: 'Amount',
                    labelStyle: TextStyle(fontSize: 18)
                ),
                validator: (val) {
                  Pattern pattern = r'^[1-9]\d*(\.\d+)?$';
                  RegExp regex = new RegExp(pattern);
                  if (!regex.hasMatch(val)) return 'Enter a valid number';
                  else return null;
                },
                keyboardType: TextInputType.number,
                initialValue: this.expense.amount.toString(),
                onSaved: (val) => this.expense.amount = double.parse(val),
                textInputAction: TextInputAction.next,
              ),
              Row(
                children: [
                  Expanded(
                      child: InputDatePickerFormField(
                        fieldLabelText: 'Date',
                        firstDate: new DateTime(1950),
                        lastDate: new DateTime.now(),
                        initialDate: this.expense.date,
                        onDateSaved: (val) => this.expense.date = val,
                      )
                  ),
                  Expanded(
                      child: GestureDetector(
                        child: Icon(Icons.calendar_today),
                        onTap: () async {
                          DateTime selectedDate = DateTime.now();
                          final DateTime picked = await showDatePicker(
                              context: context,
                              initialDate: selectedDate,
                              firstDate: DateTime(2015, 8),
                              lastDate: DateTime(2101)
                          );
                          if (picked != null && picked != selectedDate)
                            setState(() {
                              selectedDate = picked;
                            });
                        },
                      )
                  )
                ],
              ),
              TextFormField(
                  style: TextStyle(fontSize: 22),
                  decoration: const InputDecoration(
                      icon: const Icon(Icons.category),
                      labelText: 'Category',
                      labelStyle: TextStyle(fontSize: 18)
                  ),
                  onSaved: (val) => this.expense.category = val,
                  initialValue: this.expense.category.toString(),
                  textInputAction: TextInputAction.done,
                  onEditingComplete: _submit
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _submit,
        child: Icon(Icons.check),
        backgroundColor: Colors.green,
      ),
    );
  }
}