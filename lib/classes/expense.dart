import 'package:intl/intl.dart';

class Expense {
  int id;
  double amount;
  DateTime date;
  String category;
  static final columns = ['id', 'amount', 'date', 'category'];

  Expense(this.id, this.amount, this.date, this.category);

  Expense.empty() {
    this.id = 0;
    this.amount = 0;
    this.date = new DateTime.now();
    this.category = '';
  }

  String toString() {
    return this.toMap().toString();
  }

  String get formattedDate {
    return new DateFormat('dd/MM/yyyy').format(this.date);
  }

  String get textList {
    return "${this.category} : ${this.amount} \nspent on ${this.formattedDate}";
  }

  factory Expense.fromMap(Map<String, dynamic> data) {
    return Expense(
        data['id'],
        data['amount'],
        DateTime.parse(data['date']),
        data['category']
    );
  }

  Map<String, dynamic> toMap() => {
    "id": id,
    "amount": amount,
    "date": date.toString(),
    "category": category,
  };
}