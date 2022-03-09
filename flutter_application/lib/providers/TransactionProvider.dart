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

  Future<void> deleteTransaction(Transaction transaction) async {
    await apiService.deleteTransaction(transaction.id);
    transactions.remove(transaction);

    notifyListeners();
  }
}
