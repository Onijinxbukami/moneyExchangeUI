import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/routes.dart';
import 'package:flutter_application_1/features/home_page/screens/location/location_screen.dart';
import 'package:flutter_application_1/shared/services/outlets_service.dart';
import 'package:flutter_application_1/shared/widgets/progressbar.dart';
import 'package:flutter_application_1/features/home_page/screens/setting/setting_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:circle_flags/circle_flags.dart';

class HomepageAddressPage extends StatefulWidget {
  const HomepageAddressPage({super.key});

  @override
  _HomepageAddressPageState createState() => _HomepageAddressPageState();
}

class _HomepageAddressPageState extends State<HomepageAddressPage> {
  final TextEditingController locationController = TextEditingController();

  String fromCurrency = "";
  String toCurrency = "";

  String sendMoneyValue = '0.00';
  String receiveMoneyValue = '0.00';
  String outletName = "Select Outlet";
  double sellRate = 0.0;
  double sendRate = 0.0;
  String sendName = '';
  String sendDob = '';
  String sendPhone = '';
  String sendEmail = '';

  String receiveName = '';
  String AccounrNumber = '';
  String BankeName = '';

  final Map<String, String> flagUrls = {
    "GBP": "https://flagcdn.com/w40/gb.png",
    "USD": "https://flagcdn.com/w40/us.png",
  };
 final Map<String, String> _currencyToCountryCode = {
    'USD': 'us', 'EUR': 'eu', 'JPY': 'jp', 'GBP': 'gb', 'AUD': 'au',
    'CAD': 'ca', 'CHF': 'ch', 'CNY': 'cn', 'SEK': 'se', 'NZD': 'nz',
    'VND': 'vn', 'THB': 'th', 'SGD': 'sg', 'MXN': 'mx', 'BRL': 'br',
    'ZAR': 'za', 'RUB': 'ru', 'INR': 'in', 'KRW': 'kr', 'HKD': 'hk',
    'MYR': 'my', 'PHP': 'ph', 'IDR': 'id', 'TRY': 'tr', 'PLN': 'pl',
    'HUF': 'hu', 'CZK': 'cz', 'DKK': 'dk', 'NOK': 'no', 'ILS': 'il',
    'SAR': 'sa', 'AED': 'ae', 'EGP': 'eg', 'ARS': 'ar', 'CLP': 'cl',
    'COP': 'co', 'PEN': 'pe', 'PKR': 'pk', 'BDT': 'bd', 'LKR': 'lk',
    'KWD': 'kw', 'BHD': 'bh', 'OMR': 'om', 'QAR': 'qa', 'JOD': 'jo',
    'XOF': 'bj', 'XAF': 'cm', 'XCD': 'ag', 'XPF': 'pf', 'MAD': 'ma',
    'DZD': 'dz', 'TND': 'tn', 'LBP': 'lb', 'JMD': 'jm', 'TTD': 'tt',
    'NGN': 'ng', 'GHS': 'gh', 'KES': 'ke', 'UGX': 'ug', 'TZS': 'tz',
    'ETB': 'et', 'ZMW': 'zm', 'MZN': 'mz', 'BWP': 'bw', 'NAD': 'na',
    'SCR': 'sc', 'MUR': 'mu', 'BBD': 'bb', 'BSD': 'bs', 'FJD': 'fj',
    'SBD': 'sb', 'PGK': 'pg', 'TOP': 'to', 'WST': 'ws', 'KZT': 'kz',
    'UZS': 'uz', 'TJS': 'tj', 'KGS': 'kg', 'MMK': 'mm', 'LAK': 'la',
    'KHR': 'kh', 'MNT': 'mn', 'NPR': 'np', 'BND': 'bn', 'XAU': 'xau',
    'XAG': 'xag', 'XPT': 'xpt', 'XPD': 'xpd', 'HTG': 'ht', 'LRD': 'lr',
    'BIF': 'bi', 'IQD': 'iq', 'MGA': 'mg', 'LSL': 'ls', 'AFN': 'af',
    'CVE': 'cv', 'BGN': 'bg', 'LYD': 'ly', 'AWG': 'aw', 'HRK': 'hr',
    'BZD': 'bz', 'HNL': 'hn', 'MVR': 'mv', 'GYD': 'gy', 'SVC': 'sv',
    'ISK': 'is', 'GNF': 'gn', 'IRR': 'ir', 'KYD': 'ky', 'DJF': 'dj',
    'MWK': 'mw', 'BOB': 'bo', 'LTL': 'lt', 'AMD': 'am', 'CRC': 'cr',
    'KMF': 'km', 'AOA': 'ao', 'ALL': 'al', 'ERN': 'er', 'EEK': 'ee',
    'GMD': 'gm', 'GIP': 'gi', 'CUP': 'cu', 'BMD': 'bm', 'FKP': 'fk',
    'CDF': 'cd', 'LVL': 'lv', 'MKD': 'mk', 'GTQ': 'gt', 'AZN': 'az',
    'DOP': 'do', 'BYN': 'by', 'GEL': 'ge', 'BTN': 'bt', 'MOP': 'mo',
    'ANG': 'ai', 'BYR': 'by'
  };
  List<Map<String, String>> _currencyDisplayList = [];
  final OutletsService _outletsService = OutletsService();


  @override
  void initState() {
    super.initState();
    fetchCurrencyCodes();
    _loadSavedInputs();
  }

  Future<void> fetchCurrencyCodes() async {
    final currencyList = await _outletsService.fetchCurrencyCodes();
    setState(() {
      _currencyDisplayList = currencyList;
    });
  }

  String _calculateTotalPay() {
    double sendAmount = double.tryParse(sendMoneyValue) ?? 0.0;
    double totalPay = sendAmount +
        sendRate; 
    return totalPay.toStringAsFixed(2); // Format to 2 decimal places
  }

  Future<void> _loadSavedInputs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String savedOutletName =
        prefs.getString('selectedOutletName') ?? 'No outlet selected';
    sellRate = double.tryParse(prefs.getString('sellRate') ?? '0.0') ?? 0.0;
    sendRate = double.tryParse(prefs.getString('sendRate') ?? '0.0') ?? 0.0;
    String Sname = prefs.getString('sendName') ?? 'Chưa có';
    String dob = prefs.getString('sendDob') ?? 'Chưa có';
    String phone = prefs.getString('sendPhone') ?? 'Chưa có';
    String email = prefs.getString('sendEmail') ?? 'Chưa có';
    String Rname = prefs.getString('receiveName') ?? 'Chưa có';
    String receviceAccounrNumber =
        prefs.getString('receiveAccountNumber') ?? 'Chưa có';
    String receiveBankeName =
        prefs.getString('receiveAccountName') ?? 'Chưa có';
    String savedFromCurrency = prefs.getString('fromCurrency') ?? "";
    String savedToCurrency = prefs.getString('toCurrency') ?? "";

    setState(() {
      sendMoneyValue = prefs.getString('sendAmount') ?? '0.00';
      receiveMoneyValue = prefs.getString('receiveAmount') ?? '0.00';
      outletName = savedOutletName;
      sendName = Sname;
      sendDob = dob;
      sendPhone = phone;
      sendEmail = email;
      receiveName = Rname;
      AccounrNumber = receviceAccounrNumber;
      BankeName = receiveBankeName;
      fromCurrency = savedFromCurrency;
      toCurrency = savedToCurrency;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    final bool isSmallScreen =
        screenWidth < 600; // Kiểm tra chiều rộng màn hình

    final double padding = isSmallScreen ? 12.0 : 16.0;
    final double fontSize = isSmallScreen ? 14.0 : 18.0;

    return DefaultTabController(
      length: 3,
      initialIndex: 1,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Container(
            color: const Color(0xFF6610F2), // Màu nền AppBar
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    const SizedBox(
                        width: 8), // Khoảng cách giữa icon và tiêu đề
                    Expanded(child: _buildHeader()), // Tiêu đề AppBar
                  ],
                ),
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            const SizedBox(height: 20),
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
              currentStep: 3,
              backgroundColor: Colors.grey[300]!,
              progressColor: Colors.blue,
              height: 8,
            ),
            SizedBox(height: isSmallScreen ? 16 : 24),

            // TabBar phía trên nội dung chính

            const SizedBox(height: 10),

            // Phần nội dung cuộn chính
            Expanded(
              child: TabBarView(
                children: [
                  LocationForm(),
                  _buildContent(fontSize, padding), // Nội dung cho "Near me"

                  SettingForm(), // Nội dung cho "Setting"
                ],
              ),
            ),

            // TabBar phía dưới nội dung chính
            Container(
              color: const Color(0xFF5732C6),
              child: TabBar(
                indicatorColor: Colors.white,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.grey,
                tabs: [
                  Tab(text: tr('near_me'), icon: const Icon(Icons.map)),
                  Tab(text: tr('send'), icon: const Icon(Icons.send)),
                  Tab(text: tr('setting'), icon: const Icon(Icons.settings)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: const Color(0xFF6610F2),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Language Dropdown với Cupertino Style
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 6,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  showCupertinoModalPopup(
                    context: context,
                    builder: (BuildContext context) {
                      return CupertinoActionSheet(
                        title: Text(tr("select_language")),
                        actions: [
                          CupertinoActionSheetAction(
                            onPressed: () {
                              context.setLocale(const Locale('en'));
                              Navigator.pop(context);
                            },
                            child: const Text("English"),
                          ),
                          CupertinoActionSheetAction(
                            onPressed: () {
                              context.setLocale(const Locale('vi'));
                              Navigator.pop(context);
                            },
                            child: const Text("Tiếng Việt"),
                          ),
                        ],
                        cancelButton: CupertinoActionSheetAction(
                          onPressed: () => Navigator.pop(context),
                          child: Text(tr("cancel")),
                        ),
                      );
                    },
                  );
                },
                child: Row(
                  children: [
                    Text(
                      context.locale.languageCode.toUpperCase(),
                      style: const TextStyle(color: Colors.black, fontSize: 16),
                    ),
                    const Icon(CupertinoIcons.chevron_down, size: 16),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),

          StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CupertinoActivityIndicator(color: Colors.white);
              }

              if (snapshot.hasData) {
                return FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('users')
                      .doc(snapshot.data!.uid)
                      .get(),
                  builder: (context, userSnapshot) {
                    if (userSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const CupertinoActivityIndicator(
                          color: Colors.white);
                    }

                    if (userSnapshot.hasData && userSnapshot.data!.exists) {
                      final userData =
                          userSnapshot.data!.data() as Map<String, dynamic>? ??
                              {}; // Safely handle null
                      return Row(
                        children: [
                          const Icon(CupertinoIcons.person_circle_fill,
                              color: Colors.white, size: 28),
                          const SizedBox(width: 8),
                          Text(
                            userData['userName'] ??
                                'User', // Default value if userName is null
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 16),
                            overflow:
                                TextOverflow.ellipsis, // Prevents overflow
                          ),
                        ],
                      );
                    }

                    return const Text('Error',
                        style: TextStyle(color: Colors.white));
                  },
                );
              }

              //return Text(tr('login'), style: const TextStyle(color: Colors.white));
              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, Routes.login);
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    tr('login'),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget midHeader(double fontSize, double padding) {
    double screenWidth = MediaQuery.of(context).size.width;

    final bool isSmallScreen = screenWidth < 600;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        // Thêm SingleChildScrollView để cuộn dọc
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tr('user_infor'),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFF00274D),
              ),
            ),
            const Divider(color: Colors.black),
            const SizedBox(height: 10),
// Full Name Field
            Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start, // Canh trái phần tiêu đề
              children: [
                // Full Name
                Row(
                  children: [
                     Text(
                      tr('full_name'),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF00274D),
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        const SizedBox(width: 6),
                        Text(
                          sendName, // Giá trị từ state hoặc API
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Date of Birth
                Row(
                  children: [
                    Text(
                      tr('date_of_birth'),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF00274D),
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        const SizedBox(width: 6),
                        Text(
                          sendDob, // Giá trị ngày sinh
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Phone Number
                Row(
                  children: [
                    Text(
                      tr('phone_number'),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF00274D),
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        const SizedBox(width: 6),
                        Text(
                          sendPhone, // Giá trị số điện thoại
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Email Address
                Row(
                  children: [
                    Text(
                      tr('email'),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF00274D),
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        const SizedBox(width: 6),
                        Text(
                          sendEmail, // Giá trị email
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tiêu đề
                Text(
                  tr('recipient_details'),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF00274D),
                  ),
                ),
                const Divider(color: Colors.black),
                const SizedBox(height: 20),

                // Recipient Name
                Row(
                  children: [
                    Text(
                      tr('full_name'),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF00274D),
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        const SizedBox(width: 6),
                        Text(
                          receiveName, // Giá trị tên người nhận
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Bank Number
                Row(
                  children: [
                    Text(
                      tr('account_number'),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF00274D),
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        const SizedBox(width: 6),
                        Text(
                          AccounrNumber, // Giá trị số tài khoản ngân hàng
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Bank Code
                Row(
                  children: [
                    Text(
                      tr('bank_name'),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF00274D),
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        const SizedBox(width: 6),
                        Text(
                          BankeName, // Giá trị mã ngân hàng
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 20),

            Text(
              tr('transaction_details'),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFF00274D),
              ),
            ),
            const Divider(color: Colors.black),
            const SizedBox(height: 20),
// Outlet Field
            Row(
              children: [
                Text(
                  tr('outlet'),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF00274D),
                  ),
                ),
                const Spacer(),
                Row(
                  children: [
                    const SizedBox(width: 6),
                    Text(
                      outletName, // Hiển thị outletName
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 20),

// Send Money Field

            Row(
              children: [
                // Sử dụng CircleFlag thay vì Image.network
                CircleFlag(
                  (_currencyToCountryCode[fromCurrency] ?? 'UN').toLowerCase(),
                  size: 24, // Kích thước lá cờ
                ),
                const SizedBox(width: 8),

                // Nhãn tiền tệ (USD, GBP, ...)
                Text(
                  fromCurrency,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),

                const Spacer(),

                // Số tiền gửi (căn phải)
                Text(
                  sendMoneyValue, // ✅ Hiển thị giá trị đã lưu
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

// Receiver Money Field
            Row(
              children: [
                CircleFlag(
                  (_currencyToCountryCode[toCurrency] ?? 'UN').toLowerCase(),
                  size: 24, // Kích thước lá cờ
                ),
                const SizedBox(width: 8),

                // Nhãn tiền tệ
                Text(
                  toCurrency,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),

                const Spacer(),

                // Số tiền nhận (căn phải)
                Text(
                  receiveMoneyValue, // ✅ Hiển thị giá trị đã lưu
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ],
            ),

            SizedBox(height: isSmallScreen ? 16 : 24),

// Rate Field
            Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start, // Canh trái phần tiêu đề
              children: [
                // Rate
                Row(
                  children: [
                    Text(
                      tr('rate'),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF00274D),
                      ),
                    ),
                    const Spacer(), // Đẩy 'rateValue' về bên phải
                    Text(
                      sellRate.toString(), // Thay thế bằng giá trị thực tế
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Fees
                Row(
                  children: [
                    Text(
                      tr('fees'),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF00274D),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      sendRate.toString(),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Receive Money
                Row(
                  children: [
                    Text(
                      tr('total_pay'),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF00274D),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      _calculateTotalPay(),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 40),
            // Khoảng cách giữa ListView và nút
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        debugPrint('Continue pressed');
                        Navigator.pushNamed(context, Routes.successDetails);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Continue Pressed!")),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF007AFF),
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
                            "Continue",
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
          ],
        ),
      ),
    );
  }

  Widget _buildContent(double fontSize, double padding) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          midHeader(fontSize, padding),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
