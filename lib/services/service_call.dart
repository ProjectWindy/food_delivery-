import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/food.dart';

// CRUD Firebase
class FirestoreService {
  final CollectionReference productsCollection =
      FirebaseFirestore.instance.collection('menu_items');

  /// Thêm sản phẩm mới vào Firestore
  Future<void> addProduct(ProductModel product) async {
    try {
      await productsCollection.add(product.toMap());
      print('Sản phẩm đã được thêm thành công!');
    } catch (e) {
      print('Lỗi khi thêm sản phẩm: $e');
      throw e;
    }
  }

  /// Lấy danh sách sản phẩm dưới dạng Stream (lắng nghe thay đổi dữ liệu theo thời gian thực)
  Stream<List<ProductModel>> getProducts() {
    return productsCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return ProductModel.fromMap(data).copyWith(id: doc.id); // Thêm ID từ Firestore
      }).toList();
    });
  }

  /// Cập nhật thông tin sản phẩm
  Future<void> updateProduct(String documentId, ProductModel product) async {
    try {
      await productsCollection.doc(documentId).update(product.toMap());
      print('Sản phẩm đã được cập nhật thành công!');
    } catch (e) {
      print('Lỗi khi cập nhật sản phẩm: $e');
      throw e;
    }
  }

  /// Xóa sản phẩm
  Future<void> deleteProduct(String documentId) async {
    try {
      await productsCollection.doc(documentId).delete();
      print('Sản phẩm đã được xóa thành công!');
    } catch (e) {
      print('Lỗi khi xóa sản phẩm: $e');
      throw e;
    }
  }
}
