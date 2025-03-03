import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/models/food.dart';

class SearchHomeProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<FoodItem> popularRestaurants = [];
  List<FoodItem> mostPopular = [];
  List<FoodItem> recentItems = [];
  List<FoodItem> allFoodItems = [];
  bool isLoading = true;
  bool isSearching = false;

  HomeProvider() {
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      isLoading = true;
      notifyListeners();

      var popSnapshot = await _firestore.collection('popular_items').get();
      popularRestaurants = popSnapshot.docs
          .map((doc) => FoodItem.fromMap(doc.data(), id: doc.id))
          .toList();

      var mostPopSnapshot =
          await _firestore.collection('most_popular_items').get();
      mostPopular = mostPopSnapshot.docs
          .map((doc) => FoodItem.fromMap(doc.data(), id: doc.id))
          .toList();

      var recentSnapshot = await _firestore.collection('recent_items').get();
      recentItems = recentSnapshot.docs
          .map((doc) => FoodItem.fromMap(doc.data(), id: doc.id))
          .toList();

      allFoodItems = [
        ...popularRestaurants,
        ...mostPopular,
        ...recentItems,
      ].toSet().toList();

      isLoading = false;
      notifyListeners();
    } catch (e) {
      print("Lỗi khi fetch dữ liệu: $e");
      isLoading = false;
      notifyListeners();
    }
  }
}
