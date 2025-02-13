import 'package:circle_flags/circle_flags.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/routes.dart';
import 'package:flutter_application_1/features/home_page/screens/send_money/progressbar.dart';

class SendMoneyForm extends StatefulWidget {
  const SendMoneyForm({super.key});

  @override
  State<SendMoneyForm> createState() => _SendMoneyFormState();
}

class _SendMoneyFormState extends State<SendMoneyForm> {
  String fromCurrency = "";
  String toCurrency = "";
  String exchangeRate = "1.37310";

  String? selectedOutlet;
  double? sendRate;
  String? localCurrency;
  String? foreignCurrency;
  String? selectedCurrency;

  List<DropdownMenuItem<String>> _outletItems = [];
  List<DropdownMenuItem<String>> _currencyItems = [];
  List<String> currencyCodes = [];
  List<Map<String, String>> _currencyDisplayList = [];

  final TextEditingController _numericController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  String? _numericError;
  @override
  void initState() {
    super.initState();
    _loadOutlets();
    fetchCurrencyCodes();
  }

  void _loadOutlets() async {
    // Fetch dữ liệu outlets
    List<Map<String, dynamic>> outlets = await fetchOutlets();
    print("📋 Available Outlets in Dropdown: $outlets");

    // Fetch dữ liệu currencyCodes
    await fetchCurrencyCodes();
    print("💱 Available Currency Codes: $currencyCodes");

    setState(() {
      // Tạo Dropdown items cho Outlets
      _outletItems = outlets.map<DropdownMenuItem<String>>((outlet) {
        return DropdownMenuItem<String>(
          value: outlet['outletId'],
          child: Text(outlet['outletName']),
        );
      }).toList();

      if (_outletItems.isNotEmpty &&
          (selectedOutlet == null || selectedOutlet!.isEmpty)) {
        selectedOutlet = _outletItems.first.value;
        print("🔹 Default selected outlet ID: $selectedOutlet");

        // Fetch dữ liệu Outlet đã chọn
        _fetchOutletData(selectedOutlet!);
      }

      // Đặt giá trị mặc định cho Currency nếu chưa chọn
      if (_currencyItems.isNotEmpty &&
          (selectedCurrency == null || selectedCurrency!.isEmpty)) {
        selectedCurrency = _currencyItems.first.value;
        print("🔹 Default selected currency: $selectedCurrency");
      }
    });
  }

  Future<void> _fetchOutletData(String outletId) async {
    try {
      DocumentSnapshot outletDoc = await FirebaseFirestore.instance
          .collection('outlets')
          .doc(outletId) // 🔹 Dùng document ID, không phải 'outletId' trong doc
          .get();

      if (outletDoc.exists) {
        final outletData = outletDoc.data() as Map<String, dynamic>;

        print("✅ Fetched outlet: ${outletData['outletName']}");

        setState(() {
          selectedOutlet = outletId; // 🔹 Gán ID thay vì tên để tránh lỗi
        });
      } else {
        print("❌ Outlet not found for ID: $outletId");
      }
    } catch (e) {
      debugPrint("⚠️ Error fetching outlet data: $e");
    }
  }

  Future<List<Map<String, dynamic>>> fetchOutlets() async {
    try {
      print("📡 Fetching outlets from Firestore...");

      QuerySnapshot outletSnapshot =
          await FirebaseFirestore.instance.collection('outlets').get();

      if (outletSnapshot.docs.isEmpty) {
        print("❌ No outlets found in Firestore.");
      }

      List<Map<String, dynamic>> outlets = outletSnapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>?;

        // 🔹 Dùng document ID thay vì 'outletId' bên trong document
        print("✅ Fetched outlet: ${doc.id} - ${data?['outletName']}");

        return {
          'outletId': doc.id, // 🔹 Dùng document ID
          'outletName': data?['outletName'] ?? "Unnamed Outlet",
        };
      }).toList();

      return outlets;
    } catch (e, stackTrace) {
      debugPrint("⚠️ Error fetching outlets: $e\nStackTrace: $stackTrace");
      return [];
    }
  }

  Future<void> fetchCurrencyCodes() async {
    try {
      print("📡 Fetching currency codes...");

      // Truy vấn tất cả dữ liệu từ collection currencyCodes
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('currencyCodes').get();

      if (querySnapshot.docs.isEmpty) {
        print("❌ No currency codes found.");
        return;
      }

      // Chuyển đổi dữ liệu thành List<Map<String, String>> với toString()
      List<Map<String, String>> currencyList = querySnapshot.docs.map((doc) {
        return {
          'currencyCode': doc['currencyCode'].toString(),
          'country': doc['country'].toString()
        };
      }).toList();

      print("✅ Fetched ${currencyList.length} currency codes.");
      print("🔎 Data: $currencyList");

      // Cập nhật DropdownMenuItem cho _currencyItems
      setState(() {
        _currencyDisplayList = currencyList;
        _currencyItems = currencyList.map((item) {
          String displayText =
              "${item['currencyCode']} - ${item['country']}"; // Hiển thị khi mở Dropdown
          return DropdownMenuItem<String>(
            value: item['currencyCode'],
            child: Text(displayText),
          );
        }).toList();
      });
      if (_currencyItems.isNotEmpty &&
          (fromCurrency == null || fromCurrency.isEmpty)) {
        fromCurrency = _currencyItems.first.value!;
        print("🔄 Default fromCurrency: $fromCurrency");
      }
      fetchOutletRates(fromCurrency);
    } catch (e) {
      print("⚠️ Error fetching currency codes: $e");
    }
  }

  Future<void> fetchOutletRates(String outletId) async {
    try {
      print("📡 Fetching outlet rates for outletId: $outletId...");

      // Truy vấn outletRate có outletId khớp
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('outletRate')
          .where('outletId', isEqualTo: outletId)
          .get();

      if (querySnapshot.docs.isEmpty) {
        print("❌ No outlet rates found for outletId: $outletId");
        return;
      }

      // Duyệt qua từng document và in dữ liệu ra console
      // Lấy `sendRate` từ document đầu tiên (hoặc tuỳ chỉnh nếu có nhiều document)
      var data = querySnapshot.docs.first.data() as Map<String, dynamic>;

      setState(() {
        setState(() {
          sendRate = double.parse(data['sendRate'].toString());
          localCurrency = data['localCurrency'];
          foreignCurrency = data['foreignCurrency'];
        });
      });

      print("✅ Fetched sendRate: $sendRate");
      print("✅ Fetched sendRate: $localCurrency");
      print("✅ Fetched sendRate: $foreignCurrency");
    } catch (e) {
      print("⚠️ Error fetching outlet rates: $e");
    }
  }

  void _validateNumeric() {
    final input = _numericController.text;
    if (input.isNotEmpty && !RegExp(r'^[0-9]+$').hasMatch(input)) {
      setState(() {
        _numericError = "Only numbers are allowed!";
      });
    } else {
      setState(() {
        _numericError = null;
      });
    }
  }

  void _showOutletPicker(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 250,
        color: Colors.white,
        child: Column(
          children: [
            Container(
              height: 200,
              child: CupertinoPicker(
                itemExtent: 40,
                onSelectedItemChanged: (index) {
                  setState(() {
                    selectedOutlet = _outletItems[index].value!;
                  });

                  // 🔹 Gọi hàm fetchOutletRates khi chọn Outlet
                  fetchOutletRates(selectedOutlet!);
                },
                children: _outletItems.map((item) {
                  if (item.child is Text) {
                    return Text((item.child as Text).data ?? "No Name");
                  } else {
                    return Text("Invalid Item");
                  }
                }).toList(),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(tr('cancel'), style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }

  void _showCurrencyPicker(BuildContext context, bool isSender) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 250,
        color: Colors.white,
        child: Column(
          children: [
            Container(
              height: 200,
              child: CupertinoPicker(
                itemExtent: 40,
                onSelectedItemChanged: (index) {
                  setState(() {
                    // Chỉ lưu currencyCode sau khi chọn
                    if (isSender) {
                      fromCurrency =
                          _currencyDisplayList[index]['currencyCode']!;
                    } else {
                      toCurrency = _currencyDisplayList[index]['currencyCode']!;
                    }
                  });
                  print(
                      "🔄 Selected Currency: ${isSender ? fromCurrency : toCurrency}");
                },
                children: _currencyDisplayList.map((item) {
                  // Hiển thị cả currencyCode và country trong Picker
                  return Text("${item['currencyCode']} - ${item['country']}");
                }).toList(),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(tr('cancel'), style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    final bool isSmallScreen = screenWidth < 600;
    final double padding = isSmallScreen ? 12.0 : 24.0;
    final double fontSize = isSmallScreen ? 14.0 : 18.0;

    return Padding(
      padding: EdgeInsets.all(padding),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProgressStepper(
              steps: [
                tr('amount'),
                tr('sender'),
                tr('recipient'),
                tr('review'),
                tr('success'),
              ],
              stepIcons: [
                Icons.attach_money,
                Icons.person,
                Icons.people,
                Icons.checklist,
                Icons.verified
              ],
              currentStep: 0,
              backgroundColor: Colors.grey[300]!,
              progressColor: Colors.blue,
              height: 8,
            ),
            // Input Field: You Send
            SizedBox(height: isSmallScreen ? 16 : 24),
            _buildCurrencyInputField(
              tr('you_send'),
              fromCurrency,
              (value) {
                setState(() {
                  fromCurrency = value!;
                  print("🔄 Updated fromCurrency: $fromCurrency");
                });
              },
              isSmallScreen,
              _numericController,
              isSender: true, // 🔹 Người gửi
            ),

            _buildCurrencyInputField(
              tr('recipient_gets'),
              toCurrency,
              (value) {
                setState(() {
                  toCurrency = value!;
                  print("🔄 Updated toCurrency: $toCurrency");
                });
              },
              isSmallScreen,
              _numericController,
              isSender: false, // 🔹 Người nhận
            ),

            SizedBox(height: isSmallScreen ? 16 : 24),

            Text("Select Outlet"),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => _showOutletPicker(context),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      selectedOutlet != null
                          ? (_outletItems
                                      .firstWhere((item) =>
                                          item.value == selectedOutlet)
                                      .child as Text)
                                  .data ??
                              "Chọn Outlet"
                          : "Chọn Outlet",
                      style: TextStyle(fontSize: 16),
                    ),
                    Icon(Icons.arrow_drop_down, color: Colors.black54),
                  ],
                ),
              ),
            ),

            // Send Info
            SizedBox(height: isSmallScreen ? 16 : 24),
            _buildSendInfo(isSmallScreen, fontSize),

            // Continue Button
            SizedBox(height: isSmallScreen ? 16 : 24),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, Routes.userDetails);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6200EE),
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth < 600 ? 40 : 80,
                    vertical: screenWidth < 600 ? 12 : 16,
                  ),
                  minimumSize: Size(
                    double.infinity,
                    screenWidth < 600 ? 48 : 56,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  elevation: 3,
                  shadowColor: Colors.grey.withOpacity(0.3),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.arrow_forward,
                        color: Colors.white, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      tr('continue'),
                      style: TextStyle(
                        fontSize: screenWidth < 600 ? 16 : 20,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrencyInputField(
      String label,
      String selectedValue,
      ValueChanged<String?> onChanged,
      bool isSmallScreen,
      TextEditingController controller,
      {bool isSender = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 1),
            borderRadius: BorderRadius.circular(16),
            color: Colors.white,
          ),
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            children: [
              InkWell(
                onTap: () {
                  _showCurrencyPicker(context, isSender);
                },
                child: Row(
                  children: [
                    // Chỉ hiển thị currencyCode khi đã chọn
                    Text(
                      selectedValue,
                      style: TextStyle(fontSize: 16),
                    ),
                    const Icon(Icons.arrow_drop_down),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  onChanged: (value) => _validateNumeric(),
                  decoration: InputDecoration(
                    hintText: tr('enter_amount'),
                    errorText: _numericError,
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSendInfo(bool isSmallScreen, double fontSize) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow(
          tr('exchange_rate'),
          exchangeRate,
          tooltip: tr('exchange_rate_tooltip'),
          fontSize: fontSize,
        ),
        _buildInfoRow(
          tr('fees'),
          sendRate != null ? "$sendRate $fromCurrency" : "Loading...",
          fontSize: fontSize,
        ),
        _buildInfoRow(
          tr('total_pay'),
          "549.24",
          isRecipient: true,
          fontSize: fontSize,
        ),
      ],
    );
  }

  Widget _buildInfoRow(
    String title,
    String value, {
    String? tooltip,
    bool isRecipient = false,
    required double fontSize,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: isRecipient ? FontWeight.bold : FontWeight.normal,
                  fontSize: fontSize,
                ),
              ),
              if (tooltip != null) ...[
                const SizedBox(width: 4),
                Tooltip(
                  message: tooltip,
                  child: const Icon(Icons.info_outline, size: 16),
                ),
              ],
            ],
          ),
          Text(
            value,
            style: TextStyle(fontSize: fontSize),
          ),
        ],
      ),
    );
  }
}
