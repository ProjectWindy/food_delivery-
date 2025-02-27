import 'package:flutter/material.dart';

class Cart with ChangeNotifier {
  List<Map<String, dynamic>> _items = [];

  List<Map<String, dynamic>> get items => _items;

  void addItem(Map<String, dynamic> item) {
    _items.add(item);
    notifyListeners();
  }

  double getTotal() {
    double total = 0.0;
    for (var item in _items) {
      double price = item['price'] != null
          ? double.tryParse(item['price'].toString()) ?? 0.0
          : 0.0;
      int qty = item['qty'] != null ? item['qty'] as int : 1;
      total += price * qty;
    }
    return total;
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }

  Future<void> checkout() async {
    clear();
  }
}
