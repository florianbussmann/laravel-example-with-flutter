import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateSelector extends StatelessWidget {
  final State caller;
  final TextEditingController dateController;
  String errorMessage = '';

  DateSelector(this.caller, this.dateController, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: (text) => caller.setState(() => errorMessage = ''),
      controller: dateController,
      validator: (String? value) {
        if (value!.trim().isEmpty) {
          return 'Date is required';
        }

        return null;
      },
      onTap: () {
        selectDate(context);
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Transaction date',
      ),
    );
  }

  Future selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(DateTime.now().year - 5),
        lastDate: DateTime(DateTime.now().year + 5));

    if (picked != null) {
      caller.setState(() {
        dateController.text = DateFormat('MM/dd/yyyy').format(picked);
      });
    }
  }
}
