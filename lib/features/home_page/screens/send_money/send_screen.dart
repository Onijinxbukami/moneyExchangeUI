import 'package:circle_flags/circle_flags.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/routes.dart';
import 'package:flutter_application_1/shared/widgets/progressbar.dart';
import 'package:flutter_application_1/features/home_page/screens/send_money/send_money_service.dart';

import 'package:shared_preferences/shared_preferences.dart';

class SendMoneyForm extends StatefulWidget {
  const SendMoneyForm({super.key});

  @override
  State<SendMoneyForm> createState() => _SendMoneyFormState();
}

class _SendMoneyFormState extends State<SendMoneyForm> {
  String fromCurrency = "";
  String toCurrency = "";
  String exchangeRate = "";

  String? selectedOutlet;
  String? localCurrency;
  String? foreignCurrency;
  String? selectedCurrency;
  double? sendRate, buyRate, sellRate;
  String? outletId;
  String searchKeyword = '';

  final TextEditingController _sendController = TextEditingController();
  final TextEditingController _receiveController = TextEditingController();
  final SendMoneyService _service = SendMoneyService();

  String? _currencyError;
  List<String> currencyCodes = [];
  List<Map<String, String>> _outletDisplayList = [];
  List<Map<String, String>> _currencyDisplayList = [];

  TextEditingController searchOutletController = TextEditingController();
  List<Map<String, String>> filteredOutletList = [];

  final TextEditingController locationController = TextEditingController();
  Map<String, String> currencyToCountryCode = {
    'USD': 'us',
    'EUR': 'eu',
    'JPY': 'jp',
    'GBP': 'gb',
    'AUD': 'au',
    'CAD': 'ca',
    'CHF': 'ch',
    'CNY': 'cn',
    'SEK': 'se',
    'NZD': 'nz',
    'VND': 'vn',
    'THB': 'th',
    'SGD': 'sg',
    'MXN': 'mx',
    'BRL': 'br',
    'ZAR': 'za',
    'RUB': 'ru',
    'INR': 'in',
    'KRW': 'kr',
    'HKD': 'hk',
    'MYR': 'my',
    'PHP': 'ph',
    'IDR': 'id',
    'TRY': 'tr',
    'PLN': 'pl',
    'HUF': 'hu',
    'CZK': 'cz',
    'DKK': 'dk',
    'NOK': 'no',
    'ILS': 'il',
    'SAR': 'sa',
    'AED': 'ae',
    'EGP': 'eg',
    'ARS': 'ar',
    'CLP': 'cl',
    'COP': 'co',
    'PEN': 'pe',
    'PKR': 'pk',
    'BDT': 'bd',
    'LKR': 'lk',
    'KWD': 'kw',
    'BHD': 'bh',
    'OMR': 'om',
    'QAR': 'qa',
    'JOD': 'jo',
    'XOF': 'bj',
    'XAF': 'cm',
    'XCD': 'ag',
    'XPF': 'pf',
    'MAD': 'ma',
    'DZD': 'dz',
    'TND': 'tn',
    'LBP': 'lb',
    'JMD': 'jm',
    'TTD': 'tt',
    'NGN': 'ng',
    'GHS': 'gh',
    'KES': 'ke',
    'UGX': 'ug',
    'TZS': 'tz',
    'ETB': 'et',
    'ZMW': 'zm',
    'MZN': 'mz',
    'BWP': 'bw',
    'NAD': 'na',
    'SCR': 'sc',
    'MUR': 'mu',
    'BBD': 'bb',
    'BSD': 'bs',
    'FJD': 'fj',
    'SBD': 'sb',
    'PGK': 'pg',
    'TOP': 'to',
    'WST': 'ws',
    'KZT': 'kz',
    'UZS': 'uz',
    'TJS': 'tj',
    'KGS': 'kg',
    'MMK': 'mm',
    'LAK': 'la',
    'KHR': 'kh',
    'MNT': 'mn',
    'NPR': 'np',
    'BND': 'bn',
    'XAU': 'xau',
    'XAG': 'xag',
    'XPT': 'xpt',
    'XPD': 'xpd',
    'HTG': 'ht', // Haitian Gourde
    'LRD': 'lr', // Liberian Dollar
    'BIF': 'bi', // Burundian Franc
    'IQD': 'iq', // Iraqi Dinar
    'MGA': 'mg', // Malagasy Ariary
    'LSL': 'ls', // Lesotho Loti
    'AFN': 'af', // Afghan Afghani (cũ, thay bằng AFN)
    'CVE': 'cv', // Cape Verdean Escudo
    'BGN': 'bg', // Bulgarian Lev
    'LYD': 'ly', // Libyan Dinar
    'AWG': 'aw', // Aruban Florin
    'HRK': 'hr', // Croatian Kuna (đã đổi sang EUR từ 2023)
    'BZD': 'bz', // Belize Dollar
    'HNL': 'hn', // Honduran Lempira
    'MVR': 'mv', // Maldivian Rufiyaa
    'GYD': 'gy', // Guyanese Dollar
    'SVC': 'sv', // Salvadoran Colón
    'ISK': 'is', // Icelandic Króna
    'GNF': 'gn', // Guinean Franc
    'IRR': 'ir', // Iranian Rial
    'KYD': 'ky', // Cayman Islands Dollar
    'DJF': 'dj', // Djiboutian Franc
    'MWK': 'mw', // Malawian Kwacha
    'BOB': 'bo', // Bolivian Boliviano
    'LTL': 'lt', // Lithuanian Litas (đã đổi sang EUR)
    'AMD': 'am', // Armenian Dram
    'CRC': 'cr', // Costa Rican Colón
    'KMF': 'km', // Comorian Franc
    'AOA': 'ao', // Angolan Kwanza (cũ, thay bằng AOA)
    'ALL': 'al', // Albanian Lek
    'ERN': 'er', // Eritrean Nakfa
    'EEK': 'ee', // Estonian Kroon (đã đổi sang EUR)
    'GMD': 'gm', // Gambian Dalasi
    'GIP': 'gi', // Gibraltar Pound
    'CUP': 'cu', // Cuban Peso
    'BMD': 'bm', // Bermudian Dollar
    'FKP': 'fk', // Falkland Islands Pound
    'CDF': 'cd', // Congolese Franc
    'LVL': 'lv', // Latvian Lats (đã đổi sang EUR)
    'MKD': 'mk', // Macedonian Denar
    'GTQ': 'gt', // Guatemalan Quetzal
    'AZN': 'az', // Azerbaijani Manat
    'DOP': 'do', // Dominican Peso
    'BYN': 'by', // Belarusian Ruble
    'GEL': 'ge', // Georgian Lari
    'BTN': 'bt', // Bhutanese Ngultrum
    'MOP': 'mo',
    'ANG': 'ai',
    'BYR': 'by',
  };

  bool isSenderActive = true;
  bool isRecipientActive = true;
  String? _numericError;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchOutlets();
    fetchCurrencyCodes();
    _setupTextFieldCurrencyListeners();
    _loadSavedInputs();
    //_fetchData();
  }

  Future<void> _fetchData() async {
    final outlets = await _service.fetchOutlets();
    final currencies = await _service.fetchCurrencyCodes();

    setState(() {
      _outletDisplayList = outlets;
      _currencyDisplayList = currencies;
      isLoading = false;
    });
  }

  void _fetchRates(
      String outletId, String fromCurrency, String toCurrency) async {
    final rates =
        await _service.fetchOutletRates(outletId, fromCurrency, toCurrency);

    setState(() {
      sendRate = rates['sendRate'];
      buyRate = rates['buyRate'];
      sellRate = rates['sellRate'];
    });
  }

  Future<void> fetchOutlets() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('outlets').get();

      if (querySnapshot.docs.isEmpty) {
        print("❌ No outlets found in Firestore.");
        return;
      }

      List<Map<String, String>> outletList = querySnapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        return {
          'outletId': doc.id, // 🔹 Dùng document ID
          'outletName': data['outletName']?.toString() ?? "Unnamed Outlet",
        };
      }).toList();

      setState(() {
        _outletDisplayList = outletList;
      });
    } catch (e) {
      print("⚠️ Error fetching outlets: $e");
    }
  }

  Future<void> fetchCurrencyCodes() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('currencyCodes').get();

      if (querySnapshot.docs.isEmpty) {
        return;
      }

      List<Map<String, String>> currencyList = querySnapshot.docs.map((doc) {
        return {
          'currencyCode': doc['currencyCode'].toString(),
          'description': doc['description'].toString()
        };
      }).toList();

      setState(() {
        _currencyDisplayList = currencyList;
      });
    } catch (e) {
      print("⚠️ Error fetching currency codes: $e");
    }
  }

  Future<void> fetchOutletRates(
      String? outletId, String? fromCurrency, String? toCurrency) async {
    // Kiểm tra đầu vào
    if (outletId == null || fromCurrency == null || toCurrency == null) {
      print("⚠️ Missing required parameters for fetching outlet rates.");
      return;
    }

    try {
      // Truy vấn Firestore với điều kiện outletId, fromCurrency, toCurrency
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('outletRates')
          .where('outletId', isEqualTo: outletId)
          .where('localCurrency', isEqualTo: fromCurrency)
          .where('foreignCurrency', isEqualTo: toCurrency)
          .get();

      if (querySnapshot.docs.isEmpty) {
        print("❌ No outlet rates found for $fromCurrency ➡️ $toCurrency");

        // Cập nhật thông báo lỗi
        setState(() {
          _currencyError = "Currency này không hỗ trợ";
        });
        return;
      }

      // Nếu có dữ liệu, đặt lại thông báo lỗi
      setState(() {
        _currencyError = null;
      });

      // Lấy dữ liệu document đầu tiên (nếu có)
      var data = querySnapshot.docs.first.data() as Map<String, dynamic>;

      // Cập nhật State nếu Widget vẫn đang hiện diện (mounted)
      if (mounted) {
        setState(() {
          sendRate = double.tryParse(data['sendRate'].toString()) ?? 0.0;
          buyRate = double.tryParse(data['buyRate'].toString()) ?? 0.0;
          sellRate = double.tryParse(data['sellRate'].toString()) ?? 0.0;
          localCurrency = data['localCurrency'] ?? '';
          foreignCurrency = data['foreignCurrency'] ?? '';
        });
      }
    } catch (e) {
      print("⚠️ Error fetching outlet rates: $e");
      setState(() {
        _currencyError = "Lỗi khi tải dữ liệu tỉ giá";
      });
    }
  }

  Future<void> _loadSavedInputs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Lấy giá trị từ SharedPreferences
    _sendController.text = prefs.getString('sendAmount') ?? '';
    _receiveController.text = prefs.getString('receiveAmount') ?? '';

    // Lấy outletId từ SharedPreferences (lưu ID chứ không phải tên)
    String selectedOutletId = prefs.getString('selectedOutlet') ?? '';

    // Kiểm tra xem outletId đã được lưu trong SharedPreferences chưa
    print("📥 Đã lưu selectedOutletId: $selectedOutletId");

    // Tìm outletName từ outletId
    String outletName = _outletDisplayList.firstWhere(
            (item) => item['outletId'] == selectedOutletId,
            orElse: () => {'outletName': 'No outlet selected'})['outletName'] ??
        'No outlet selected';

    // Lưu outletName vào SharedPreferences (Nếu cần thiết, có thể lưu cả ID)
    await prefs.setString('selectedOutlet', selectedOutletId);

    // Cập nhật filteredOutletList khi tải lại giá trị
    String savedSearchKeyword = searchOutletController.text.toLowerCase();

    setState(() {
      filteredOutletList = _outletDisplayList.where((item) {
        final outletName = item['outletName']!.toLowerCase();
        return outletName.contains(savedSearchKeyword);
      }).toList();
    });

    // Lưu outletName vào SharedPreferences
    await prefs.setString('selectedOutletName', outletName);

    // In giá trị outletName ra console để kiểm tra
    print("📥 Đã lưu outletName: $outletName");

    await prefs.setString('sellRate', sellRate?.toString() ?? '0.0');
    await prefs.setString('sendRate', sendRate?.toString() ?? '0.0');

    double sendAmount = double.tryParse(_sendController.text) ?? 0.0;
    double totalPay = sendAmount + (sendRate ?? 0.0);

    // Lưu totalPay vào SharedPreferences
    await prefs.setString('totalPay', totalPay.toStringAsFixed(2));

    // In giá trị sendRate và sellRate ra console để kiểm tra
    print("📥 Đã lưu sendRate: $sendRate");
    print("📥 Đã lưu sellRate: $sellRate");
    print("📥 Đã lưu totalPay: $totalPay");
  }

  String _calculateTotalPay() {
    double sendAmount = double.tryParse(_sendController.text) ?? 0.0;
    double totalPay = sendAmount + (sendRate ?? 0.0);
    return totalPay.toStringAsFixed(2);
  }

  bool _validateNumeric(TextEditingController controller) {
    final input = controller.text;
    // Chỉ cho phép số và dấu chấm
    if (input.isNotEmpty && !RegExp(r'^[0-9]*\.?[0-9]*$').hasMatch(input)) {
      setState(() {
        _numericError = "❌ Only numbers are allowed!";
      });
      return false;
    } else {
      setState(() {
        _numericError = null;
      });
      return true;
    }
  }

  void _setupTextFieldCurrencyListeners() {
    // Lắng nghe thay đổi trên _sendController
    _sendController.addListener(() async {
      if (_validateNumeric(_sendController) && isSenderActive) {
        double sendAmount = double.tryParse(_sendController.text) ?? 0.0;
        double receiveAmount =
            (buyRate != null && buyRate! > 0) ? sendAmount / buyRate! : 0.0;

        // Lưu tạm thời giá trị khi người dùng nhập
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('sendAmount', _sendController.text);
        await prefs.setString('receiveAmount',
            receiveAmount.toStringAsFixed(2)); // 🔥 Thêm dòng này

        // Tạm ngắt Listener để tránh vòng lặp
        isRecipientActive = false;
        _receiveController.text = receiveAmount.toStringAsFixed(2);
        isRecipientActive = true;
      }
    });

    // Lắng nghe thay đổi trên _receiveController
    _receiveController.addListener(() async {
      if (_validateNumeric(_receiveController) && isRecipientActive) {
        double receiveAmount = double.tryParse(_receiveController.text) ?? 0.0;
        double sendAmount =
            (buyRate != null && buyRate! > 0) ? receiveAmount * buyRate! : 0.0;

        // Lưu tạm thời giá trị khi người dùng nhập
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('receiveAmount', _receiveController.text);
        await prefs.setString('sendAmount', sendAmount.toStringAsFixed(2));

        // Tạm ngắt Listener để tránh vòng lặp
        isSenderActive = false;
        _sendController.text = sendAmount.toStringAsFixed(2);
        isSenderActive = true;
      }
    });
  }

  void _showOutletPicker(BuildContext context) {
    List<Map<String, String>> filteredOutletList =
        List.from(_outletDisplayList);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (_) => StatefulBuilder(
        builder: (BuildContext context, StateSetter setStateModal) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Container(
              height: 400,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Select Outlet',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextField(
                      controller: searchOutletController,
                      decoration: InputDecoration(
                        hintText: 'Search outlet...',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onChanged: (value) {
                        setStateModal(() {
                          String searchKeyword = value.toLowerCase();
                          filteredOutletList = _outletDisplayList.where((item) {
                            final outletName =
                                item['outletName']!.toLowerCase();
                            return outletName.contains(searchKeyword);
                          }).toList();
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: filteredOutletList.isNotEmpty
                        ? ListView.builder(
                            itemCount: filteredOutletList.length,
                            itemBuilder: (context, index) {
                              final item = filteredOutletList[index];
                              final outletName = item['outletName']!;
                              return ListTile(
                                title: Text(
                                  outletName,
                                  style: TextStyle(fontSize: 16),
                                ),
                                onTap: () {
                                  setState(() {
                                    outletId = item['outletId']!;
                                    selectedOutlet = outletId!;
                                  });
                                  print("🔄 Selected Outlet: $selectedOutlet");
                                  Navigator.pop(context);

                                  // Kiểm tra nếu fromCurrency và toCurrency đã được chọn
                                  if (fromCurrency.isNotEmpty &&
                                      toCurrency.isNotEmpty) {
                                    fetchOutletRates(
                                        outletId, fromCurrency, toCurrency);
                                  } else {
                                    print(
                                        "⚠️ Please select both fromCurrency and toCurrency before fetching rates.");
                                  }
                                },
                              );
                            },
                          )
                        : Center(
                            child: Text(
                              "No matching outlets.",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                          ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancel', style: TextStyle(fontSize: 18)),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showCurrencyPicker(BuildContext context, bool isSender) {
    TextEditingController searchCurrencyController = TextEditingController();

    List<Map<String, String>> filteredCurrencyList =
        List.from(_currencyDisplayList);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (_) => StatefulBuilder(
          builder: (BuildContext context, StateSetter setStateModal) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Container(
            height: 400,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Select Currency',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextField(
                    controller: searchCurrencyController,
                    decoration: InputDecoration(
                      hintText: 'Search currency...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onChanged: (value) {
                      setStateModal(() {
                        searchKeyword = value.toLowerCase();
                        filteredCurrencyList =
                            _currencyDisplayList.where((item) {
                          final currencyCode =
                              item['currencyCode']!.toLowerCase();
                          return currencyCode.contains(searchKeyword);
                        }).toList();
                      });
                    },
                  ),
                ),
                SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredCurrencyList.length,
                    itemBuilder: (context, index) {
                      final item = filteredCurrencyList[index];
                      final currencyCode = item['currencyCode']!;
                      final countryCode = currencyToCountryCode[currencyCode] ??
                          'UN'; // UN: Unknown

                      return ListTile(
                        leading: CircleFlag(
                          countryCode.toLowerCase(),
                          size: 32, // Kích thước lá cờ
                        ),
                        title: Text(
                          "$currencyCode - ${item['description']}",
                          style: TextStyle(fontSize: 16),
                        ),
                        onTap: () {
                          setState(() {
                            if (isSender) {
                              fromCurrency = currencyCode;
                            } else {
                              toCurrency = currencyCode;
                            }
                          });
                          print(
                              "🔄 Selected Currency: ${isSender ? fromCurrency : toCurrency}");
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel', style: TextStyle(fontSize: 18)),
                ),
              ],
            ),
          ),
        );
      }),
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

                  // Gọi fetchOutletRates nếu outletId đã được chọn
                  if (outletId != null) {
                    fetchOutletRates(outletId, fromCurrency, toCurrency);
                  }
                });
              },
              isSmallScreen,
              _sendController,
              isSender: true,
            ),

            _buildCurrencyInputField(
              tr('recipient_gets'),
              toCurrency,
              (value) {
                setState(() {
                  toCurrency = value!;
                  print("🔄 Updated toCurrency: $toCurrency");

                  // Gọi fetchOutletRates nếu outletId đã được chọn
                  if (outletId != null) {
                    fetchOutletRates(outletId, fromCurrency, toCurrency);
                  }
                });
              },
              isSmallScreen,
              _receiveController,
              isSender: false,
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
                      selectedOutlet != null && selectedOutlet!.isNotEmpty
                          ? _outletDisplayList.firstWhere(
                                  (item) => item['outletId'] == selectedOutlet,
                                  orElse: () => {
                                        'outletName': 'Select Outlet'
                                      })['outletName'] ??
                              "Select Outlet"
                          : "Select Outlet",
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
                onPressed: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();

                  // selectedOutlet là kiểu String, không cần sử dụng .text
                  String outletId = selectedOutlet ??
                      ''; // Nếu selectedOutlet là null, sử dụng giá trị mặc định ''

                  // Lưu outletId vào SharedPreferences (searchKeyword)
                  await prefs.setString('searchKeyword', outletId);

                  // Lấy các giá trị tiền từ SharedPreferences
                  String sendAmount = prefs.getString('sendAmount') ?? '0.00';
                  String receiveAmount =
                      prefs.getString('receiveAmount') ?? '0.00';

                  // Tìm outletName từ outletId
                  String? outletName = _outletDisplayList.firstWhere(
                      (item) => item['outletId'] == outletId,
                      orElse: () =>
                          {'outletName': 'No outlet selected'})['outletName'];

                  // Lưu outletName vào SharedPreferences
                  await prefs.setString('selectedOutletName', outletName!);

                  await prefs.setString(
                      'sellRate', sellRate?.toString() ?? '0.0');
                  await prefs.setString(
                      'sendRate', sendRate?.toString() ?? '0.0');

                  // In ra console để kiểm tra
                  print("📤 Số tiền gửi: $sendAmount");
                  print("📥 Số tiền nhận: $receiveAmount");
                  print("📥 Outlet: $outletName"); // In ra outletName
                  print("📥 SendRate: $sendRate"); // In ra sendRate
                  print("📥 SellRate: $sellRate"); // In ra sellRate

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
                    if (selectedValue.isNotEmpty)
                      CircleFlag(
                        (currencyToCountryCode[selectedValue] ?? 'UN')
                            .toLowerCase(),
                        size: 24,
                      ),
                    SizedBox(width: 4),
                    Text(
                      selectedValue.isNotEmpty ? selectedValue : 'Select',
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
                  onChanged: (value) {
                    if (isSender) {
                      print("🔢 You Send: ${_sendController.text}");
                    } else {
                      print("🔢 Recipient Gets: ${_receiveController.text}");
                    }
                  },
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
        // Hiển thị thông báo lỗi nếu có
        if (_currencyError != null) ...[
          SizedBox(height: 4),
          Text(
            _currencyError!,
            style: TextStyle(color: Colors.red, fontSize: 14),
          ),
        ]
      ],
    );
  }

  Widget _buildSendInfo(bool isSmallScreen, double fontSize) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow(
          tr('exchange_rate'),
          (sellRate != null) ? "$sellRate " : "Loading...",
          tooltip: tr('exchange_rate_tooltip'),
          fontSize: fontSize,
        ),
        _buildInfoRow(
          tr('fees'),
          (fromCurrency != null && fromCurrency.isNotEmpty)
              ? "$sendRate $fromCurrency"
              : "Loading...",
          fontSize: fontSize,
        ),
        _buildInfoRow(
          tr('total_pay'),
          _calculateTotalPay(),
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
