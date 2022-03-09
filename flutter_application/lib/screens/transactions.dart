import 'package:flutter/material.dart';
import 'package:flutter_application/models/transaction.dart';
import 'package:flutter_application/providers/TransactionProvider.dart';
import 'package:provider/provider.dart';

class Transactions extends StatefulWidget {
  const Transactions({Key? key}) : super(key: key);

  @override
  _TransactionsState createState() => _TransactionsState();
}

class _TransactionsState extends State<Transactions> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TransactionProvider>(context);
    List<Transaction> transactions = provider.transactions;

    return MaterialApp(
      title: 'Welcome to Flutter',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Transactions'),
        ),
        body: ListView.builder(
          itemCount: transactions.length,
          itemBuilder: (context, index) {
            Transaction transaction = transactions[index];
            return ListTile(
              title: Text('\$' + transaction.amount),
              subtitle: Text(transaction.categoryName),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(transaction.transactionDate),
                      Text(transaction.description),
                    ],
                  ),
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: null,
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Confirmation'),
                          content: Text('Are you sure you want to delete?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                provider
                                    .deleteTransaction(transaction)
                                    .then((category) => Navigator.pop(context))
                                    .catchError((exception) {
                                  print(exception);
                                });
                              },
                              child: Text('Confirm'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Cancel'),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
