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

  Future<List<Map<String, String>>> fetchCurrencyCodes() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('currencyCodes')
          .get();

      if (querySnapshot.docs.isEmpty) {
        return [];
      }

      List<Map<String, String>> currencyList = querySnapshot.docs.map((doc) {
        return {
          'currencyCode': doc['currencyCode'].toString(),
          'description': doc['description'].toString()
        };
      }).toList();

      return currencyList;
    } catch (e) {
      print("⚠️ Error fetching currency codes: $e");
      return []; // Return empty list on error
    }
  }
  Future<Map<String, dynamic>?> fetchOutletRates({
    required String outletId,
    required String fromCurrency,
    required String toCurrency,
  }) async {
    try {
      // Validate inputs
      if (outletId.isEmpty || fromCurrency.isEmpty || toCurrency.isEmpty) {
        print("⚠️ Missing required parameters for fetching outlet rates.");
        return null;
      }

      // Query Firestore with conditions
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('outletRates')
          .where('outletId', isEqualTo: outletId)
          .where('localCurrency', isEqualTo: fromCurrency)
          .where('foreignCurrency', isEqualTo: toCurrency)
          .get();

      if (querySnapshot.docs.isEmpty) {
        print("❌ No outlet rates found for $fromCurrency ➡️ $toCurrency");
        return null; // Return null if no data found
      }

      // Get the first document's data
      var data = querySnapshot.docs.first.data() as Map<String, dynamic>;

      // Return structured data
      return {
        'sendRate': double.tryParse(data['sendRate'].toString()) ?? 0.0,
        'buyRate': double.tryParse(data['buyRate'].toString()) ?? 0.0,
        'sellRate': double.tryParse(data['sellRate'].toString()) ?? 0.0,
        'localCurrency': data['localCurrency'] ?? '',
        'foreignCurrency': data['foreignCurrency'] ?? '',
      };
    } catch (e) {
      print("⚠️ Error fetching outlet rates: $e");
      return null; // Return null on error
    }
  }
}
