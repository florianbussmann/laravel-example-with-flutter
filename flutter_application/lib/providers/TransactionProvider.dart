import 'package:flutter/material.dart';
import 'package:flutter_application/models/transaction.dart';
import 'package:flutter_application/providers/AuthProvider.dart';
import 'package:flutter_application/services/api.dart';

class TransactionProvider extends ChangeNotifier {
  List<Transaction> transactions = [];
  late AuthProvider _authProvider;
  late ApiService apiService;

  TransactionProvider(AuthProvider authProvider) {
    _authProvider = authProvider;
    apiService = ApiService(_authProvider.token);

    init();
  }

  Future init() async {
    transactions = await apiService.fetchTransactions();
    notifyListeners();
  }

  Future addTransaction(String amount, String category, String description,
      String transactionDate) async {
    Transaction addedTransaction = await apiService.addTransaction(
        amount, category, description, transactionDate);
    transactions.add(addedTransaction);

    notifyListeners();
  }

  Future updateTransaction(Transaction transaction) async {
    Transaction updatedTransaction =
        await apiService.updateTransaction(transaction);
    int index = transactions.indexOf(transaction);
    transactions[index] = updatedTransaction;

    notifyListeners();
  }

  Future<void> deleteTransaction(Transaction transaction) async {
    await apiService.deleteTransaction(transaction.id);
    transactions.remove(transaction);

    notifyListeners();
  }
}
