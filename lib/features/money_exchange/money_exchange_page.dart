import 'package:flutter/material.dart';

import 'package:flutter_application_1/features/user_profile/screens/sideBar_screens.dart';
import 'package:flutter_application_1/features/user_profile/screens/header_field.dart';

class MoneyExchangePage extends StatefulWidget {
  const MoneyExchangePage({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _MoneyExchangePageState createState() => _MoneyExchangePageState();
}

class _MoneyExchangePageState extends State<MoneyExchangePage> {
  String selectedDeliveryMethod = 'Bank Transfer'; // Default delivery method
  String selectedPartnerBank = 'HSBC';
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<String> deliveryMethods = [
    'Bank Transfer',
    'Cash Pickup',
    'Mobile Wallet'
  ];
  final List<String> partnerBanks = ['HSBC', 'Standard Chartered', 'Citibank'];

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: const Color(0xFF6610F2),
        leading: isMobile
            ? IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {
                  _scaffoldKey.currentState?.openDrawer();
                },
              )
            : null,
      ),
      drawer: isMobile ? Sidebar() : null,
      body: Row(
        children: [
          if (!isMobile) Sidebar(), // Sidebar cố định trên web

          // User Information and Content Area
          Expanded(
            child: Column(
              children: [
                // Header Section
                HeaderWidget(), // Giả sử bạn đã có widget HeaderWidget
                // Content Section
                Expanded(child: _buildContent()),
              ],
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
                        amount: '400.00',

                        flag: Icons.flag, // Placeholder for flag icon
                      ),
                      const SizedBox(height: 10),
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
                                          overflow: TextOverflow
                                              .ellipsis, // Cắt chữ dài
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
                        amount: '45162.98',

                        flag: Icons.flag, // Placeholder for flag icon
                        cardColor: const Color(0xFFEAE6FA),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Bank Transfer',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF00274D),
                        ),
                      ),
                      const SizedBox(height: 5),
                      // Dropdown for Partner Bank
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade400),
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white,
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: selectedPartnerBank,
                            items: partnerBanks.map((bank) {
                              return DropdownMenuItem(
                                value: bank,
                                child: SizedBox(
                                  width: 150, // Cố định chiều rộng
                                  child: Text(
                                    bank,
                                    overflow:
                                        TextOverflow.ellipsis, // Cắt chữ dài
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedPartnerBank = value!;
                              });
                            },
                            isExpanded:
                                true, // Đảm bảo chiếm toàn bộ chiều rộng
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
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
                      // Hành động khi bấm nút Continue
                      debugPrint('Continue pressed');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(0xFF6200EE), // Màu tím nổi bật
                      padding: const EdgeInsets.symmetric(
                          horizontal: 60, vertical: 30), // Padding nhỏ hơn
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(20), // Bo tròn góc nút
                      ),
                      elevation: 6, // Hiệu ứng đổ bóng
                      // ignore: deprecated_member_use
                      shadowColor: Colors.grey.withOpacity(0.5), // Màu bóng nhẹ
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.arrow_forward,
                            color: Colors.white, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Continue',
                          style: TextStyle(
                            fontSize: 20,
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

  Widget _buildContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          midHeader(),
          const SizedBox(height: 20),
          // Now works correctly
        ],
      ),
    );
  }

  Widget _buildExchangeCard({
    required String title,
    required String amount,
    required IconData flag,
    Color cardColor = Colors.white,
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
                child: Text(
                  amount,
                  style: TextStyle(
                    fontSize: isMobile ? 18 : 24, // Adjust font size
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              Icon(flag,
                  size: isMobile ? 20 : 24,
                  color: Colors.black), // Adjust icon size
              const SizedBox(width: 5),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
