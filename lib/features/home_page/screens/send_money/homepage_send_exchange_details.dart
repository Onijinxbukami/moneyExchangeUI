import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/routes.dart';
import 'package:flutter_application_1/features/home_page/screens/location/location_screen.dart';
import 'package:flutter_application_1/features/home_page/screens/send_money/progressbar.dart';
import 'package:flutter_application_1/features/home_page/screens/setting/setting_screen.dart';

class HomepageMoneyExchangeDetailsPage extends StatefulWidget {
  const HomepageMoneyExchangeDetailsPage({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _HomepageMoneyExchangeDetailsPageState createState() =>
      _HomepageMoneyExchangeDetailsPageState();
}

class _HomepageMoneyExchangeDetailsPageState
    extends State<HomepageMoneyExchangeDetailsPage> {

  final TextEditingController youSendController = TextEditingController();
  final TextEditingController recipientGetsController = TextEditingController();
  String selectedDeliveryMethod =
      'Wireless Transfer'; // Default delivery method
  String selectedPartnerBank = 'HSBC';

  final List<String> deliveryMethods = [
    'Wireless Transfer',
    'Cash Pickup',
    'Mobile Wallet'
  ];
  final List<String> partnerBanks = ['HSBC', 'Standard Chartered', 'Citibank'];
  String _selectedLanguage = 'EN';

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
              currentStep: 0, // Giá trị bước hiện tại
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

                  SettingForm(),  // Nội dung cho "Setting"
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

  Widget midHeader() {
    bool isMobile = MediaQuery.of(context).size.width < 600;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          const Text(
            'Money Exchange',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF00274D),
            ),
          ),
          const Divider(height: 20, thickness: 1, color: Colors.grey),
          const SizedBox(height: 10),

          // Money Exchange Cards
          Row(
            children: [
              // "You Send" Card
              Expanded(
                child: Container(
                  padding: isMobile
                      ? const EdgeInsets.all(10)
                      : const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildExchangeCard(
                        title: 'You Send',
                        amountController: youSendController,
                        isEditable: true,
                        flag: Icons.money, // Placeholder for flag icon
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              // Swap Icon (For larger screens you can position it in the center)
              if (!isMobile) ...[
                const CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.purple,
                  child: Icon(Icons.swap_horiz, color: Colors.white),
                ),
                const SizedBox(width: 10),
              ],
              // "Recipient Gets" Card
              Expanded(
                child: Container(
                  padding: isMobile
                      ? const EdgeInsets.all(10)
                      : const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildExchangeCard(
                        title: 'Recipient Gets',
                        amountController: recipientGetsController,
                        isEditable: false,
                        flag: Icons.flag, // Placeholder for flag icon
                        cardColor: const Color(0xFFEAE6FA),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const Text(
            'Delivery Method',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF00274D),
            ),
          ),
          const SizedBox(height: 5),
          // Dropdown for Delivery Method
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedDeliveryMethod,
                items: deliveryMethods
                    .map((method) => DropdownMenuItem(
                          value: method,
                          child: SizedBox(
                            width: 150, // Cố định chiều rộng
                            child: Text(
                              method,
                              overflow: TextOverflow.ellipsis, // Cắt chữ dài
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF00274D),
                              ),
                            ),
                          ),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedDeliveryMethod = value!;
                  });
                },
                icon: const Icon(
                  Icons.arrow_drop_down,
                  color: Color(0xFF00274D),
                ),
                dropdownColor: Colors.white,
                isExpanded: true,
              ),
            ),
          ),
          const SizedBox(height: 30),

          // Transaction details
          _buildTransactionDetail(
            title: 'Estimated fee',
            value: '+0.33 GBP',
          ),
          const SizedBox(height: 20),
          _buildTransactionDetail(
            title: 'Transfer time',
            value: 'Same Day',
          ),
          const Divider(color: Colors.black),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100, // Nền sáng
              borderRadius: BorderRadius.circular(10), // Bo góc
              boxShadow: [
                BoxShadow(
                  // ignore: deprecated_member_use
                  color: Colors.black.withOpacity(0.1), // Bóng nhẹ
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: _buildTransactionDetail(
              title: 'Total Pay',
              value: 'Same Day',
              titleStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              valueStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Color(0xFF6200EE), // Màu tím nổi bật
              ),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100, // Nền sáng
              borderRadius: BorderRadius.circular(10), // Bo góc
              boxShadow: [
                BoxShadow(
                  // ignore: deprecated_member_use
                  color: Colors.black.withOpacity(0.1), // Bóng nhẹ
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: _buildTransactionDetail(
              title: 'Recipient gets',
              value: 'Same Day',
              titleStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              valueStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Color(0xFF6200EE), // Màu tím nổi bật
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Divider(color: Colors.black),

          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                    height: 30), // Khoảng cách giữa dropdown và nút Continue
                Center(
                    child: ElevatedButton(
                  onPressed: () {
                    debugPrint('Continue pressed');
                    Navigator.pushNamed(context, Routes.userDetails);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Continue Pressed!")),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6200EE),
                    padding: EdgeInsets.symmetric(
                      horizontal:
                          MediaQuery.of(context).size.width < 600 ? 40 : 80,
                      vertical:
                          MediaQuery.of(context).size.width < 600 ? 12 : 16,
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
        ],
      ),
    );
  }

  Widget _buildTransactionDetail({
    required String title,
    required String value,
    TextStyle? titleStyle,
    TextStyle? valueStyle,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: titleStyle ??
              const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        Text(
          value,
          style:
              valueStyle ?? const TextStyle(fontSize: 16, color: Colors.black),
        ),
      ],
    );
  }

  Widget _buildContent(double fontSize, double padding) {
    return Expanded(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            midHeader(),
            const SizedBox(height: 20),
            // Thêm các widget khác tại đây nếu cần
          ],
        ),
      ),
    );
  }

  Widget _buildExchangeCard({
    required String title,
    required TextEditingController amountController,
    required IconData flag,
    Color cardColor = Colors.white,
    bool isEditable = true, // Thêm tuỳ chọn để kiểm soát khả năng chỉnh sửa
  }) {
    bool isMobile = MediaQuery.of(context).size.width < 600;

    return Container(
      padding: isMobile ? const EdgeInsets.all(12) : const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: isMobile ? 14 : 16, // Adjust size based on screen size
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: amountController,
                  readOnly:
                      !isEditable, // Không cho phép chỉnh sửa nếu isEditable là false
                  keyboardType: TextInputType.number,
                  style: TextStyle(
                    fontSize: isMobile ? 18 : 24, // Adjust font size
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter amount',
                  ),
                ),
              ),
              Icon(
                flag,
                size: isMobile ? 20 : 24, // Adjust icon size
                color: Colors.black,
              ),
              const SizedBox(width: 5),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
