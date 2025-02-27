import 'package:cloud_firestore/cloud_firestore.dart';
import 'models/food.dart';

class FirestoreService {
  final CollectionReference productsCollection =
      FirebaseFirestore.instance.collection('menu_items');

  // ADd
  Future<void> addProduct(ProductModel product) async {
    await productsCollection.add(product.toMap());
  }

  // Get
 Stream<List<ProductModel>> getProducts() {
  return productsCollection.snapshots().map((snapshot) {
    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return ProductModel.fromMap(data).copyWith(id: doc.id); // 
    }).toList();
  });
}


  // Update a product
  Future<void> updateProduct(String documentId, ProductModel product) async {
    print('Bạn có chắc chắn muốn cập nhật sản phẩm với ID: $documentId?');
    try {
      await FirebaseFirestore.instance
          .collection('menu_items')
          .doc(documentId)
          .update(product.toMap());
    } catch (e) {
      print('Error updating product: $e');
      throw e;
    }
  }

  Future<void> deleteProduct(String documentId) async {
    try {
      await FirebaseFirestore.instance
          .collection('menu_items')
          .doc(documentId)
          .delete();
    } catch (e) {
      print('Error deleting product: $e');
      throw e;
    }
  }
}
