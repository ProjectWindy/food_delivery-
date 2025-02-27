import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomeProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Map<String, dynamic>> popularRestaurants = [];
  List<Map<String, dynamic>> mostPopular = [];
  List<Map<String, dynamic>> recentItems = [];
  List<Map<String, dynamic>> searchResults = [];  

  bool isLoading = true;
  bool isSearching = false;  

  HomeProvider() {
    fetchData();
  }

  Future<void> fetchData() async {
    try {
       var popSnapshot = await _firestore.collection('popular_items').get();
      popularRestaurants = popSnapshot.docs.map((doc) => doc.data()).toList();

       var mostPopSnapshot =
          await _firestore.collection('most_popular_items').get();
      mostPopular = mostPopSnapshot.docs.map((doc) => doc.data()).toList();

       var recentSnapshot = await _firestore.collection('recent_items').get();
      recentItems = recentSnapshot.docs.map((doc) => doc.data()).toList();

      isLoading = false;
      notifyListeners();
    } catch (e) {
      print("Lỗi khi fetch dữ liệu: $e");
    }
  }

  Future<void> searchProducts(String query) async {
    if (query.isEmpty) {
      searchResults = [];
      notifyListeners();
      return;
    }

    try {
      isSearching = true;
      notifyListeners();

       
      query = query.toLowerCase();

       List<Future<QuerySnapshot>> futures = [
        _firestore
            .collection('products')
            .where('name', isGreaterThanOrEqualTo: query)
            .where('name', isLessThanOrEqualTo: query + '\uf8ff')
            .get(),
        _firestore
            .collection('products')
            .where('description', isGreaterThanOrEqualTo: query)
            .where('description', isLessThanOrEqualTo: query + '\uf8ff')
            .get(),
      ];

      final results = await Future.wait(futures);

       Set<String> addedIds = {};
      searchResults = [];

      for (var snapshot in results) {
        for (var doc in snapshot.docs) {
          var data = doc.data() as Map<String, dynamic>;
          if (!addedIds.contains(doc.id)) {
            data['id'] = doc.id;  
            searchResults.add(data);
            addedIds.add(doc.id);
          }
        }
      }

      isSearching = false;
      notifyListeners();
    } catch (e) {
      print("Lỗi khi tìm kiếm sản phẩm: $e");
      isSearching = false;
      notifyListeners();
    }
  }

  void clearSearch() {
    searchResults = [];
    notifyListeners();
  }
}
