import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Cập nhật thông tin người dùng
  Future<void> updateUserInformation({
    required String userId,
    required String userName,
    required String firstName,
    required String lastName,
    required String address,
    required String nationality,
    Uint8List? idFrontPhoto,
    Uint8List? idRearPhoto,
    Uint8List? passportPhoto,
  }) async {
    try {
      DocumentReference userRef = _firestore.collection('users').doc(userId);

      Future<String?> uploadImage(Uint8List? imageBytes, String path) async {
        if (imageBytes == null) return null;
        Reference ref = _storage.ref().child(path);
        UploadTask uploadTask = ref.putData(imageBytes);
        TaskSnapshot snapshot = await uploadTask;
        return await snapshot.ref.getDownloadURL();
      }

      String? idFrontUrl =
          await uploadImage(idFrontPhoto, 'users/$userId/id_front.jpg');
      String? idRearUrl =
          await uploadImage(idRearPhoto, 'users/$userId/id_rear.jpg');
      String? passportUrl =
          await uploadImage(passportPhoto, 'users/$userId/passport.jpg');

      Map<String, dynamic> updatedData = {
        'userName': userName,
        'firstName': firstName,
        'lastName': lastName,
        'address': address,
        'nationality': nationality,
      };
      if (idFrontUrl != null) updatedData['idFrontPhoto'] = idFrontUrl;
      if (idRearUrl != null) updatedData['idRearPhoto'] = idRearUrl;
      if (passportUrl != null) updatedData['passportPhoto'] = passportUrl;

      await userRef.update(updatedData);
      print('User information updated successfully');
    } catch (e) {
      print('Error updating user information: $e');
    }
  }

  // Lấy thông tin người dùng từ Firestore
  Future<Map<String, dynamic>?> fetchUserData() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return null;

      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      return userDoc.exists ? userDoc.data() : null;
    } catch (e) {
      print('Error fetching user data: $e');
      return null;
    }
  }

  // Tải ảnh từ Firebase Storage
  Future<Uint8List?> downloadImage(String? imageUrl) async {
    if (imageUrl == null) return null;
    try {
      final ref = _storage.refFromURL(imageUrl);
      return await ref.getData();
    } catch (e) {
      print('Error loading image: $e');
      return null;
    }
  }
}
