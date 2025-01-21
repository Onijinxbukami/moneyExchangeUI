import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/routes.dart';
import 'package:flutter_application_1/features/home_page/screens/location/location_screen.dart';
import 'package:flutter_application_1/features/home_page/screens/send_money/progressbar.dart';
import 'package:flutter_application_1/features/home_page/screens/send_money/send_screen.dart';
import 'package:flutter_application_1/features/home_page/screens/setting/setting_screen.dart';

class HomepageBankAccountDetailsPage extends StatefulWidget {
  const HomepageBankAccountDetailsPage({super.key});

  @override
  _HomepageBankAccountDetailsPageState createState() =>
      _HomepageBankAccountDetailsPageState();
}

class _HomepageBankAccountDetailsPageState
    extends State<HomepageBankAccountDetailsPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController accountNumberController = TextEditingController();
  final TextEditingController bankCodeController = TextEditingController();

  final List<Map<String, String>> bankCodes = [
    {
      "code": "001",
      "name": "Bank A",
    },
    {
      "code": "002",
      "name": "Bank B",
    },
    {
      "code": "003",
      "name": "Bank C",
    },
    {
      "code": "004",
      "name": "Bank D",
    },
    {
      "code": "005",
      "name": "Bank E",
    },
    {
      "code": "006",
      "name": "Bank F",
    },
    {
      "code": "007",
      "name": "Bank G",
    },
    {
      "code": "008",
      "name": "Bank H",
    },
    {
      "code": "009",
      "name": "Bank I",
    },
    {
      "code": "010",
      "name": "Bank J",
    },
  ];
  List<Map<String, String>> filteredBankCode = [];
  String _selectedLanguage = 'EN';
  @override
  void initState() {
    super.initState();
  }

  void filterdBankCode(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredBankCode = [];
      } else {
        filteredBankCode = bankCodes
            .where((outlet) =>
                (outlet['code'] != null &&
                    outlet['code']!
                        .toLowerCase()
                        .contains(query.toLowerCase())) ||
                (outlet['name'] != null &&
                    outlet['name']!
                        .toLowerCase()
                        .contains(query.toLowerCase())))
            .toList();
      }
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
                "You",
                "Recipient",
                "Review",
                "Pay",
              ],
              currentStep: 2, // Giá trị bước hiện tại
              backgroundColor: Colors.grey[300]!,
              progressColor: Colors.blue,
              height: isSmallScreen ? 8 : 10,
            ),
            SizedBox(height: isSmallScreen ? 16 : 24),

            // TabBar phía trên nội dung chính

            const SizedBox(height: 16),

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
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        // Thêm SingleChildScrollView để cuộn dọc
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'Enter Your Bank Account Details',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF00274D),
                ),
              ),
            ),
            const Divider(color: Colors.black),

            const SizedBox(height: 10),
            Text(
              'Recipient bank details',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFF00274D),
              ),
            ),

            const SizedBox(height: 10),
            const Text(
              'Full name of the account holder',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Color(0xFF00274D),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Enter your text',
                hintText: 'Type something...',
                labelStyle: TextStyle(fontSize: fontSize),
                hintStyle:
                    TextStyle(fontSize: fontSize * 0.9, color: Colors.grey),
                contentPadding: EdgeInsets.symmetric(
                    vertical: padding, horizontal: padding),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey, width: 1.5),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.blue, width: 2.0),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.red, width: 1.5),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.red, width: 2.0),
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              style: TextStyle(fontSize: fontSize),
            ),
            const SizedBox(height: 10),
            const Text(
              'Account number',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Color(0xFF00274D),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: accountNumberController,
              decoration: InputDecoration(
                labelText: 'Enter your text',
                hintText: 'Type something...',
                labelStyle: TextStyle(fontSize: fontSize),
                hintStyle:
                    TextStyle(fontSize: fontSize * 0.9, color: Colors.grey),
                contentPadding: EdgeInsets.symmetric(
                    vertical: padding, horizontal: padding),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey, width: 1.5),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.blue, width: 2.0),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.red, width: 1.5),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.red, width: 2.0),
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              style: TextStyle(fontSize: fontSize),
            ),
            const SizedBox(height: 10),

            const Text(
              'Bank code',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Color(0xFF00274D),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: bankCodeController,
              onChanged: filterdBankCode,
              decoration: InputDecoration(
                labelText: 'Enter your text',
                hintText: 'Type something...',
                labelStyle: TextStyle(fontSize: fontSize),
                hintStyle:
                    TextStyle(fontSize: fontSize * 0.9, color: Colors.grey),
                contentPadding: EdgeInsets.symmetric(
                    vertical: padding, horizontal: padding),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey, width: 1.5),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.blue, width: 2.0),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.red, width: 1.5),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.red, width: 2.0),
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              style: TextStyle(fontSize: fontSize),
            ),
            const SizedBox(height: 20),

            // Danh sách gợi ý
            SingleChildScrollView(
              child: Column(
                children: [
                  ListView.builder(
                    shrinkWrap:
                        true, // Make the ListView take up only the space it needs
                    itemCount: filteredBankCode.length,
                    itemBuilder: (context, index) {
                      var bankCode = filteredBankCode[index];
                      return ListTile(
                        title: Text(bankCode['code'] ??
                            'No Code'), // Fallback if 'code' is null
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(bankCode['name'] ??
                                'No Name'), // Fallback if 'name' is null
                            const SizedBox(height: 5),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40), // Khoảng cách giữa ListView và nút
            Center(
                child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, Routes.addressDetails);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Continue Pressed!")),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6200EE),
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width < 600 ? 40 : 80,
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
            )),
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
