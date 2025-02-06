import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/routes.dart';
import 'package:flutter_application_1/features/home_page/screens/location/location_screen.dart';
import 'package:flutter_application_1/features/home_page/screens/send_money/progressbar.dart';
import 'package:flutter_application_1/features/home_page/screens/setting/setting_screen.dart';

class HomepageAddressPage extends StatefulWidget {
  const HomepageAddressPage({super.key});

  @override
  _HomepageAddressPageState createState() => _HomepageAddressPageState();
}

class _HomepageAddressPageState extends State<HomepageAddressPage> {
  final TextEditingController locationController = TextEditingController();
  String fromCurrency = "GBP";
  String toCurrency = "USD";
  String _selectedLanguage = 'EN';
  final TextEditingController sendNameController =
      TextEditingController(text: "John Doe");
  final TextEditingController sendDobController =
      TextEditingController(text: "1990-01-01");
  final TextEditingController sendPhoneController =
      TextEditingController(text: "+123456789");
  final TextEditingController sendEmailController =
      TextEditingController(text: "johndoe@example.com");

  final TextEditingController receiverNameController =
      TextEditingController(text: "Doe Tech");
  final TextEditingController receiverNumberController =
      TextEditingController(text: "1234567890");
  final TextEditingController receiverBankCodeController =
      TextEditingController(text: "Bank A");

  final TextEditingController outletController =
      TextEditingController(text: "Outlet 1");
  final TextEditingController senMoneyController =
      TextEditingController(text: "100.000");
  final TextEditingController receiverMoneyController =
      TextEditingController(text: "200.000");

  final TextEditingController rateController =
      TextEditingController(text: "1,7");
  final TextEditingController feesController =
      TextEditingController(text: "10");
  final TextEditingController getMoneyController =
      TextEditingController(text: "200.000");

  String? _numericError;
  final TextEditingController _numericController = TextEditingController();

  void _updateLabels(String value) {
    // Cập nhật dữ liệu ở đây
  }
  void _validateNumeric() {
    final input = _numericController.text;

    // Check if the input contains only numbers (no letters or special characters)
    if (input.isNotEmpty && !RegExp(r'^[0-9]+$').hasMatch(input)) {
      setState(() {
        _numericError = "Only numbers are allowed!";
      });
    } else {
      setState(() {
        _numericError = null; // Clear error if the input is valid
      });
    }
  }

  final Map<String, String> flagUrls = {
    "GBP": "https://flagcdn.com/w40/gb.png",
    "USD": "https://flagcdn.com/w40/us.png",
  };
  DropdownMenuItem<String> _buildDropdownItem(String currency) {
    return DropdownMenuItem(
      value: currency,
      child: Row(
        children: [
          Image.network(flagUrls[currency]!,
              width: 24, height: 16, fit: BoxFit.cover),
          const SizedBox(width: 8),
          Text(currency, style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
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
        appBar: AppBar(
          backgroundColor: const Color(0xFF6610F2),
          title: _buildHeader(),
        ),
        body: Column(
          children: [
            const SizedBox(height: 20),
            ProgressStepper(
              steps: const [
                "Amount",
                "Sender",
                "Recipient",
                "Review",
                "Success",
              ],
              currentStep: 3, // Giá trị bước hiện tại
              backgroundColor: Colors.grey[300]!,
              progressColor: Colors.blue,
              height: isSmallScreen ? 8 : 10,
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
              child: const TabBar(
                indicatorColor: Colors.white,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.grey,
                tabs: [
                  Tab(text: 'Near me', icon: Icon(Icons.notifications)),
                  Tab(text: 'Send', icon: Icon(Icons.security)),
                  Tab(text: 'Setting', icon: Icon(Icons.new_releases)),
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween, // Canh đều giữa Dropdown và Login
        children: [
          // Dropdown chọn ngôn ngữ
          DropdownButton<String>(
            value: _selectedLanguage,
            dropdownColor: Colors.white,
            items: ['EN', 'BN', 'ES', 'NL']
                .map(
                  (lang) => DropdownMenuItem(
                    value: lang,
                    child: Text(
                      lang,
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                )
                .toList(),
            onChanged: (value) {
              setState(() {
                _selectedLanguage = value!;
              });
            },
          ),
          // Nút Login
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, Routes.login);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'LOGIN',
                style: TextStyle(color: Colors.white),
              ),
            ),
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
              'Sender details',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFF00274D),
              ),
            ),
            const Divider(color: Colors.black),
            const SizedBox(height: 10),
// Full Name Field
            TextField(
              controller: sendNameController,
              decoration: InputDecoration(
                hintText: "Full legal first and middle name",
                prefixIcon: Icon(
                  Icons.person,
                  color: Color(0xFF00274D), // Màu cho icon dễ nhìn
                ),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                contentPadding: EdgeInsets.symmetric(
                    vertical: 16, horizontal: 12), // Giảm chiều cao cho phù hợp
              ),
              onChanged: (value) => _updateLabels(value),
            ),

            const SizedBox(height: 20),

// Date of Birth Field
            TextField(
              controller: sendDobController,
              readOnly: true,
              decoration: InputDecoration(
                hintText: "Date of Birth",
                prefixIcon: Icon(
                  Icons.calendar_today,
                  color: Color(0xFF00274D),
                ),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              ),
              onTap: () async {
                DateTime? selectedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );
                if (selectedDate != null) {
                  sendDobController.text =
                      "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}";
                }
              },
            ),

            const SizedBox(height: 20),

// Phone Number Field
            TextField(
              controller: sendPhoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                hintText: "Phone Number",
                prefixIcon: Icon(
                  Icons.phone,
                  color: Color(0xFF00274D),
                ),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              ),
              onChanged: (value) => _updateLabels(value),
            ),

            const SizedBox(height: 20),

// Email Field
            TextField(
              controller: sendEmailController,
              decoration: InputDecoration(
                hintText: "Email Address",
                prefixIcon: Icon(
                  Icons.email,
                  color: Color(0xFF00274D),
                ),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              ),
              onChanged: (value) => _updateLabels(value),
            ),
            const SizedBox(height: 20),

            Text(
              'Recipient details',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFF00274D),
              ),
            ),
            const Divider(color: Colors.black),
            const SizedBox(height: 20),

            TextField(
              controller: receiverNameController,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.email,
                  color: Color(0xFF00274D),
                ),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              ),
              onChanged: (value) => _updateLabels(value),
            ),
            const SizedBox(height: 20),

            TextField(
              controller: receiverNumberController,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.email,
                  color: Color(0xFF00274D),
                ),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              ),
              onChanged: (value) => _updateLabels(value),
            ),
            const SizedBox(height: 20),

            TextField(
              controller: receiverBankCodeController,
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.email,
                  color: Color(0xFF00274D),
                ),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              ),
              onChanged: (value) => _updateLabels(value),
            ),
            const SizedBox(height: 20),

            Text(
              'Transaction details',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFF00274D),
              ),
            ),
            const Divider(color: Colors.black),
            const SizedBox(height: 20),
// Outlet Field
            const Text(
              'Outlet',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Color(0xFF00274D),
              ),
            ),

            TextField(
              controller: outletController,
              decoration: InputDecoration(
                hintText: "Outlet",
                prefixIcon: Icon(
                  Icons.store,
                  color: Color(0xFF00274D),
                ),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              ),
              onChanged: (value) => _updateLabels(value),
            ),

            const SizedBox(height: 20),

// Send Money Field
            _buildCurrencyInputField(
              "Send",
              fromCurrency,
              (value) {
                setState(() {
                  fromCurrency = value!;
                  toCurrency = (value == "USD") ? "GBP" : "USD";
                });
              },
              isSmallScreen,
              senMoneyController,
              isSender: true, // Quan trọng để xác định trường gửi tiền
            ),
            SizedBox(height: isSmallScreen ? 16 : 24),

// Receiver Money Field
            _buildCurrencyInputField(
              "Get",
              toCurrency,
              (value) {
                setState(() {
                  fromCurrency = value!;
                  toCurrency = (value == "USD") ? "GBP" : "USD";
                });
              },
              isSmallScreen,
              receiverMoneyController,
              isSender: true, // Quan trọng để xác định trường gửi tiền
            ),
            SizedBox(height: isSmallScreen ? 16 : 24),

// Rate Field
            const Text(
              'Rate',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Color(0xFF00274D),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: rateController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                hintText: "Exchange Rate",
                prefixIcon: Icon(
                  Icons.arrow_upward,
                  color: Color(0xFF00274D),
                ),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              ),
              onChanged: (value) => _updateLabels(value),
            ),

            const SizedBox(height: 20),

// Fees Field
            const Text(
              'Fees',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Color(0xFF00274D),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: feesController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Fees",
                prefixIcon: Icon(
                  Icons.money_off,
                  color: Color(0xFF00274D),
                ),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              ),
              onChanged: (value) => _updateLabels(value),
            ),

            const SizedBox(height: 20),

// Get Money Field
            const Text(
              'Receive Money',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Color(0xFF00274D),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: getMoneyController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Amount to Receive",
                prefixIcon: Icon(
                  Icons.attach_money,
                  color: Color(0xFF00274D),
                ),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              ),
              onChanged: (value) => _updateLabels(value),
            ),

            const SizedBox(height: 40),
            // Khoảng cách giữa ListView và nút
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, Routes.successDetails);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Continue Pressed!")),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6200EE),
                  padding: EdgeInsets.symmetric(
                    horizontal:
                        MediaQuery.of(context).size.width < 600 ? 40 : 80,
                    vertical: MediaQuery.of(context).size.width < 600 ? 12 : 16,
                  ),
                  minimumSize: Size(
                    double.infinity,
                    MediaQuery.of(context).size.width < 600 ? 48 : 56,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  elevation: 6,
                  shadowColor: Colors.grey.withOpacity(0.5),
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
                        fontSize:
                            MediaQuery.of(context).size.width < 600 ? 16 : 20,
                        fontWeight: FontWeight.bold,
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
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
          ),
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            children: [
              DropdownButton<String>(
                value: selectedValue,
                items: [
                  _buildDropdownItem("GBP"),
                  _buildDropdownItem("USD"),
                ],
                onChanged: (value) {
                  setState(() {
                    if (isSender) {
                      fromCurrency = value!;
                      toCurrency = (value == "USD") ? "GBP" : "USD";
                    } else {
                      toCurrency = value!;
                      fromCurrency = (value == "USD") ? "GBP" : "USD";
                    }
                  });
                },
                underline: Container(),
                icon: const Icon(Icons.arrow_drop_down),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  onChanged: (value) => _validateNumeric(),
                  decoration: InputDecoration(
                    hintText: "Enter amount",
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
