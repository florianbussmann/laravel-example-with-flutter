import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application/models/category.dart';
import 'package:flutter_application/models/transaction.dart';
import 'package:flutter_application/providers/CategoryProvider.dart';
import 'package:flutter_application/widgets/CategoryWidgets.dart';
import 'package:flutter_application/widgets/DateSelector.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TransactionEdit extends StatefulWidget {
  final Transaction transaction;
  final Function transactionCallback;

  TransactionEdit(this.transaction, this.transactionCallback, {Key? key})
      : super(key: key);

  @override
  _TransactionEditState createState() => _TransactionEditState();
}

class _TransactionEditState extends State<TransactionEdit> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final transactionAmountController = TextEditingController();
  final transactionCategoryController = TextEditingController();
  final transactionDescriptionController = TextEditingController();
  final transactionDateController = TextEditingController();
  String errorMessage = '';

  @override
  void initState() {
    transactionAmountController.text = widget.transaction.amount.toString();
    transactionCategoryController.text =
        widget.transaction.categoryId.toString();
    transactionDescriptionController.text =
        widget.transaction.description.toString();
    transactionDateController.text =
        widget.transaction.transactionDate.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 50.0, left: 10.0, right: 10.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Wrap(
              runSpacing: 8.0,
              children: [
                TextFormField(
                  onChanged: (text) => setState(() => errorMessage = ''),
                  controller: transactionAmountController,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'^-?(\d+\.?\d{0,2})?'),
                    ),
                  ],
                  validator: (String? value) {
                    if (value!.trim().isEmpty) {
                      return 'Amount is required';
                    }
                    final newValue = double.tryParse(value);

                    if (newValue == null) {
                      return 'Invalid amount format';
                    }

                    return null;
                  },
                  keyboardType: TextInputType.numberWithOptions(
                      signed: true, decimal: true),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Amount',
                    icon: Icon(Icons.attach_money),
                    hintText: '0',
                  ),
                ),
                buildCategoriesDropdown(
                  this,
                  transactionCategoryController,
                ),
                TextFormField(
                  onChanged: (text) => setState(() => errorMessage = ''),
                  controller: transactionDescriptionController,
                  validator: (String? value) {
                    if (value!.trim().isEmpty) {
                      return 'Description is required';
                    }

                    return null;
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Description',
                  ),
                ),
                DateSelector(this, transactionDateController),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () => saveTransaction(),
                  child: Text('Save'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red,
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel'),
                ),
              ],
            ),
            Text(
              errorMessage,
              style: TextStyle(color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }

  Future saveTransaction() async {
    final form = _formKey.currentState;

    if (!form!.validate()) {
      return;
    }

    widget.transaction.amount = transactionAmountController.text;
    widget.transaction.categoryId =
        int.parse(transactionCategoryController.text);
    widget.transaction.description = transactionDescriptionController.text;
    widget.transaction.transactionDate = transactionDateController.text;

    widget
        .transactionCallback(widget.transaction)
        .then((transaction) => Navigator.pop(context))
        .catchError((exception) {
      setState(() {
        errorMessage = exception.toString();
      });
    });
  }
}
