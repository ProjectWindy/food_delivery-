import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_delivery/common/locator.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../common/globs.dart';
import '../common/extension.dart';

class AuthService {
  // Khởi tạo Firebase Authentication để quản lý xác thực người dùng
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Đối tượng dùng để đăng nhập bằng tài khoản Google
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Firestore để lưu trữ thông tin người dùng
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final NavigationService navigationService =
      locator<NavigationService>();

  /// Đăng nhập bằng email và mật khẩu
  /// Trả về một `Map` chứa kết quả `success` và thông tin người dùng (nếu thành công)
  Future<Map<String, dynamic>> loginWithEmailPassword(
      String email, String password) async {
    try {
      // Kiểm tra email có hợp lệ không (sử dụng extension)
      if (!email.isEmail) {
        return {'success': false, 'message': MSG.enterEmail};
      }

      // Kiểm tra mật khẩu có đủ độ dài không
      if (password.length < 6) {
        return {'success': false, 'message': MSG.enterPassword};
      }

      // Đăng nhập với email và mật khẩu
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Lấy thông tin người dùng từ Firestore
      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(userCredential.user?.uid) // Lấy UID của người dùng
          .get();

      return {'success': true, 'user': userDoc.data()};
    } on FirebaseAuthException catch (e) {
      // Xử lý các lỗi phổ biến khi đăng nhập
      String message = MSG.fail;
      if (e.code == 'user-not-found') {
        message = MSG.userNotFound;
      } else if (e.code == 'wrong-password') {
        message = MSG.wrongPassword;
      } else {
        message = e.message ?? MSG.fail;
      }
      return {'success': false, 'message': message};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  /// Đăng nhập bằng tài khoản Google
  Future<Map<String, dynamic>> loginWithGoogle() async {
    try {
      // Mở hộp thoại đăng nhập Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      // Nếu người dùng hủy đăng nhập
      if (googleUser == null) {
        return {'success': false, 'message': "Google sign-in aborted"};
      }

      // Lấy thông tin xác thực từ Google
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Tạo credential (chứng thực) để đăng nhập vào Firebase
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Đăng nhập vào Firebase bằng Google
      UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      // Kiểm tra xem user đã có trong Firestore chưa
      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(userCredential.user?.uid)
          .get();

      // Nếu user chưa tồn tại, lưu thông tin vào Firestore
      if (!userDoc.exists) {
        await _firestore.collection('users').doc(userCredential.user?.uid).set({
          'email': userCredential.user?.email,
          'name': userCredential.user?.displayName,
          'address': '',
          'role': 'users',
        });
      }

      return {'success': true, 'user': userDoc.data()};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  /// Đăng ký tài khoản mới
  /// Trả về `UserCredential` nếu thành công
  Future<UserCredential> signUp({
    required String email,
    required String password,
    required String name,
    required String mobile,
    required String address,
  }) async {
    try {
      // Tạo tài khoản Firebase bằng email và mật khẩu
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Lưu thông tin người dùng vào Firestore
      await _firestore.collection('users').doc(userCredential.user?.uid).set({
        'name': name,
        'mobile': mobile,
        'address': address,
        'role': 'users', // Mặc định role là 'users'
      });

      return userCredential;
    } catch (e) {
      rethrow; // Ném lại lỗi để UI có thể xử lý
    }
  }

  /// Lấy vai trò của người dùng từ Firestore
  Future<String> getUserRole() async {
    User? user = _auth.currentUser; // Lấy thông tin user hiện tại
    if (user != null) {
      // Lấy thông tin từ Firestore
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(user.uid).get();
      return userDoc['role'] ?? 'users'; // Trả về role hoặc mặc định 'users'
    }
    return 'users'; // Nếu không đăng nhập, mặc định là 'users'
  }

  /// Đăng xuất người dùng
  Future<void> logout() async {
    try {
      navigationService.navigateTo("welcome");

      await _auth.signOut(); // Đăng xuất Firebase
      await _googleSignIn.signOut(); // Nếu đăng nhập Google thì cũng đăng xuất
    } catch (e) {
      throw Exception('Logout failed: ${e.toString()}');
    }
  }
}
