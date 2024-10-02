import 'package:flutter/foundation.dart';

class Transaction {
  final String id;
  final String description;
  final double amount;

  Transaction({required this.id, required this.description, required this.amount});
}

class FinancialProvider with ChangeNotifier {
  List<Transaction> _transactions = [];
  double _balance = 0;

  List<Transaction> get transactions => _transactions;
  double get balance => _balance;

  void addTransaction(Transaction transaction) {
    _transactions.add(transaction);
    _balance += transaction.amount;
    notifyListeners();
  }

  void deleteTransaction(String id) {
    final transaction = _transactions.firstWhere((t) => t.id == id);
    _transactions.removeWhere((t) => t.id == id);
    _balance -= transaction.amount;
    notifyListeners();
  }
}