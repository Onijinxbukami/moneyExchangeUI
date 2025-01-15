import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/user_profile/screens/sideBar_screens.dart';
import 'package:flutter_application_1/features/user_profile/screens/header_field.dart';

class DepositMoneyDetails extends StatefulWidget {
  const DepositMoneyDetails({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DepositMoneyDetailsPageState createState() =>
      _DepositMoneyDetailsPageState();
}

class _DepositMoneyDetailsPageState extends State<DepositMoneyDetails> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String selectedValue = 'USD'; // Initialize the selectedValue for Dropdown
  void onChanged(String? newValue) {
    setState(() {
      selectedValue = newValue!;
    });
  }

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
          if (!isMobile) Sidebar(), // Sidebar for web

          // User Information and Content Area
          Expanded(
            child: Column(
              children: [
                // Header Section
                HeaderWidget(), // Assuming HeaderWidget exists

                Expanded(child: _buildContent()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    // Lấy kích thước màn hình
    final screenWidth = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          _buildPaymentDetails(), // Phần chi tiết thanh toán
          const SizedBox(height: 20),

          // Footer với các nút điều hướng
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Button Back
              _buildResponsiveButton(
                text: 'Back',
                onPressed: () {
                  Navigator.pop(context);
                },
                screenWidth: screenWidth,
              ),

              SizedBox(width: 46),
              // Button Next
              _buildResponsiveButton(
                text: 'Next',
                onPressed: () {
                  // Xử lý sự kiện Next
                },
                screenWidth: screenWidth,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildResponsiveButton(
    {required String text,
    required VoidCallback onPressed,
    required double screenWidth}) {
  return Expanded(
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF4743C9), // Màu nền nút
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth > 600 ? 40 : 20, // Padding tùy vào kích thước màn hình
          vertical: 14, // Padding dọc
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6.0), // Bo góc nhỏ hơn
        ),
        elevation: 2, // Hiệu ứng nổi nhẹ
      ),
      child: Text(
        text, // Nội dung nút
        style: TextStyle(
          fontSize: screenWidth > 600 ? 14 : 12, // Kích thước chữ nhỏ hơn cho màn hình nhỏ
          fontWeight: FontWeight.bold, // Trọng lượng chữ vừa
          color: Colors.white,
        ),
      ),
    ),
  );
}


  Widget _buildPaymentDetails() {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white, // Màu nền của khung
        borderRadius: BorderRadius.circular(12), // Bo góc
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2), // Bóng mờ nhẹ
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Area
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Confirm account & amount',
                style: TextStyle(
                  fontSize:
                      screenWidth > 600 ? 24 : 18, // Điều chỉnh kích thước font
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                onTap: () {
                  // Xử lý khi nhấn nút Edit
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Color(0xFFDDE8FF), // Sử dụng màu #DDE8FF
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.edit, color: Colors.black, size: 16),
                      SizedBox(width: 8),
                      Text(
                        'Edit',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const Divider(color: Colors.black),
          const SizedBox(height: 30),

          // Details List
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow('Payment System', 'Paypal', screenWidth),
              const SizedBox(height: 20),
              _buildDetailRow(
                  'Paypal Payment Card', '**** **** **** 1182', screenWidth),
              const SizedBox(height: 20),
              _buildDetailRow('You will receive', '400.00 USD', screenWidth),
              const SizedBox(height: 20),
              _buildDetailRow('Fee', '1 USD', screenWidth),
              const SizedBox(height: 20),
              _buildDetailRow(
                  'E-mail', 'felicia.reid@example.com', screenWidth),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String title, String value, double screenWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: screenWidth > 600 ? 18 : 16, // Điều chỉnh font size
            color: Colors.grey,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: screenWidth > 600 ? 20 : 18, // Điều chỉnh font size
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
