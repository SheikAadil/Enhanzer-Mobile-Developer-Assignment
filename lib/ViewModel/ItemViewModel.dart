import 'package:flutter/material.dart';
import 'package:mobile_developer_assignment/Services/DatabaseHelper.dart';
import 'package:mobile_developer_assignment/Model/Item.dart';

class ItemViewModel with ChangeNotifier {
  List<Item> _items = [];
  List<Item> get items => _items;

  Future<void> fetchItems() async {
    final data = await DatabaseHelper.instance.getItems();
    _items = data.map((item) => Item.fromMap(item)).toList();
    notifyListeners();
  }
}
