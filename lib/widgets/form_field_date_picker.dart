import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class FormFieldDatePicker extends FormField<DateTime> {
  FormFieldDatePicker({Key key, this.title}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _FormFieldDatePickerState();
}

class _FormFieldDatePickerState extends State<FormFieldDatePicker> {

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: TextFormField(
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
    );
  }

}