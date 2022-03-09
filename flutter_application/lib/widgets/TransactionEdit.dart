import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application/models/category.dart';
import 'package:flutter_application/models/transaction.dart';
import 'package:flutter_application/providers/CategoryProvider.dart';
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
              keyboardType:
                  TextInputType.numberWithOptions(signed: true, decimal: true),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Amount',
                icon: Icon(Icons.attach_money),
                hintText: '0',
              ),
            ),
            buildCategoriesDropdown(),
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
            TextFormField(
              onChanged: (text) => setState(() => errorMessage = ''),
              controller: transactionDateController,
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

  Future selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(DateTime.now().year - 5),
        lastDate: DateTime(DateTime.now().year + 5));

    if (picked != null) {
      setState(() {
        transactionDateController.text =
            DateFormat('MM/dd/yyyy').format(picked);
      });
    }
  }

  Widget buildCategoriesDropdown() {
    return Consumer<CategoryProvider>(
      builder: (context, categoryProvider, child) {
        List<Category> categories = categoryProvider.categories;

        return DropdownButtonFormField(
          items: categories.map<DropdownMenuItem<String>>((element) {
            return DropdownMenuItem(
              value: element.id.toString(),
              child: Text(
                element.name,
                style: TextStyle(color: Colors.black, fontSize: 20.0),
              ),
            );
          }).toList(),
          value: transactionCategoryController.text,
          onChanged: (String? newValue) {
            if (newValue == null) {
              return;
            }

            setState(() {
              transactionCategoryController.text = newValue.toString();
            });
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Category',
          ),
          dropdownColor: Colors.white,
          validator: (value) {
            if (value == null) {
              return 'Please select category';
            }
          },
        );
      },
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
