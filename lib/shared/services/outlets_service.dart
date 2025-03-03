import 'package:cloud_firestore/cloud_firestore.dart';

class OutletsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, String>>> fetchOutlets() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('outlets').get();

      if (querySnapshot.docs.isEmpty) {
        print("❌ No outlets found in Firestore.");
        return [];
      }

      return querySnapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;

        return {
          'outletId': doc.id,
          'outletName': data['outletName']?.toString() ?? "Unnamed Outlet",
          'outletAddress': data['outletAddress']?.toString() ?? "No Address",
          'outletCode': data['outletCode']?.toString() ?? "No Code",
        };
      }).toList();
    } catch (e) {
      print("⚠️ Error fetching outlets: $e");
      return [];
    }
  }
}
