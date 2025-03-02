import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CheckoutService {
  // Khởi tạo Firestore và FirebaseAuth
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Hàm lấy địa chỉ của người dùng hiện tại từ Firestore
  Future<String> fetchUserAddress() async {
    try {
      // Lấy thông tin người dùng hiện tại
      User? user = _auth.currentUser;
      if (user != null) {
        // Truy vấn Firestore để lấy document của người dùng theo UID
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(user.uid).get();

        if (userDoc.exists) {
          // Ép kiểu dữ liệu sang Map để truy cập các trường dữ liệu
          Map<String, dynamic>? userData =
              userDoc.data() as Map<String, dynamic>?;
          // Trả về địa chỉ nếu có, nếu không thì trả về thông báo mặc định
          return userData?['address'] ?? "No address found";
        }
      }
      return "No address found";
    } catch (e) {
      print("Error fetching address: $e");
      return "Error loading address"; // Trả về thông báo lỗi nếu có vấn đề xảy ra
    }
  }

  /// Hàm xử lý thanh toán và lưu thông tin vào Firestore
  Future<void> processPayment({
    required double totalAmount, // Tổng số tiền cần thanh toán
    required double subtotal, // Tổng tiền hàng trước phí giao hàng
    required double deliveryCost, // Phí giao hàng
    required List cartDetails, // Chi tiết giỏ hàng
  }) async {
    // Kiểm tra xem người dùng đã đăng nhập chưa
    User? user = _auth.currentUser;
    if (user == null) throw Exception("User not authenticated");

    String userId = user.uid; // Lấy UID của người dùng
    // Truy vấn thông tin người dùng từ Firestore
    DocumentSnapshot userDoc =
        await _firestore.collection('users').doc(userId).get();
    Map<String, dynamic>? userData = userDoc.data() as Map<String, dynamic>?;

    // Tạo thông tin thanh toán cần lưu trữ
    final paymentInfo = {
      "userId": userId, // Lưu ID người dùng
      "timestamp": FieldValue.serverTimestamp(), // Lưu thời gian giao dịch
      "totalAmount": totalAmount, // Lưu tổng số tiền thanh toán
      "subtotal": subtotal, // Lưu tổng tiền hàng
      "deliveryCost": deliveryCost, // Lưu phí giao hàng
      "cartDetails": cartDetails, // Lưu danh sách sản phẩm trong giỏ hàng
      "userName": userData?['name'], // Lưu tên người dùng
      "userAddress": userData?['address'], // Lưu địa chỉ người dùng
      "userMobile": userData?['mobile'], // Lưu số điện thoại người dùng
    };

    // Lưu thông tin thanh toán vào Firestore trong collection 'payments'
    await _firestore.collection('payments').add(paymentInfo);
  }
}
