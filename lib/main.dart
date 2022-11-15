import 'dart:math';

import 'package:expense_calculator/classes/expense.dart';
import 'package:expense_calculator/pages/FormPage.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'classes/expense_list_model.dart';

void main() {
  final expenses = ExpenseListModel();
  runApp(
      ScopedModel<ExpenseListModel>(
        model: expenses, child: MyApp(),
      )
  );
}
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Expense calculator'),
    );
  }
}
class MyHomePage extends StatelessWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(this.title),
        ),
        body: ScopedModelDescendant<ExpenseListModel>(
          builder: (context, child, expenses) {
            return ListView.separated(
              itemCount: expenses.items == null ? 1 : expenses.items.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return ListTile(
                      title: Text("Total expenses: ${expenses.totalExpense}",
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold
                          )
                      )
                  );
                } else {
                  index = index - 1;
                  Expense expense = expenses.items[index];
                  return Dismissible(
                      key: Key(expense.id.toString()),
                      onDismissed: (direction) {
                        expenses.delete(expense);
                        Scaffold.of(context).showSnackBar(
                            SnackBar(content: Text(
                                "Item with id, ${expense.id} is dismissed"
                            ))
                        );
                      },
                      child: ListTile(
                          onTap: () async {
                            Expense updated = await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) {
                                  return FormPage(expense: expense);
                                })
                            );
                            print(expense);
                            print(updated);
                            if (updated != null) {
                              expenses.update(updated);
                            } else {

                            }
                          },
                          leading: Icon(Icons.monetization_on),
                          trailing: Icon(Icons.keyboard_arrow_right),
                          title: Text(
                              expense.textList,
                              style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic)
                          )
                      )
                  );
                }
              },
              separatorBuilder: (context, index) {
                return Divider();
              },
            );
          },
        ),
        floatingActionButton: ScopedModelDescendant<ExpenseListModel>(
            builder: (context, child, expenses) {
              return FloatingActionButton(
                onPressed: () async {
                  Expense expense = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return FormPage();
                      })
                  );
                  if (expense != null) {
                    expenses.add(expense);
                  }
                },
                tooltip: 'Increment', child: Icon(Icons.add),
              );
            }
        )
    );
  }
}

