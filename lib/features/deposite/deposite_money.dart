import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/user_profile/screens/sideBar_screens.dart';
import 'package:flutter_application_1/features/user_profile/screens/header_field.dart';
import 'package:flutter_application_1/shared/widgets/numberic_field.dart';
import 'package:flutter_application_1/app/routes.dart';

class DepositMoney extends StatefulWidget {
  const DepositMoney({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DepositMoneyPageState createState() => _DepositMoneyPageState();
}

class _DepositMoneyPageState extends State<DepositMoney> {
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
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),

          // Amount Input Section with Border
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black, // Set border color
                width: 1.0, // Set border width
              ),
              borderRadius:
                  BorderRadius.circular(8), // Rounded corners for the border
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'How much you want to add?',
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                        child:
                            NumericField()), // Ensure NumericField is defined
                    const SizedBox(width: 10),
                    // DropdownButton
                    Expanded(
                      child: DropdownButton<String>(
                        items: const [
                          DropdownMenuItem(value: 'USD', child: Text('USD')),
                          DropdownMenuItem(value: 'EUR', child: Text('EUR')),
                          DropdownMenuItem(value: 'GBP', child: Text('GBP')),
                        ],
                        onChanged: onChanged, // Ensure onChanged is defined
                        value: selectedValue, // Ensure selectedValue is defined
                        underline: Container(),
                        icon: const Icon(Icons.arrow_drop_down,
                            color: Colors.black),
                        dropdownColor: Colors.grey.shade200,
                      ),
                    ),
                  ],
                ),
                const Text(
                  'Available Balance: \$30,700.00',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // Balance Info Section with Border

          const SizedBox(height: 20),

          // Footer Section with Navigation Button
          Row(
            mainAxisAlignment: MainAxisAlignment
                .spaceBetween, // Căn khoảng cách đều giữa các nút
            children: [
              // Button 1
              ElevatedButton(
                onPressed: () {
                  // Xử lý sự kiện bấm
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4743C9), // Màu nền nút
                  padding: const EdgeInsets.symmetric(
                      horizontal: 60, vertical: 14), // Padding nhỏ hơn
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6.0), // Bo góc nhỏ hơn
                  ),
                  elevation: 2, // Hiệu ứng nổi nhẹ
                ),
                child: const Text(
                  'Back', // Nội dung nút
                  style: TextStyle(
                    fontSize: 16, // Kích thước chữ nhỏ hơn
                    fontWeight: FontWeight.bold, // Trọng lượng chữ vừa
                    color: Colors.white,
                  ),
                ),
              ),

              // Button 2
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, Routes.depositeDetails);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4743C9), // Màu nền nút
                  padding: const EdgeInsets.symmetric(
                      horizontal: 60, vertical: 14), // Padding nhỏ hơn
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6.0), // Bo góc nhỏ hơn
                  ),
                  elevation: 2, // Hiệu ứng nổi nhẹ
                ),
                child: const Text(
                  'Next', // Nội dung nút
                  style: TextStyle(
                    fontSize: 16, // Kích thước chữ nhỏ hơn
                    fontWeight: FontWeight.bold, // Trọng lượng chữ vừa
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
